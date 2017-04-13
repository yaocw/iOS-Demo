//
//  ThreeDotsController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "ThreeDotsController.h"

@interface ThreeDotsController ()

@property (weak, nonatomic) UIView *container;
@property (strong, nonatomic) CALayer *containerDotLayer;
@property (strong, nonatomic) NSMutableArray *arrThreeDots;
@property (strong, nonatomic) CABasicAnimation *rotateAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *glowAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *colorGlowAnimation;
@property (strong, nonatomic) CAKeyframeAnimation *colorDotAnimation;
@property (strong, nonatomic) CAAnimationGroup *groupAnimation;

@end

@implementation ThreeDotsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    _arrThreeDots = [[NSMutableArray alloc] initWithCapacity:3];
}

- (void)initializeUIComponents
{
    _containerDotLayer = [CALayer layer];
    _containerDotLayer.frame = CGRectMake(0, 0, 50, 50);
    _containerDotLayer.backgroundColor = [UIColor clearColor].CGColor;
    _containerDotLayer.position = self.view.center;
    
    for (NSInteger i = 0; i < 3; i++)
    {
        CALayer *dot = [CALayer layer];
        CGRect frame;
        
        switch (i) {
            case 0:
            {
                frame = CGRectMake(15, 0, 20, 20);
                break;
            }
            case 1:
            {
                frame = CGRectMake(0, 29.5, 20, 20);
                break;
            }
            case 2:
            {
                frame = CGRectMake(30.5, 29.5, 20, 20);
                break;
            }
            default:
                break;
        }
        dot.frame = frame;
        dot.backgroundColor = [UIColor colorWithRed:230.0f/255.0f
                                              green:126.0f/255.0f
                                               blue:34.0f/255.0f
                                              alpha:1.0f].CGColor;
        dot.cornerRadius = 10;;
        dot.shadowColor = [UIColor colorWithRed:230.0f/255.0f
                                          green:126.0f/255.0f
                                           blue:34.0f/255.0f
                                          alpha:1.0f].CGColor;
        dot.shadowOpacity = 1;
        dot.shadowOffset = CGSizeMake(0, 0);
        dot.shadowRadius = 15;
        
        [_containerDotLayer addSublayer:dot];
        [_arrThreeDots addObject:dot];
        
    }
    
    [self.view.layer addSublayer:_containerDotLayer];
    
    
    
    
    
    
    
    _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    _rotateAnimation.repeatCount = HUGE_VAL;
    _rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    _rotateAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    _rotateAnimation.duration = 1.5f;
    
    _glowAnimation = [CAKeyframeAnimation animationWithKeyPath:@"shadowRadius"];
    _glowAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.5f],
                                [NSNumber numberWithFloat:1.0f]];
    _glowAnimation.values = @[[NSNumber numberWithFloat:5.0f],
                              [NSNumber numberWithFloat:20.0f],
                              [NSNumber numberWithFloat:5.0f]];
    _glowAnimation.repeatCount = HUGE_VAL;
    _glowAnimation.duration = 1.5f;
    
    _colorGlowAnimation = [CAKeyframeAnimation animationWithKeyPath:@"shadowColor"];
    _colorGlowAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f],
                                     [NSNumber numberWithFloat:0.5f],
                                     [NSNumber numberWithFloat:1.0f]];
    _colorGlowAnimation.values = @[(id)kHexColor(@"#ff0000").CGColor,
                                   (id)kHexColor(@"#00ff00").CGColor,
                                   (id)kHexColor(@"#ff0000").CGColor];
    _colorGlowAnimation.repeatCount = HUGE_VAL;
    _colorGlowAnimation.duration = 1.5f;
    
    _colorDotAnimation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
    _colorDotAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:0.5f],
                                    [NSNumber numberWithFloat:1.0f]];
    _colorDotAnimation.values = @[(id)kHexColor(@"#ff0000").CGColor,
                                  (id)kHexColor(@"#00ff00").CGColor,
                                  (id)kHexColor(@"#ff0000").CGColor];
    _colorDotAnimation.repeatCount = HUGE_VAL;
    _colorDotAnimation.duration = 1.5f;
    
    _groupAnimation = [CAAnimationGroup animation];
    _groupAnimation.duration = 1.5f;
    _groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    _groupAnimation.repeatCount = HUGE_VAL;
    _groupAnimation.animations = @[_glowAnimation, _colorDotAnimation, _colorGlowAnimation];

    
    
    
    
    
    [_containerDotLayer addAnimation:_rotateAnimation forKey:@"transform.rotation"];
    
    for (CALayer *dot in _arrThreeDots) {
        [dot addAnimation:_groupAnimation forKey:@"shadowRadius"];
    }
}

@end
