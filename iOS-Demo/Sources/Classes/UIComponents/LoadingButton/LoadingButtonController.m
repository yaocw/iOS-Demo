//
//  LoadingButtonController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/14.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "LoadingButtonController.h"
#import "LBButton.h"

@interface LoadingButtonController ()

@end

@implementation LoadingButtonController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{    
    [self setupLoginButton];
}

- (void)setupLoginButton
{
    kWeakSelf(weakSelf);
    
    LBButton *loginBtn = [[LBButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 66.f)];
    loginBtn.center = CGPointMake(kDeviceWidth * 0.5f, kDeviceHeight * 0.5f);
    loginBtn.translateBlock = ^{
        
        [weakSelf setupLoginButton];
    };
    [self.view addSubview:loginBtn];
}

@end
