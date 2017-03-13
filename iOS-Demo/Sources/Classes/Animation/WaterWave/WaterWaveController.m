//
//  WaterWaveController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/2.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "WaterWaveController.h"

@interface WaterWaveController () <UICollisionBehaviorDelegate, CAAnimationDelegate>

@end

@implementation WaterWaveController
{
    CADisplayLink *_waveDisplaylink;
    CAShapeLayer *_waveLayer;
    UIBezierPath *_waveBoundaryPath;
    
    CGFloat _waterWaveHeight;
    CGFloat _waterWaveWidth;
    CGFloat _offsetX;
    
    CGFloat _waveAmplitude;
    CGFloat _waveSpeed;
    
    
    UIImageView *_fishImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)initializeUIComponents
{
    _waterWaveHeight = self.view.frame.size.height / 2.0f;
    _waterWaveWidth  = self.view.frame.size.width;
    
    _waveAmplitude = 6.0f;
    _waveSpeed = 6.0f;
    
    _waveLayer = [CAShapeLayer layer];
    _waveLayer.fillColor = [UIColor colorWithRed:0.0f green:0.722f blue:1.0f alpha:1.0f].CGColor;
    [self.view.layer addSublayer:_waveLayer];
    
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
    _fishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_waterWaveWidth - 30.0f,_waterWaveHeight - 15.0f, 30.0f, 30.0f)];
    _fishImageView.image = [UIImage imageNamed:@"fish.png"];
    _fishImageView.hidden = YES;
    [self.view addSubview:_fishImageView];
}

- (void)getCurrentWave:(CADisplayLink *)displayLink
{
    _offsetX += _waveSpeed;
    _waveLayer.path = [self getgetCurrentWavePath].CGPath;
}

- (UIBezierPath *)getgetCurrentWavePath
{
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0.0f, 10.0f);
    
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <= _waterWaveWidth ; x++)
    {
        y = _waveAmplitude * sinf((360.0f / _waterWaveWidth) *(x * M_PI / 180.0f) - _offsetX * M_PI / 180.0f) + _waterWaveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.view.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.view.frame.size.height);
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    CGPathRelease(path);
    
    return p;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _fishImageView.hidden = NO;
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(_fishImageView.frame.size.width / 2.0f, _fishImageView.center.y);
    
    [trackPath moveToPoint:startPoint];
    [trackPath addQuadCurveToPoint:_fishImageView.center controlPoint:CGPointMake((_fishImageView.center.x - startPoint.x) / 2.0f + startPoint.x, _fishImageView.center.y - 60.0f)];
    
    CAKeyframeAnimation *fishAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    fishAnim.path = trackPath.CGPath;
    fishAnim.rotationMode = kCAAnimationRotateAuto;
    fishAnim.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1f :0.4f :0.9f :0.6f];
    fishAnim.duration = 1.0f;
    fishAnim.removedOnCompletion = YES;
    fishAnim.fillMode = kCAFillModeForwards;
    fishAnim.delegate = self;
    [_fishImageView.layer addAnimation:fishAnim forKey:@"fishAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _fishImageView.hidden = YES;
}

@end
