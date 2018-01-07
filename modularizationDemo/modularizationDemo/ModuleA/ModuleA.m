//
//  ModuleA.m
//  modularizationDemo
//
//  Created by 李林 on 2017/11/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ModuleA.h"
#import "ModuleAProtocol.h"
#import "ModuleProtocolManager.h"

#import "moduleAViewController.h"

@interface ModuleA() <ModuleAProtocol>

@end

@implementation ModuleA

+(void)load {
    [ModuleProtocolManager registerServiceAProvide:[[self alloc] init] forProtocol:@protocol(ModuleAProtocol)];
}

- (UIViewController *)moduleAViewControllerWithId:(NSString *)Id Name:(NSString *)name {
    moduleAViewController *moduleAVC = [[moduleAViewController alloc] initWithId:Id Name:name];
    return moduleAVC;
}

@end
