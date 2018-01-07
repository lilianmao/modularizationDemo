//
//  LLModuleTree.m
//  LLModularization
//
//  Created by 李林 on 12/22/17.
//

#import "LLModuleTree.h"

#pragma mark - LLModuleTreeNode

@implementation LLModuleTreeNode

- (instancetype)initTreeNodeWithModuleName:(NSString *)moduleName
                         andSequenceNumber:(int)sequenceNumber {
    if (self = [super init]) {
        _moduleName = moduleName;
        _sequenceNumber = sequenceNumber;
        _childs = @[];
    }
    return self;
}

@end

#pragma mark - LLModuleTreeCallStack

@implementation LLModuleTreeCallStack

- (instancetype)initWithModuleCallStack:(NSArray *)callStack
                             andService:(NSString *)service
                         andServiceType:(LLModuleTreeServiceType)serviceType {
    if (self = [super init]) {
        _moduleCallStack = callStack;
        _service = service;
        _serviceType = serviceType;
    }
    return self;
}

- (NSString *)description {
    NSString *callStackStr = [_moduleCallStack componentsJoinedByString:@"."];
    return [NSString stringWithFormat:@"callStack:%@, service:%@, serviceType:%@", callStackStr, _service, [self formatToString:_serviceType]];
}

- (NSString *)formatToString:(LLModuleTreeServiceType)type {
    NSString *result = nil;
    
    switch (type) {
        case LLModuleTreeServiceTypeForeground:
            result = @"Foreground";
            break;
         case LLModuleTreeServiceTypeBackground:
            result = @"Background";
            break;
        default:
            result = @"None";
            break;
    }
    
    return result;
}

@end

#pragma mark - LLModuleTree

@interface LLModuleTree()

@property (nonatomic, strong) LLModuleTreeNode *root;
@property (nonatomic, assign) int incrementSeqNumber;
@property (nonatomic, strong) LLModuleTreeNode *callerNode;

@property (nonatomic, strong) NSMutableArray *tempStack;
@property (nonatomic, copy) NSArray *callStack;

@end

@implementation LLModuleTree

#pragma mark - sharedInstance

+ (instancetype)sharedTree {
    static dispatch_once_t onceToken;
    static LLModuleTree *sharedTree = nil;
    
    dispatch_once(&onceToken, ^{
        sharedTree = [[LLModuleTree alloc] init];
    });
    
    return sharedTree;
}

#pragma mark - Tree Method

- (void)initTreeWithRootStr:(NSString *)rootStr {
    if (!_root) {
        self.incrementSeqNumber = 0;    // 根节点序号初始化为0。
        _root = [[LLModuleTreeNode alloc] initTreeNodeWithModuleName:rootStr andSequenceNumber:self.incrementSeqNumber++];
    }
}

/**
 找到最新的与该节点同名的节点
 */
- (void)findNodeInHighestSequenceNumberWithTreeNode:(LLModuleTreeNode *)root
                                      andModuleName:(NSString *)moduleName {
    if ([root.moduleName isEqualToString:moduleName] && root.sequenceNumber >= self.callerNode.sequenceNumber) {
        self.callerNode = root;
    }
    if (root.childs.count == 0) {
        return ;
    } else {
        for (int i=0; i<root.childs.count; i++) {
            [self findNodeInHighestSequenceNumberWithTreeNode:root.childs[i] andModuleName:moduleName];
        }
    }
}

/**
 根据节点找出链路
 */
- (void)getCallStackWithRootNode:(LLModuleTreeNode *)root
                   andCalleeNode:(LLModuleTreeNode *)calleeNode {
    if ([root.moduleName isEqualToString:calleeNode.moduleName] && root.sequenceNumber == calleeNode.sequenceNumber) {
        [_tempStack addObject:root.moduleName];
        _callStack = [_tempStack copy];
        return ;
    }
    if (root.childs.count == 0) {
        return ;
    } else {
        [_tempStack addObject:root.moduleName];
        for (int i=0; i<root.childs.count; i++) {
            [self getCallStackWithRootNode:root.childs[i] andCalleeNode:calleeNode];
        }
        [_tempStack removeLastObject];
    }
}

#pragma mark - append

+ (void)appendCaller:(NSString *)callerStr
           andCallee:(NSString *)calleeStr
          andService:(NSString *)service
      andServiceType:(LLModuleTreeServiceType)serviceType {
    LLModuleTree *tree = [LLModuleTree sharedTree];
    if (!tree.root) {
        [tree initTreeWithRootStr:callerStr];
        tree.tempStack = @[].mutableCopy;
    }
    
    [tree findNodeInHighestSequenceNumberWithTreeNode:tree.root andModuleName:callerStr];
    if (tree.callerNode) {
        // 初始化一个被调用者节点，加载调用者的childs数组中。
        LLModuleTreeNode *calleeNode = [[LLModuleTreeNode alloc] initTreeNodeWithModuleName:calleeStr andSequenceNumber:tree.incrementSeqNumber++];
        NSMutableArray *childNodes = [tree.callerNode.childs mutableCopy];
        [childNodes addObject: calleeNode];
        tree.callerNode.childs = [childNodes copy];
        
        // 获取到被调用者节点的链路
        [tree getCallStackWithRootNode:tree.root andCalleeNode:calleeNode];
        if (tree.callStack) {
            LLModuleTreeCallStack *stack = [[LLModuleTreeCallStack alloc] initWithModuleCallStack:tree.callStack andService:service andServiceType:serviceType];
            NSLog(@"%@", stack);
        } else {
            NSLog(@"Internal Error.");
        }
    } else {
        NSLog(@"Internal Error.");
    }
    
    // 重置
    tree.callerNode = nil;
    [tree.tempStack removeAllObjects];
}

@end

