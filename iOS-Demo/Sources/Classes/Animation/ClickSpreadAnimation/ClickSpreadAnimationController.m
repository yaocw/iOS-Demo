//
//  ClickSpreadAnimationController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/27.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ClickSpreadAnimationController.h"

#define mCircleLineWidth 3.0f
#define mRadiusWithInitialize 10.0f

@interface ClickSpreadAnimationController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ClickSpreadAnimationController
{
    NSTimer *_timer;
    
    CGFloat _currentRadius;
    CGFloat _currentAlpha;
    
    CGFloat _invalidateRadius;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData];
    [self initializeUIComponents];
}

- (void)initializeData
{
    _currentRadius = mRadiusWithInitialize;
    _currentAlpha = 1.0f;
}

- (void)initializeUIComponents
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    
    if (anyTouch)
    {
        CGPoint touchedPoint = [anyTouch locationInView:_imageView];
        
        [_timer invalidate];
        _currentRadius = mRadiusWithInitialize;
        _currentAlpha = 1.0f;
        
        if (touchedPoint.x > kDeviceWidth / 2.0f)
        {
            _invalidateRadius = touchedPoint.x;
        }
        else
        {
            _invalidateRadius = kDeviceWidth - touchedPoint.x;
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.005f target:self selector:@selector(drawCircle:) userInfo:@{@"touchedPoint_x" : @(touchedPoint.x), @"touchedPoint_y" : @(touchedPoint.y)} repeats:YES];
    }
}

- (void)drawCircle:(NSTimer *)timer
{
    NSDictionary *touchedPointDic = timer.userInfo;
    CGPoint centerPoint = CGPointMake(((NSNumber *)touchedPointDic[@"touchedPoint_x"]).floatValue, ((NSNumber *)touchedPointDic[@"touchedPoint_y"]).floatValue);
    
    
    _currentRadius += 0.5f;
    _currentAlpha = 1.0f - (_currentRadius  / _invalidateRadius);
    
    if (_currentRadius >= _invalidateRadius)
    {
        [_timer invalidate];
        _timer = nil;
        
        _currentRadius = mRadiusWithInitialize;
        
        return ;
    }
    
    UIGraphicsBeginImageContext(_imageView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *strokeColor = [UIColor colorWithHexColorString:@"0XFF7F00" alpha:_currentAlpha];
    [strokeColor setStroke];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, mCircleLineWidth);
    
    
    CGContextAddArc(context, centerPoint.x, centerPoint.y, _currentRadius, 0, 2 * M_PI, 0);
    
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView.image = image;
}

@end





