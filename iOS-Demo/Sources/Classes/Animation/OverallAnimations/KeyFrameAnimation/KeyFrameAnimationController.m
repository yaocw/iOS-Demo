//
//  KeyFrameAnimationController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/8.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "KeyFrameAnimationController.h"

#define kAnimationViewSize CGSizeMake(136, 136)

@interface KeyFrameAnimationController () <CAAnimationDelegate>

@property (nonatomic , strong) UIView *animationView;

@end

@implementation KeyFrameAnimationController

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
            [self keyFrameAnimation];
            break;
        }
            
        case 2:
        {
            [self pathAnimation];
            break;
        }
            
        case 3:
        {
            [self shakeAnimation];
            break;
        }
            
        default:
            break;
    }
}

-(void)keyFrameAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, kDeviceHeight/2-50)];
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth/3, kDeviceHeight/2-50)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth/3, kDeviceHeight/2+50)];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth*2/3, kDeviceHeight/2+50)];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth*2/3, kDeviceHeight/2-50)];
    NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth, kDeviceHeight/2-50)];
    animation.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];
    
    animation.duration = 2.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//设置动画的节奏
    animation.delegate = self;//设置代理，可以检测动画的开始和结束
    
    [_animationView.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}

-(void)animationDidStart:(CAAnimation *)animation
{
//    NSLog(@"开始动画");
}

-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
//    NSLog(@"结束动画");
}


-(void)pathAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(kDeviceWidth/2-100, kDeviceHeight/2-100, 200, 200)];
    animation.path = path.CGPath;
    animation.duration = 2.0f;
    
    [_animationView.layer addAnimation:animation forKey:@"pathAnimation"];
}


-(void)shakeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*4];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*4];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*4];
    animation.values = @[value1,value2,value3];
    animation.repeatCount = 10;
    
    [_animationView.layer addAnimation:animation forKey:@"shakeAnimation"];
}


@end
