//
//  WaveLoadingController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/14.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "WaveLoadingController.h"

#import "WaveLoadingView.h"

@interface WaveLoadingController ()

@end

@implementation WaveLoadingController
{
    WaveLoadingView *_loadingView;
}

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
    _loadingView = [WaveLoadingView loadingView];
    _loadingView.center = CGPointMake(kDeviceWidth * 0.5f, kDeviceHeight * 0.5f);
    [self.view addSubview:_loadingView];
    
    [_loadingView startLoading];
}

@end
