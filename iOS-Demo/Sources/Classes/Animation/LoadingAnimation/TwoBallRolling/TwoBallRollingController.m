//
//  TwoBallRollingController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/14.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "TwoBallRollingController.h"

@interface TwoBallRollingController ()

@property (nonatomic,strong) CAShapeLayer *firstLayer;
@property (nonatomic,strong) CAShapeLayer *secondLayer;

@end

@implementation TwoBallRollingController
{
    CGPoint _centerPoint;
    CGFloat _moveDistance;
    CGFloat _animationDuration;
    CGFloat _radius;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    _centerPoint = CGPointMake(kDeviceWidth * 0.5f, kDeviceHeight * 0.5f);
    _moveDistance = 60.f;
    _animationDuration = 2.f;
    _radius = 20.f;
}

- (void)initializeUIComponents
{
    [self setupTwoBallLayers];
    [self setupTheFirstBallAnimation];
    [self setupTheSecondBallAnimation];
}

- (void)setupTwoBallLayers
{
    _firstLayer = [CAShapeLayer layer];
    _firstLayer.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    _firstLayer.fillColor = kRandomColor.CGColor;
    _firstLayer.path = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:_radius startAngle:0.f endAngle:M_PI * 2.f clockwise:YES].CGPath;
    [self.view.layer addSublayer:_firstLayer];
    
    
    _secondLayer = [CAShapeLayer layer];
    _secondLayer.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    _secondLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    _secondLayer.fillColor = kRandomColor.CGColor;
    _secondLayer.path = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:_radius startAngle:0.f endAngle:M_PI * 2.f clockwise:YES].CGPath;
    [self.view.layer addSublayer:_secondLayer];
}

- (void)setupTheFirstBallAnimation
{
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.z"];
    transformAnimation.values = @[@1.f, @0.f, @0.f, @0.f, @1.f];
    
    CAKeyframeAnimation *firstFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _centerPoint.x, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x+_moveDistance, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x-_moveDistance, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x, _centerPoint.y);
    [firstFrameAnimation setPath:path];
    
    CAKeyframeAnimation *firstScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    firstScaleAnimation.values = @[@1.f, @0.5f, @0.25f, @0.5f, @1.f];
    
    
    CAKeyframeAnimation *firstOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    firstOpacityAnimation.values = @[@1.f, @0.5f, @0.25f, @0.5f, @1.f];
    
    CAAnimationGroup *firstGroup = [CAAnimationGroup animation];
    [firstGroup setAnimations:@[transformAnimation, firstFrameAnimation, firstScaleAnimation, firstOpacityAnimation]];
    firstGroup.duration = _animationDuration;
    firstGroup.repeatCount = HUGE;
    [_firstLayer addAnimation:firstGroup forKey:@"firstGroup"];
}

- (void)setupTheSecondBallAnimation
{
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.z"];
    transformAnimation.values = @[@0.f, @0.f, @1.f, @0.f, @0.f];
    
    CAKeyframeAnimation *secondFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _centerPoint.x, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x-_moveDistance, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x+_moveDistance, _centerPoint.y);
    CGPathAddLineToPoint(path, NULL, _centerPoint.x, _centerPoint.y);
    [secondFrameAnimation setPath:path];
    
    CAKeyframeAnimation *secondScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    secondScaleAnimation.values = @[@0.25f, @0.5f, @1.f, @0.5f, @0.25f];
    
    CAKeyframeAnimation *secondOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    secondOpacityAnimation.values = @[@0.25f, @0.5f, @1.f, @0.5f, @0.25f];
    
    CAAnimationGroup *secondGroup = [CAAnimationGroup animation];
    [secondGroup setAnimations:@[transformAnimation, secondFrameAnimation, secondScaleAnimation, secondOpacityAnimation]];
    secondGroup.duration = _animationDuration;
    secondGroup.repeatCount = HUGE;
    [_secondLayer addAnimation:secondGroup forKey:@"secondGroup"];
}

@end
