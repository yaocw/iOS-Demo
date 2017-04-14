//
//  RaderSpreadController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "RaderSpreadController.h"

static const float timeinterval = 0.5f;

@interface RaderSpreadController () <CAAnimationDelegate>

@end

@implementation RaderSpreadController
{
    NSTimer *_timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeinterval target:self selector:@selector(setUp) userInfo:nil repeats:YES];
}

-(void)setUp
{
    CGPoint center = CGPointMake(kDeviceWidth / 2.f, kDeviceHeight / 2.f);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:10 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0.f, 0.f, kDeviceWidth, kDeviceHeight);
    shapeLayer.fillColor = kRandomColor.CGColor;
    shapeLayer.opacity = 0.2f;
    shapeLayer.path = path.CGPath;
    
    [self.view.layer addSublayer:shapeLayer];
    [self addAnimation:shapeLayer];
}

-(void)addAnimation:(CAShapeLayer *)shapeLayer
{
    //雷达圈圈大小的动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"path";
    CGPoint center = CGPointMake(kDeviceWidth / 2.f, kDeviceHeight / 2.f);
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center radius:10 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:[UIScreen mainScreen].bounds.size.height startAngle:0 endAngle:2 * M_PI clockwise:YES];
    basicAnimation.fromValue = (__bridge id _Nullable)(path1.CGPath);
    basicAnimation.toValue = (__bridge id _Nullable)(path2.CGPath);
    basicAnimation.fillMode = kCAFillModeForwards;
    
    
    //雷达圈圈的透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
    opacityAnimation.keyPath = @"opacity";
    
    opacityAnimation.fromValue = @(0.2);
    opacityAnimation.toValue = @(0);
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[basicAnimation,opacityAnimation];
    group.duration = 7;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    //指定的时间段完成后,动画就自动从层上移除
    group.removedOnCompletion = YES;
    //添加动画到layer
    [shapeLayer addAnimation:group forKey:nil];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        if ([self.view.layer.sublayers[0] isKindOfClass:[CAShapeLayer class]]) {
            CAShapeLayer *shaperLayer = (CAShapeLayer *)self.view.layer.sublayers[0];
            [shaperLayer removeFromSuperlayer];
            shaperLayer = nil;
        }
    }
}

@end
