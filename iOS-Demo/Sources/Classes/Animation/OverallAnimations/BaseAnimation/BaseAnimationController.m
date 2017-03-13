//
//  BaseAnimationController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/8.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "BaseAnimationController.h"

#define kAnimationViewSize CGSizeMake(136, 136)

@interface BaseAnimationController ()

@property (nonatomic , strong) UIView *animationView;

@end

@implementation BaseAnimationController

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
            [self positionAnimation];
            break;
        }
            
        case 2:
        {
            [self scaleAnimation];
            break;
        }
            
        case 3:
        {
            [self rotateAnimation];
            break;
        }
            
        case 4:
        {
            [self opacityAniamtion];
            break;
        }
            
        case 5:
        {
            [self colorAnimation];
            break;
        }
            
        default:
            break;
    }
}


-(void)positionAnimation
{
    //使用CABasicAnimation创建基础动画
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, kDeviceHeight / 2.0f - 75)];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(kDeviceWidth, kDeviceHeight / 2.0f - 75)];
    anima.duration = 1.0f;
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    //anima.fillMode = kCAFillModeForwards;
    //anima.removedOnCompletion = NO;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_animationView.layer addAnimation:anima forKey:@"positionAnimation"];
    
    
    //使用UIView Animation 代码块调用
    //    _animationView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
    //    [UIView animateWithDuration:1.0f animations:^{
    //        _animationView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
    //    } completion:^(BOOL finished) {
    //        _animationView.frame = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-50, 50, 50);
    //    }];
    //
    //使用UIView [begin,commit]模式
    //    _animationView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:1.0f];
    //    _animationView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
    //    [UIView commitAnimations];
}


-(void)opacityAniamtion{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:1.0f];
    anima.toValue = [NSNumber numberWithFloat:0.2f];
    anima.duration = 1.0f;
    [_animationView.layer addAnimation:anima forKey:@"opacityAniamtion"];
}


-(void)scaleAnimation{
    //    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"bounds"];
    //    anima.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    //    anima.duration = 1.0f;
    //    [_animationView.layer addAnimation:anima forKey:@"scaleAnimation"];
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//同上
    anima.toValue = [NSNumber numberWithFloat:2.0f];
    anima.duration = 1.0f;
    [_animationView.layer addAnimation:anima forKey:@"scaleAnimation"];
    
    //    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    //    anima.toValue = [NSNumber numberWithFloat:0.2f];
    //    anima.duration = 1.0f;
    //    [_animationView.layer addAnimation:anima forKey:@"scaleAnimation"];
}


-(void)rotateAnimation
{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:M_PI];
    anima.duration = 1.0f;
    [_animationView.layer addAnimation:anima forKey:@"rotateAnimation"];
    
    //    //valueWithCATransform3D作用与layer
    //    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform"];
    //    anima.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];//绕着矢量（x,y,z）旋转
    //    anima.duration = 1.0f;
    //    //anima.repeatCount = MAXFLOAT;
    //    [_animationView.layer addAnimation:anima forKey:@"rotateAnimation"];
    
    //    //CGAffineTransform作用与View
    //    _animationView.transform = CGAffineTransformMakeRotation(0);
    //    [UIView animateWithDuration:1.0f animations:^{
    //        _animationView.transform = CGAffineTransformMakeRotation(M_PI);
    //    } completion:^(BOOL finished) {
    //
    //    }];
}


-(void)colorAnimation
{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    anima.toValue =(id) [UIColor orangeColor].CGColor;
    anima.duration = 1.0f;
    [_animationView.layer addAnimation:anima forKey:@"backgroundAnimation"];
}



@end
