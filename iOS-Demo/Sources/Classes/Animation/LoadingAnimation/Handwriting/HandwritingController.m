//
//  HandwritingController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "HandwritingController.h"

@interface HandwritingController ()

@property (strong, nonatomic) CAShapeLayer *loadingShapeLayer;
@property (strong, nonatomic) CAKeyframeAnimation *loadingKeyframeAnimation;

@end

@implementation HandwritingController

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
    UIBezierPath *loadingBezierpath = [self loadingShapeBezierPath];
    _loadingShapeLayer = [CAShapeLayer layer];
    _loadingShapeLayer.frame = CGRectMake(kDeviceWidth / 2.f - 150.f, kDeviceHeight / 2.f - 46.f, 300, 92.f);
    _loadingShapeLayer.path = loadingBezierpath.CGPath;
    _loadingShapeLayer.strokeEnd = 0;
    _loadingShapeLayer.strokeColor = [UIColor blackColor].CGColor;
    _loadingShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _loadingShapeLayer.lineWidth = 2.5f;
    _loadingShapeLayer.lineCap = kCALineCapRound;
    _loadingShapeLayer.lineJoin = kCALineJoinRound;
    [self.view.layer addSublayer:_loadingShapeLayer];
    
    
    _loadingKeyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    _loadingKeyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _loadingKeyframeAnimation.keyTimes = @[@0.0f, @0.6f, @1.0f];
    _loadingKeyframeAnimation.values =  @[@0.0f, @1.0f, @1.0f];
    _loadingKeyframeAnimation.duration = 4.0f;
    _loadingKeyframeAnimation.repeatCount = CGFLOAT_MAX;
    [_loadingShapeLayer addAnimation:_loadingKeyframeAnimation forKey:@"stoke"];
}

- (UIBezierPath *) loadingShapeBezierPath
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(1.5, 50.5)];
    [bezierPath addLineToPoint: CGPointMake(33.5, 50.5)];
    [bezierPath addLineToPoint: CGPointMake(41.5, 30.5)];
    [bezierPath addLineToPoint: CGPointMake(49.5, 65.5)];
    [bezierPath addLineToPoint: CGPointMake(56.5, 38.5)];
    [bezierPath addLineToPoint: CGPointMake(61.5, 57.5)];
    [bezierPath addLineToPoint: CGPointMake(74.5, 14.5)];
    [bezierPath addLineToPoint: CGPointMake(80.5, 76.5)];
    [bezierPath addLineToPoint: CGPointMake(91.5, 38.5)];
    [bezierPath addLineToPoint: CGPointMake(97.5, 57.5)];
    [bezierPath addLineToPoint: CGPointMake(103.5, 38.5)];
    [bezierPath addLineToPoint: CGPointMake(112.5, 65.5)];
    [bezierPath addLineToPoint: CGPointMake(126.5, 22.5)];
    [bezierPath addLineToPoint: CGPointMake(138.5, 83.5)];
    [bezierPath addLineToPoint: CGPointMake(155.5, 8.5)];
    [bezierPath addLineToPoint: CGPointMake(163.5, 38.5)];
    [bezierPath addLineToPoint: CGPointMake(177.5, 22.5)];
    [bezierPath addLineToPoint: CGPointMake(187.5, 50.5)];
    [bezierPath addLineToPoint: CGPointMake(199.5, 71.5)];
    [bezierPath addLineToPoint: CGPointMake(207.5, 57.5)];
    [bezierPath addLineToPoint: CGPointMake(212.5, 38.5)];
    [bezierPath addLineToPoint: CGPointMake(219.5, 57.5)];
    [bezierPath addLineToPoint: CGPointMake(232.5, 30.5)];
    [bezierPath addLineToPoint: CGPointMake(240.5, 71.5)];
    [bezierPath addLineToPoint: CGPointMake(245.5, 50.5)];
    [bezierPath addLineToPoint: CGPointMake(255.5, 30.5)];
    [bezierPath addLineToPoint: CGPointMake(260.5, 57.5)];
    [bezierPath addLineToPoint: CGPointMake(297.5, 57.5)];
    
    return bezierPath;
}


@end
