//
//  ModuleProtocolManager.h
//  modularizationDemo
//
//  Created by 李林 on 2017/11/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModuleProtocolManager : NSObject

+ (void)registerServiceAProvide:(id)provide forProtocol:(Protocol *)protocol;
+ (id)serviceAProvideForProtocol:(Protocol *)protocol;

@end
