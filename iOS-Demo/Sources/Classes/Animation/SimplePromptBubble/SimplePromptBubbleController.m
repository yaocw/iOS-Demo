//
//  SimplePromptBubbleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/28.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SimplePromptBubbleController.h"

#define mStrokeWidth 3.0f
#define mMainLayerWidth (kDeviceWidth - 60.0f)
#define mMainLayerHeight mMainLayerWidth

@interface SimplePromptBubbleController () <CAAnimationDelegate>

@end

@implementation SimplePromptBubbleController
{
    UILabel *_loadingLabel;
    CAShapeLayer *_mainLayer;
    
    CABasicAnimation *_strokeStartAnimation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData];
    [self initializeUIComponents];
}

- (void)initializeData
{
    
}

- (void)initializeUIComponents
{
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 169.0f, 49.0f)];
    _loadingLabel.text = @"加载完成";
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.font = [UIFont systemFontOfSize:22.0f];
    _loadingLabel.backgroundColor = [UIColor colorWithHexColorString:@"0X78A501"];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.hidden = YES;
    _loadingLabel.layer.cornerRadius = 5.0f;
    _loadingLabel.layer.masksToBounds = YES;
    [self.view addSubview:_loadingLabel];
}

- (void)popBubble
{
    _loadingLabel.hidden = YES;
    
    [_mainLayer removeAllAnimations];
    [_mainLayer removeFromSuperlayer];
    
    _mainLayer = [CAShapeLayer layer];
    _mainLayer.frame = CGRectMake((kDeviceWidth - mMainLayerWidth) / 2.0f, (kDeviceHeight - mMainLayerHeight) / 2.0f, mMainLayerWidth, mMainLayerHeight);
    [self.view.layer addSublayer:_mainLayer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.frame = _mainLayer.bounds;
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineWidth = mStrokeWidth;
        circleLayer.strokeColor = [UIColor orangeColor].CGColor;
        

        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        [circlePath addArcWithCenter: CGPointMake(_mainLayer.frame.size.width / 2.0f, _mainLayer.frame.size.height / 2.0f) radius:_mainLayer.frame.size.width / 2.0f - mStrokeWidth startAngle:0.0f endAngle:2.0f * M_PI clockwise: NO];
        [circlePath addLineToPoint: CGPointMake(_mainLayer.frame.size.width / 2.0f, mMainLayerHeight - mStrokeWidth)];
        [circlePath addLineToPoint: CGPointMake(mStrokeWidth, mMainLayerHeight / 2.0f)];
        [circlePath addLineToPoint: CGPointMake(_mainLayer.frame.size.width / 2.0f, mStrokeWidth)];
        [circlePath addLineToPoint: CGPointMake(_mainLayer.frame.size.width - mStrokeWidth, mMainLayerHeight / 2.0f)];
        
        [circlePath addLineToPoint: CGPointMake(mStrokeWidth, mMainLayerHeight / 2.0f)];
        [circlePath moveToPoint:CGPointMake(_mainLayer.frame.size.width / 2.0f, mStrokeWidth)];
        [circlePath addLineToPoint: CGPointMake(_mainLayer.frame.size.width / 2.0f, mMainLayerHeight - mStrokeWidth)];
        
        
        circleLayer.path = circlePath.CGPath;
        [_mainLayer addSublayer: circleLayer];
        
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"strokeEnd"];
        animation.duration = 1.66f;
        animation.fromValue = [NSNumber numberWithInt: 0.0f];
        animation.toValue = [NSNumber numberWithInt: 1.0f];
        
        

        CAMediaTimingFunction *timing = [[CAMediaTimingFunction alloc] initWithControlPoints:0.3f :0.6f :0.8f :1.1f];
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath: @"strokeStart"];
        strokeStartAnimation.duration = 2.66f;
        strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.2f;
        strokeStartAnimation.fillMode = kCAFillModeForwards;
        strokeStartAnimation.fromValue = [NSNumber numberWithFloat: 0.0f];
        strokeStartAnimation.toValue = [NSNumber numberWithFloat: 1.0f];
        strokeStartAnimation.timingFunction = timing;
        strokeStartAnimation.delegate = self;
        

        [circleLayer addAnimation: animation forKey: @"strokeEnd"];
        [circleLayer addAnimation: strokeStartAnimation forKey: @"strokeStart"];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self popBubble];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.view bringSubviewToFront:_loadingLabel];
    
    _loadingLabel.center = CGPointMake(kDeviceWidth / 2.0f, -60.0f);
    [UIView animateWithDuration:0.66f delay:0.0f usingSpringWithDamping:0.66f initialSpringVelocity:0.66f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _loadingLabel.hidden = NO;
        _loadingLabel.center = CGPointMake(kDeviceWidth / 2.0f, kDeviceHeight / 2.0f);
        
    } completion:nil];
}


@end
