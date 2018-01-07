//
//  StackForNSObject.m
//  LLModularization
//
//  Created by 李林 on 12/19/17.
//

#import "StackForNSObject.h"

@interface StackForNSObject()

@property (nonatomic, strong) NSMutableArray *stackArray;
@property (nonatomic, strong) Class itemClass;

@end

@implementation StackForNSObject

#pragma mark - init

- (instancetype)init {
    if (self  = [super init]) {
        [self initStack];
    }
    return self;
}

- (void)initStack {
    
}

- (NSMutableArray *)stackArray {
    if (!_stackArray) {
        _stackArray = @[].mutableCopy;
    }
    return _stackArray;
}

#pragma mark - API

- (BOOL)isEmpty {
    return self.stackArray.count==0;
}

- (NSInteger)size {
    return self.stackArray.count;
}

- (id)top {
    return self.stackArray.lastObject;
}

- (void)pushObj:(id)obj {
    if ([self isEmpty]) {
        _itemClass = [obj class];
        [self.stackArray addObject:obj];
    } else if ([obj isKindOfClass:_itemClass]){
        [self.stackArray addObject:obj];
    }
}

- (id)pop {
    if ([self isEmpty]) {
        return nil;
    } else {
        id lastObj = self.stackArray.lastObject;
        [self.stackArray removeLastObject];
        return lastObj;
    }
}

- (void)removeAllObjects {
    self.stackArray = @[].mutableCopy;
}

- (NSArray *)getAllObjects {
    return [self.stackArray copy];
}

@end
