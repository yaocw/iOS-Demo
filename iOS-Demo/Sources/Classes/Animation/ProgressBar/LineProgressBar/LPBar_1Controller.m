//
//  LPBar_1Controller.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/13.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LPBar_1Controller.h"


@interface LPBar_1Controller ()

@end

@implementation LPBar_1Controller
{
    UIView *_progressBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
    [self startAnimation];
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    _progressBar = [UIView new];
    _progressBar.backgroundColor = kRandomColor;
    _progressBar.frame = CGRectMake(0, 64.0f, 0, 2.0f);
    
    [self.view addSubview:_progressBar];
}

- (void)startAnimation
{
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBar.frame;
        frame.size.width = kDeviceWidth;
        _progressBar.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.66 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBar.alpha = 0;
        } completion:^(BOOL finished) {
            [_progressBar removeFromSuperview];
        }];
    }];
}


@end
