//
//  LLModuleTree.h
//  LLModularization
//
//  Created by 李林 on 12/22/17.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LLModuleTreeServiceType) {
    LLModuleTreeServiceTypeNone = 0,
    LLModuleTreeServiceTypeForeground = 1,      // 前台，一般是页面跳转。
    LLModuleTreeServiceTypeBackground = 2       // 后台，一般是非页面跳转，请求数据服务。
};

/**
 树的节点
 */
@interface LLModuleTreeNode : NSObject

@property (nonatomic, strong) NSArray<LLModuleTreeNode *> *childs;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, assign) int sequenceNumber;

- (instancetype)initTreeNodeWithModuleName:(NSString *)moduleName
                         andSequenceNumber:(int)sequenceNumber;

@end

/**
 调用信息封装
 */
@interface LLModuleTreeCallStack : NSObject

@property (nonatomic, copy) NSArray *moduleCallStack;
@property (nonatomic, copy) NSString *service;
@property (nonatomic, assign) LLModuleTreeServiceType serviceType;

- (instancetype)initWithModuleCallStack:(NSArray *)callStack
                             andService:(NSString *)service
                         andServiceType:(LLModuleTreeServiceType)serviceType;

@end

@interface LLModuleTree : NSObject

@property (nonatomic, strong, readonly) LLModuleTreeNode *root;

+ (void)appendCaller:(NSString *)callerStr
           andCallee:(NSString *)calleeStr
          andService:(NSString *)service
      andServiceType:(LLModuleTreeServiceType)serviceType;

@end

