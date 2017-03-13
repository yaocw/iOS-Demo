//
//  RevolveCircleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/5.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "RevolveCircleController.h"

@interface RevolveCircleController ()

@end

@implementation RevolveCircleController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self initializeUIComponents];
}

- (void)initializeUIComponents
{
    CGMutablePathRef ms = CGPathCreateMutable();
    CGPathAddEllipseInRect(ms, nil, CGRectInset(CGRectMake(0, 50, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width), 50,50));
    
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    tView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width - 50, 250);
    tView.layer.cornerRadius = 5;
    tView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    CAKeyframeAnimation *loveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    loveAnimation.path = ms;
    loveAnimation.duration = 8;
    loveAnimation.repeatCount = MAXFLOAT;
    [tView.layer addAnimation:loveAnimation forKey:@"loveAnimation"];
    
    CAReplicatorLayer *loveLayer = [CAReplicatorLayer layer];
    loveLayer.instanceCount = 40;                // 40个layer
    loveLayer.instanceDelay = 0.2;               // 每隔0.2出现一个layer
    loveLayer.instanceColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    loveLayer.instanceGreenOffset = -0.03;       // 颜色值递减。
    loveLayer.instanceRedOffset = -0.02;         // 颜色值递减。
    loveLayer.instanceBlueOffset = -0.01;        // 颜色值递减。
    [loveLayer addSublayer:tView.layer];
    [self.view.layer addSublayer:loveLayer];
}

@end
