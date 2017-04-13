//
//  TDDotsView.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "TDDotsView.h"

#import "TDDotView.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

static CGFloat kDistanceFromCenterDotToOthers = 50.f;

@implementation TDDotsView
{
    UIView *_centerDot;
    NSMutableArray *_dots;
    
    CGSize _dotSize;
    CGFloat _animationDuration;
    NSUInteger _numberOfDots;
}

- (instancetype)initWithFrame:(CGRect)frame dotSize:(CGSize)dotSize animationDuration:(CGFloat)animationDuration numberOfDots:(NSUInteger)numberOfDots
{
    if (self = [super initWithFrame:frame]) {
        
        _dotSize = dotSize;
        _animationDuration = animationDuration;
        _numberOfDots = numberOfDots;
        
        [self initializeBaseData];
        [self initializeUIComponents];
    }
    
    return self;
}

- (void)initializeBaseData
{
    _dots = [NSMutableArray new];
}

- (void)initializeUIComponents
{
    _centerDot = [UIView new];
    _centerDot.bounds = CGRectMake(0, 0, _dotSize.width, _dotSize.height);
    _centerDot.center = self.center;
    _centerDot.layer.cornerRadius = _dotSize.width / 2.0f;
    _centerDot.layer.masksToBounds = YES;
    _centerDot.backgroundColor = kRandomColor;
    [self addSubview:_centerDot];
}


- (void)startWithAnimation
{
    TDDotView *dotView = nil;
    for (int i = 0; i < _numberOfDots; i++)
    {
        dotView = [TDDotView new];
        dotView.tag = i + 1;
        dotView.size = _dotSize;
        dotView.originPoint = _centerDot.center;
        dotView.destinationPoint = [self pointFromAngle:i * (360.f / _numberOfDots)];
        dotView.backgroundColor = kRandomColor;
        [self addSubview:dotView];
        [_dots addObject:dotView];
        
        [dotView startWithAnimationWithDelay:i * _animationDuration complete:^(NSInteger index) {
            
            if (dotView.tag == _numberOfDots)
            {
                [self resetWithAnimation];
            }
        }];
    }
}

- (void)resetWithAnimation
{
    TDDotView *dotView = nil;
    for (int i = 0; i < _numberOfDots; i++)
    {
        dotView = _dots[i];
        [dotView resetWithAnimationWithDelay:i * _animationDuration complete:^(NSInteger index) {
            
            if (dotView.tag == _numberOfDots)
            {
                [self repeatWithAnimation];
            }
        }];
    }
}

- (void)repeatWithAnimation
{
    TDDotView *dotView = nil;
    for (int i = 0; i < _numberOfDots; i++)
    {
        dotView = _dots[i];
        [dotView startWithAnimationWithDelay:i * _animationDuration complete:^(NSInteger index) {
            
            if (dotView.tag == _numberOfDots)
            {
                [self resetWithAnimation];
            }
        }];
    }
}

/**
 * 根据角度得到圆圈轨迹上的坐标
 */
- (CGPoint)pointFromAngle:(int)angleInt
{
    CGPoint result;
    result.y = round(_centerDot.center.y + kDistanceFromCenterDotToOthers * sin(ToRad(angleInt))) ;
    result.x = round(_centerDot.center.x + kDistanceFromCenterDotToOthers * cos(ToRad(angleInt)));
    
    return result;
}






- (CGSize)dotSize
{
    return _dotSize;
}

- (CGFloat)animationDuration
{
    return _animationDuration;
    
}

- (NSUInteger)numberOfDots
{
    return _numberOfDots;
}


@end
