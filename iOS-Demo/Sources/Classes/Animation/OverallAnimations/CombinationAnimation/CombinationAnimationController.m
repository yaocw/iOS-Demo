//
//  CombinationAnimationController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/8.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "CombinationAnimationController.h"

#define kAnimationViewSize CGSizeMake(136, 136)

@interface CombinationAnimationController ()

@property (nonatomic , strong) UIView *animationView;

@end

@implementation CombinationAnimationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializationUIComponents];
}

- (void)initializationUIComponents
{
    _animationView = [[UIView alloc] initWithFrame:CGRectMake((kDeviceWidth / 2.0f) - (kAnimationViewSize.width / 2.0f), (kDeviceHeight / 2.0f - 64) - (kAnimationViewSize.height / 2.0f), kAnimationViewSize.width, kAnimationViewSize.height)];
    _animationView.backgroundColor = kHexColor(@"78A501");
    _animationView.layer.cornerRadius = 5.0f;
    _animationView.layer.masksToBounds = YES;
    
    [self.view addSubview:_animationView];
}

- (IBAction)startAnimationAction:(id)sender
{
    UIButton *button = sender;
    
    switch (button.tag)
    {
        case 1:
        {
            [self groupAnimation1];
            break;
        }
            
        case 2:
        {
            [self groupAnimation2];
            break;
        }
        default:
            break;
    }
}

/**
 *  同时执行的组合动画
 */
- (void)groupAnimation1
{
    //位移动画
    CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, kDeviceHeight/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth/3, kDeviceHeight/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth/3, kDeviceHeight/2+50)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth*2/3, kDeviceHeight/2+50)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth*2/3, kDeviceHeight/2-50)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth, kDeviceHeight/2-50)];
    anima1.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];
    
    //缩放动画
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0.8f];
    anima2.toValue = [NSNumber numberWithFloat:2.0f];
    
    //旋转动画
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
    
    //组合动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
    groupAnimation.duration = 4.0f;
    
    [_animationView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
    
    //-------------如下，使用三个animation不分装成group，只是把他们添加到layer，也有组合动画的效果。-------------
    //    //位移动画
    //    CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, kDeviceHeight/2-50)];
    //    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth/3, kDeviceHeight/2-50)];
    //    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth/3, kDeviceHeight/2+50)];
    //    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth*2/3, kDeviceHeight/2+50)];
    //    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth*2/3, kDeviceHeight/2-50)];
    //    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth, kDeviceHeight/2-50)];
    //    anima1.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];
    //    anima1.duration = 4.0f;
    //    [_animationView.layer addAnimation:anima1 forKey:@"aa"];
    //
    //    //缩放动画
    //    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    anima2.fromValue = [NSNumber numberWithFloat:0.8f];
    //    anima2.toValue = [NSNumber numberWithFloat:2.0f];
    //    anima2.duration = 4.0f;
    //    [_animationView.layer addAnimation:anima2 forKey:@"bb"];
    //
    //    //旋转动画
    //    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
    //    anima3.duration = 4.0f;
    //    [_animationView.layer addAnimation:anima3 forKey:@"cc"];
}

/**
 *  顺序执行的组合动画
 */
- (void)groupAnimation2
{
    CFTimeInterval currentTime = CACurrentMediaTime();
    
    //位移动画
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
    anima1.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, kDeviceHeight/2-75)];
    anima1.toValue = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth/2, kDeviceHeight/2-75)];
    anima1.beginTime = currentTime;
    anima1.duration = 1.0f;
    anima1.fillMode = kCAFillModeForwards;
    anima1.removedOnCompletion = NO;
    [_animationView.layer addAnimation:anima1 forKey:@"aa"];
    
    //缩放动画
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0.8f];
    anima2.toValue = [NSNumber numberWithFloat:2.0f];
    anima2.beginTime = currentTime+1.0f;
    anima2.duration = 1.0f;
    anima2.fillMode = kCAFillModeForwards;
    anima2.removedOnCompletion = NO;
    [_animationView.layer addAnimation:anima2 forKey:@"bb"];
    
    //旋转动画
    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
    anima3.beginTime = currentTime+2.0f;
    anima3.duration = 1.0f;
    anima3.fillMode = kCAFillModeForwards;
    anima3.removedOnCompletion = NO;
    [_animationView.layer addAnimation:anima3 forKey:@"cc"];
}

@end
