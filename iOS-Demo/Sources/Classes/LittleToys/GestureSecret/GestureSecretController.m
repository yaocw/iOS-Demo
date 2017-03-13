//
//  GestureSecretController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/21.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "GestureSecretController.h"

#define mSecretButtonSize CGSizeMake(56.0f, 56.0f)
#define mSecretButtonRadius 28.0f

@interface GestureSecretController ()

@end

@implementation GestureSecretController
{
    NSMutableArray *_secretButtons;
    NSMutableArray *_selectedButtons;
    
    CGPoint _startPoint;
    CGPoint _endPoint;
    
    CAShapeLayer *_mainLayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initializeBaseData];
    [self initializeUIComponents];
    
}

- (void)initializeBaseData
{
    _secretButtons = [NSMutableArray new];
    _selectedButtons = [NSMutableArray new];
}

- (void)initializeUIComponents
{
    _mainLayer = [CAShapeLayer layer];
    _mainLayer.strokeColor = [UIColor orangeColor].CGColor;
    _mainLayer.lineWidth = 3.0f;
    _mainLayer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:_mainLayer];
    
    for (int i = 0; i < 9; i ++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mSecretButtonSize.width, mSecretButtonSize.height)];
        btn.center = CGPointMake((kDeviceWidth / 4.0f) * (i % 3 + 1), (kDeviceHeight / 2.0 - 1.5f * mSecretButtonSize.height - kDeviceWidth / 4.0f) + (kDeviceWidth / 4.0f) * (i / 3));
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius = mSecretButtonRadius;
        btn.layer.masksToBounds = YES;
        btn.userInteractionEnabled = NO;
        [_secretButtons addObject:btn];
        [self.view addSubview:btn];
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    
    if (anyTouch)
    {
        for (UIButton *btn in _secretButtons)
        {
            if ([btn pointInside:[anyTouch locationInView:btn] withEvent:nil])
            {
                [_selectedButtons addObject:btn];
                _startPoint = btn.center;
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    
    if (anyTouch)
    {
        if (_selectedButtons.count > 0)
        {
            _endPoint = [anyTouch locationInView:self.view];
            for (UIButton *btn in _secretButtons)
            {
                if ([btn pointInside:[anyTouch locationInView:btn] withEvent:nil])
                {
                    if (![_selectedButtons containsObject:btn])
                    {
                        [_selectedButtons addObject:btn];
                    }
                }
            }
            
            [self drawLines];
        }
    }
    
}

- (void)drawLines
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(_startPoint.x, _startPoint.y)];
    for (UIButton *btn in _selectedButtons)
    {
        [linePath addLineToPoint:CGPointMake(btn.center.x, btn.center.y)];
    }
    
    [linePath addLineToPoint:CGPointMake(_endPoint.x, _endPoint.y)];
    
    _mainLayer.path = linePath.CGPath;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_mainLayer removeFromSuperlayer];
    
    _mainLayer = [CAShapeLayer layer];
    _mainLayer.strokeColor = [UIColor orangeColor].CGColor;
    _mainLayer.lineWidth = 3.0f;
    _mainLayer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:_mainLayer];
    
    [_selectedButtons removeAllObjects];
}

@end








