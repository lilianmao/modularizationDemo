//
//  ModuleProtocolManager.m
//  modularizationDemo
//
//  Created by 李林 on 2017/11/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ModuleProtocolManager.h"

@interface ModuleProtocolManager()

@property (nonatomic, strong) NSMutableDictionary *serviceProvideSource;

@end

@implementation ModuleProtocolManager

+ (ModuleProtocolManager *)sharedInstance {
    static ModuleProtocolManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _serviceProvideSource = @{}.mutableCopy;
    }
    return self;
}

+ (void)registerServiceAProvide:(id)provide forProtocol:(Protocol *)protocol {
    if (provide==nil || protocol==nil) {
        return ;
    }
    [[self sharedInstance].serviceProvideSource setObject:provide forKey:NSStringFromProtocol(protocol)];
}

+ (id)serviceAProvideForProtocol:(Protocol *)protocol {
    return [[self sharedInstance].serviceProvideSource objectForKey:NSStringFromProtocol(protocol)];
}

@end
