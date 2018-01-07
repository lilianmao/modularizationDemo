//
//  ModuleAProtocol.h
//  modularizationDemo
//
//  Created by 李林 on 2017/11/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ModuleAProtocol <NSObject>

@required
- (UIViewController *)moduleAViewControllerWithId:(NSString*)Id Name:(NSString *)name;

@end
