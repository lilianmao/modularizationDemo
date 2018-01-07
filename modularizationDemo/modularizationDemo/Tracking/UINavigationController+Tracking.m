//
//  UINavigationController+Tracking.m
//  modularizationDemo
//
//  Created by 李林 on 12/21/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "UINavigationController+Tracking.h"
#import <objc/runtime.h>
#import "LoginViewController.h"

@implementation UINavigationController (Tracking)

#pragma mark - Method Swizzling

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(my_popViewControllerAnimated:)));
}

- (nullable UIViewController *)my_popViewControllerAnimated:(BOOL)animated {
    if ([self.topViewController isKindOfClass:[LoginViewController class]]) {
        NSLog(@"loginVC pop.");
    }
    return [self my_popViewControllerAnimated:animated];
}

@end
