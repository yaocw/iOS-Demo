//
//  LPBar_2Controller.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/13.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LPBar_2Controller.h"


@interface LPBar_2Controller ()

@end

@implementation LPBar_2Controller
{
    UIView *_progressBar;
    CAGradientLayer *_gradientLayerForBar;
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
    _progressBar = [UIView new];
    _progressBar.backgroundColor = kRandomColor;
    _progressBar.frame = CGRectMake(-kDeviceWidth, kDeviceHeight / 2.0, kDeviceWidth, 6.6f);
    
    _gradientLayerForBar = [CAGradientLayer layer];
    _gradientLayerForBar.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)_progressBar.backgroundColor.CGColor];
    _gradientLayerForBar.locations = @[@0.0, @1.0];
    _gradientLayerForBar.startPoint = CGPointMake(0, 0);
    _gradientLayerForBar.endPoint = CGPointMake(1.0, 0);
    _gradientLayerForBar.frame = CGRectMake(0, 0, kDeviceWidth, 6.6f);
    [_progressBar.layer addSublayer:_gradientLayerForBar];
    
    [self.view addSubview:_progressBar];
    
    [self startAnimation];
}

- (void)startAnimation
{
    [UIView animateWithDuration:1.66f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect frame = _progressBar.frame;
        frame.origin.x = kDeviceWidth;
        _progressBar.frame = frame;
        
    } completion:^(BOOL finished) {
        
        _progressBar.backgroundColor = kRandomColor;
        _progressBar.frame = CGRectMake(-kDeviceWidth, kDeviceHeight / 2.0, kDeviceWidth, 6.6f);
        _gradientLayerForBar.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)_progressBar.backgroundColor.CGColor];
        
        [self startAnimation];
        
    }];
}


@end
