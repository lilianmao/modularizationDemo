//
//  moduleAViewController.m
//  modularizationDemo
//
//  Created by 李林 on 2017/11/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "moduleAViewController.h"

@interface moduleAViewController ()

@end

@implementation moduleAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (instancetype)initWithId:(NSString *)Id Name:(NSString *)name {
    if (self = [super init]) {
        NSLog(@"id:%@ name:%@", Id, name);
    }
    return self;
}

@end
