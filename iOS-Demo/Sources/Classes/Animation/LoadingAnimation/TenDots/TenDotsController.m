//
//  TenDotsController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "TenDotsController.h"

#import "TDDotsView.h"

@interface TenDotsController ()

@end

@implementation TenDotsController

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
    
    TDDotsView *dotsView = [[TDDotsView alloc] initWithFrame:CGRectMake(0.f, 0.f, kDeviceWidth, kDeviceHeight) dotSize:CGSizeMake(20.f, 20.f) animationDuration:0.1f numberOfDots:8];
    dotsView.frame = CGRectMake(0.f, 0.f, kDeviceWidth, kDeviceHeight);
    [self.view addSubview:dotsView];
    
    [dotsView startWithAnimation];
}

@end
