//
//  CMColorsBoxView.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "CMColorsBoxView.h"

@implementation CMColorsBoxView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeBaseData];
        [self initializeUIComponents];
    }
    return self;
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    self.bounds = CGRectMake(0.f, 0.f, 30.f, 30.f);
    self.backgroundColor = kRandomColor;
    
    [self startAnimation];
}

- (void)startAnimation
{
    [UIView animateWithDuration:kGetRandomFloatWithLimit(0.f, 1.f) animations:^{
        
        self.backgroundColor = kRandomColor;
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
        [self retsetAnimation];
    }];
}

- (void)retsetAnimation
{
    [UIView animateWithDuration:kGetRandomFloatWithLimit(0.f, 1.f) animations:^{
        
        self.backgroundColor = kRandomColor;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        [self startAnimation];
    }];
}

@end
