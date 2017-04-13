//
//  TDDotView.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "TDDotView.h"

@implementation TDDotView

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
    _animationDuration = 0.66f;
}

- (void)initializeUIComponents
{
    self.bounds = CGRectMake(0.f, 0.f, 0.f, 0.f);
    self.alpha = 0.f;
}

- (void)startWithAnimationWithDelay:(CGFloat)delay complete:(BLKIndexBlock)complete
{
    self.bounds = CGRectMake(0.f, 0.f, 0.f, 0.f);
    self.center = _originPoint;
    
    [UIView animateWithDuration:_animationDuration delay:delay usingSpringWithDamping:0.5f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bounds = CGRectMake(0.f, 0.f, _size.width, _size.height);
        self.layer.cornerRadius = _size.width / 2.0f;
        self.layer.masksToBounds = YES;
        self.center = _destinationPoint;
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
        complete ? complete(self.tag) : nil;
    }];
    
}

- (void)resetWithAnimationWithDelay:(CGFloat)delay complete:(BLKIndexBlock)complete
{
    self.bounds = CGRectMake(0.f, 0.f, _size.width, _size.height);
    self.center = _destinationPoint;
    
    [UIView animateWithDuration:_animationDuration delay:delay usingSpringWithDamping:0.3f initialSpringVelocity:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.bounds = CGRectMake(0.f, 0.f, 0.f, 0.f);
        self.layer.cornerRadius = _size.width / 2.0f;
        self.layer.masksToBounds = YES;
        self.center = _originPoint;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        
        complete ? complete(self.tag) : nil;
    }];
    
}

@end
