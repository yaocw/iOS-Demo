//
//  MTPopTransition.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MTPopTransition.h"
#import "MainMaskTransitionController.h"
#import "OtherMaskTransitionController.h"

@interface MTPopTransition () <CAAnimationDelegate>

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation MTPopTransition 

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.69f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    OtherMaskTransitionController *fromController = (OtherMaskTransitionController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MainMaskTransitionController *toController   = (MainMaskTransitionController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:fromController.view];
    [containerView addSubview:toController.view];
    
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(kDeviceWidth / 2.0f - 10.0f, kDeviceHeight / 2.0f - 10.0f, 20.0f, 20.0f)];
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((kDeviceWidth / 2.0f) - (kDeviceHeight / 2.0f + 100.0f), -100.f, kDeviceHeight + 200.0f, kDeviceHeight + 200.0f)];
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    toController.view.layer.mask = maskLayer;
    
    
    CABasicAnimation *ovalTransiAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    ovalTransiAnimation.fromValue = (__bridge id)(startPath.CGPath);
    ovalTransiAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    ovalTransiAnimation.duration = [self transitionDuration:transitionContext];
    ovalTransiAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    ovalTransiAnimation.delegate = self;
    
    [maskLayer addAnimation:ovalTransiAnimation forKey:@"pingInvert"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}


@end
