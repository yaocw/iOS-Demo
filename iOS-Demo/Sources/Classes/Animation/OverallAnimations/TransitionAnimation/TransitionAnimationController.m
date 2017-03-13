//
//  TransitionAnimationController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/8.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "TransitionAnimationController.h"

#define kAnimationViewSize CGSizeMake(159, 256)

@interface TransitionAnimationController ()

@property (nonatomic , strong) UIView *animationView;
@property (nonatomic , strong) UILabel *animationViewLabel;

@end

@implementation TransitionAnimationController
{
    NSInteger _index;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializationData];
    [self initializationUIComponents];
}

- (void)initializationData
{
    _index = 0;
    
}

- (void)initializationUIComponents
{
    _animationView = [[UIView alloc] initWithFrame:CGRectMake((kDeviceWidth / 2.0f) - (kAnimationViewSize.width / 2.0f), (kDeviceHeight / 2.0f - 64) - (kAnimationViewSize.height / 2.0f), kAnimationViewSize.width, kAnimationViewSize.height)];
    _animationView.backgroundColor = kHexColor(@"78A501");
    [self.view addSubview:_animationView];
    
    
    _animationViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_animationView.frame)/2-10, CGRectGetHeight(_animationView.frame)/2-20, 30, 40)];
    _animationViewLabel.textAlignment = NSTextAlignmentCenter;
    _animationViewLabel.font = kAppFontWithSize(40);
    [_animationView addSubview:_animationViewLabel];
    
    [self changeView:YES];
}

- (IBAction)startAnimationAction:(id)sender
{
    UIButton *button = sender;
    
    switch (button.tag)
    {
        case 1:
        {
            [self fadeAnimation];
            break;
        }
            
        case 2:
        {
            [self moveInAnimation];
            break;
        }
            
        case 3:
        {
            [self pushAnimation];
            break;
        }
            
        case 4:
        {
            [self revealAnimation];
            break;
        }
            
        case 5:
        {
            [self cubeAnimation];
            break;
        }
            
        case 6:
        {
            [self suckEffectAnimation];
            break;
        }
            
        case 7:
        {
            [self oglFlipAnimation];
            break;
        }
            
        case 8:
        {
            [self rippleEffectAnimation];
            break;
        }
            
        case 9:
        {
            [self pageCurlAnimation];
            break;
        }
            
        case 10:
        {
            [self pageUnCurlAnimation];
            break;
        }
            
        case 11:
        {
            [self cameraIrisHollowOpenAnimation];
            break;
        }
            
        case 12:
        {
            [self cameraIrisHollowCloseAnimation];
            break;
        }
        default:
            break;
    }
}

- (void)fadeAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionFade;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    //anima.startProgress = 0.3;//设置动画起点
    //anima.endProgress = 0.8;//设置动画终点
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"fadeAnimation"];
}

- (void)moveInAnimation
{
    
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionMoveIn;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"moveInAnimation"];
}

- (void)pushAnimation
{
    
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionPush;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"pushAnimation"];
}

- (void)revealAnimation
{
    
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = kCATransitionReveal;//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"revealAnimation"];
}

/**
 *  立体翻滚效果
 */
- (void)cubeAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"cube";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"revealAnimation"];
}


- (void)suckEffectAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"suckEffect";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"suckEffectAnimation"];
}

- (void)oglFlipAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"oglFlip";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"oglFlipAnimation"];
}

- (void)rippleEffectAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"rippleEffect";//设置动画的类型
    anima.subtype = @"fromLeft"; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.view.layer addAnimation:anima forKey:@"rippleEffectAnimation"];
}

- (void)pageCurlAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"pageCurl";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"pageCurlAnimation"];
}

- (void)pageUnCurlAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"pageUnCurl";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [_animationView.layer addAnimation:anima forKey:@"pageUnCurlAnimation"];
}

- (void)cameraIrisHollowOpenAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"cameraIrisHollowOpen";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.view.layer addAnimation:anima forKey:@"cameraIrisHollowOpenAnimation"];
}

- (void)cameraIrisHollowCloseAnimation
{
    [self changeView:YES];
    CATransition *anima = [CATransition animation];
    anima.type = @"cameraIrisHollowClose";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    
    [self.view.layer addAnimation:anima forKey:@"cameraIrisHollowCloseAnimation"];
}

- (void)changeView : (BOOL)isUp
{
    if (_index>3)
    {
        _index = 0;
    }
    
    if (_index<0)
    {
        _index = 3;
    }
    
    NSArray *colors = [NSArray arrayWithObjects:[UIColor cyanColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor], nil];
    NSArray *titles = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    _animationView.backgroundColor = [colors objectAtIndex:_index];
    _animationViewLabel.text = [titles objectAtIndex:_index];
    
    if (isUp)
    {
        _index++;
    }
    else
    {
        _index--;
    }
}

@end
