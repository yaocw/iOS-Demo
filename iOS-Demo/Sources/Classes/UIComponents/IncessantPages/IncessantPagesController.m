//
//  IncessantPagesController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/14.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "IncessantPagesController.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.f )
#define ToDeg(rad)		( (180.f * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

static const CGFloat kPageViewWidth = 200.f;
static const CGFloat kPageViewHeight = 336.f;
static const CGFloat kAvailableDistance = 100.f;

static const int kNumberOfPages = 6;

@interface IncessantPagesController ()

@end

@implementation IncessantPagesController
{
    NSMutableArray *_pageViews;
    UIView *_selectedPageView;
    BOOL _isAnimating;
    
    CGPoint _center;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    _center = CGPointMake(kDeviceWidth * 0.5f, kDeviceHeight * 0.5f);
    _pageViews = [NSMutableArray new];
}

- (void)initializeUIComponents
{
    [self setupPageViews];
}

- (void)setupPageViews
{
    UIView *theView = nil;
    for (int i = 0; i < kNumberOfPages; i ++)
    {
        theView = [UIView new];
        theView.bounds = CGRectMake(0.f, 0.f, kPageViewWidth, kPageViewHeight);
        theView.backgroundColor = kRandomColor;
        theView.layer.cornerRadius = 10.f;
        theView.layer.masksToBounds = YES;
        theView.center = CGPointMake(kDeviceWidth * 0.5f, kDeviceHeight * 0.5f);
        
        [self.view addSubview:theView];
        [_pageViews addObject:theView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isAnimating && _pageViews.count > 0 && !_selectedPageView)
    {
        UITouch *anyTouch = [touches anyObject];
        CGPoint touchPoint = [anyTouch locationInView:self.view];
        
        UIView *theFrontPageView = _pageViews.lastObject;
        CGPoint touchPointInPageView = [theFrontPageView.layer convertPoint:touchPoint fromLayer:self.view.layer];
        
        if ([theFrontPageView.layer containsPoint:touchPointInPageView])
        {
            _selectedPageView = theFrontPageView;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isAnimating && _pageViews.count > 0)
    {
        UITouch *anyTouch = [touches anyObject];
        CGPoint touchPoint = [anyTouch locationInView:self.view];
        
        _selectedPageView.center = touchPoint;
        
        if (_pageViews.count >= 3)
        {
            CGFloat distanceOfTouchPointToCenter = [self distanceOfTwoPoint:touchPoint secondPoint:_center];
            CGFloat angle = AngleFromNorth(_center, touchPoint, NO);
            CGFloat avgDistance = distanceOfTouchPointToCenter / (_pageViews.count - 1);
            CGPoint tempPoint = CGPointZero;
            
            int index = 0;
            for (UIView *theView in _pageViews)
            {
                if (theView != _selectedPageView && theView != _pageViews.firstObject)
                {
                    tempPoint = [self pointFromAngle:angle withDistance:avgDistance * index];
                    theView.center = tempPoint;
                }
                
                index++;
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isAnimating && _selectedPageView && _pageViews.count > 0)
    {
        CGPoint firstPoint = self.view.center;
        CGPoint secondPoint = _selectedPageView.center;
        
        CGFloat distanceOfTwoPoint = [self distanceOfTwoPoint:firstPoint secondPoint:secondPoint];
        if (distanceOfTwoPoint > kAvailableDistance)
        {
            _isAnimating = YES;
            [_pageViews removeObject:_selectedPageView];
            
            if (_pageViews.count > 1)
            {
                for (UIView *theView in _pageViews)
                {
                    [UIView animateWithDuration:0.66f animations:^{
                       
                        theView.center = _center;
                    }];
                }
            }
            
            [UIView animateWithDuration:1.f animations:^{
                
                CGAffineTransform transform = CGAffineTransformMakeRotation(180.f * M_PI / 180.f);
                _selectedPageView.transform = transform;
                
                _selectedPageView.bounds = CGRectMake(0.f, 0.f, 0.f, 0.f);
                _selectedPageView.alpha = 0.f;
                
            } completion:^(BOOL finished) {
                _selectedPageView = nil;
                _isAnimating = NO;
            }];
        }
        else
        {
            _isAnimating = YES;
            for (UIView *theView in _pageViews)
            {
                [UIView animateWithDuration:0.66f animations:^{
                    
                    theView.center = _center;
                } completion:^(BOOL finished) {
                    
                    _isAnimating = NO;
                }];
            }
        }
    }
    else
    {
        _isAnimating = YES;
        for (UIView *theView in _pageViews)
        {
            [UIView animateWithDuration:0.66f animations:^{
                
                theView.center = _center;
            } completion:^(BOOL finished) {
                
                _isAnimating = NO;
            }];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isAnimating = YES;
    for (UIView *theView in _pageViews)
    {
        [UIView animateWithDuration:0.66f animations:^{
            
            theView.center = _center;
        } completion:^(BOOL finished) {
            
            _isAnimating = NO;
        }];
    }
}


- (IBAction)resetAction:(id)sender
{
    if (!_isAnimating)
    {
        if (_pageViews.count > 0)
        {
            for (UIView *theView in _pageViews)
            {
                [theView removeFromSuperview];
            }
        }
        
        _pageViews = [NSMutableArray new];
        _selectedPageView = nil;
        _isAnimating = false;
        [self setupPageViews];
    }
}


/**
 * 计算两点的距离
 */

- (CGFloat)distanceOfTwoPoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint
{
    return sqrtf(fabs(firstPoint.x - secondPoint.x) * fabs(firstPoint.x - secondPoint.x) + fabs(firstPoint.y - secondPoint.y) * fabs(firstPoint.y - secondPoint.y));
}

/**
 * 根据角度得到圆圈轨迹上的坐标
 */
-(CGPoint)pointFromAngle:(int)angleInt withDistance:(CGFloat)distance
{
    CGPoint result;
    result.y = round(_center.y + distance * sin(ToRad(angleInt))) ;
    result.x = round(_center.x + distance * cos(ToRad(angleInt)));
    
    return result;
}

/**
 * 计算中心点到任意点的角度
 */
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped)
{
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end








