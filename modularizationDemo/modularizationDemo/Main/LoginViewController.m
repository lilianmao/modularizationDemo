//
//  LoginViewController.m
//  modularizationDemo
//
//  Created by 李林 on 12/21/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "LoginViewController.h"
#import <PureLayout/PureLayout.h>
#import "LLMacro.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIButton *pushBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self layoutViews];
}

#pragma mark - setup & layout

- (void)setupViews {
    _pushBtn = [[UIButton alloc] init];
    [self.view addSubview:_pushBtn];
    _pushBtn.backgroundColor = LLURGB(58, 199, 215);
    [_pushBtn setTitle:@"push" forState:UIControlStateNormal];
    _pushBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    _pushBtn.layer.cornerRadius = 5.f;
    [_pushBtn addTarget:self action:@selector(pushBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutViews {
    [_pushBtn autoSetDimensionsToSize:CGSizeMake(100.f, 50.f)];
    [_pushBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_pushBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:200.f];
}

- (void)pushBtnAction {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

@end
