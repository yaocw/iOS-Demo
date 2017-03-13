//
//  SimpleScrawlController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/1.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SimpleScrawlController.h"
#import "LMPopMenu.h"
#import "PaintbrushSettingController.h"
#import "SS_Dot.h"
#import "SS_Line.h"
#import "SS_Canvas.h"

#define mNumberOfMaxWithdrawLins 10

@interface SimpleScrawlController ()

@end

@implementation SimpleScrawlController
{
    SS_Canvas *_paintCanvas;
    
    NSMutableArray *_withdrawLines;
    
    CGFloat _paintbrushSize;
    UIColor *_paintbrushColor;
    
    SS_Line *_currentLine;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewWillAppear:(BOOL)animated
{
    _paintbrushSize = ((NSNumber *)kFetchFromUserDefaults(@"MT_SS_PaintBrushSize")).floatValue;
    if (_paintbrushSize <= 0.0f)
    {
        _paintbrushSize = 1.0f;
    }
    
    
    NSString *colorHexString = kFetchFromUserDefaults(@"MT_SS_PaintBrushColor");
    if (kIsNotNullOrEmptyWithString(colorHexString))
    {
        _paintbrushColor = [UIColor colorWithHexColorString:colorHexString];
    }
    else
    {
        _paintbrushColor = [UIColor orangeColor];
    }
}

- (void)initializeBaseData
{
    _withdrawLines = [NSMutableArray new];
}

- (void)initializeUIComponents
{
    _paintCanvas = [[SS_Canvas alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 64.0f)];
    _paintCanvas.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_paintCanvas];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    
    if (anyTouch)
    {
        _currentLine = [SS_Line new];
        _currentLine.lineDots = [NSMutableArray new];
        
        SS_Dot *startDot = [SS_Dot new];
        startDot.dotPoint = [anyTouch locationInView:self.view];
        
        _currentLine.paintbrushSize = _paintbrushSize;
        _currentLine.paintbrushColor = _paintbrushColor;
        
        [_currentLine.lineDots addObject:startDot];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_currentLine.lineDots.count == 1)
    {
        [_paintCanvas.lines addObject:_currentLine];
        [_withdrawLines removeAllObjects];
    }
    
    UITouch *anyTouch = [touches anyObject];
    
    if (anyTouch)
    {
        SS_Dot *currentDot = [SS_Dot new];
        currentDot.dotPoint = [anyTouch locationInView:self.view];

        [_currentLine.lineDots addObject:currentDot];
        [_paintCanvas setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _currentLine = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _currentLine = nil;
}




#pragma mark -- Actions

- (IBAction)withdrawAction:(id)sender
{
    if (_paintCanvas.lines.count > 0)
    {
        NSMutableArray *withdrawLine = [_paintCanvas.lines lastObject];
        [_paintCanvas.lines removeLastObject];
        [_withdrawLines insertObject:withdrawLine atIndex:0];
        
        if (_withdrawLines.count > mNumberOfMaxWithdrawLins)
        {
            [_withdrawLines removeLastObject];
        }
        
        [_paintCanvas setNeedsDisplay];
    }
}

- (IBAction)unWithdrawAction:(id)sender
{
    if (_withdrawLines.count > 0)
    {
        NSMutableArray *withdrawLine = [_withdrawLines firstObject];
        [_withdrawLines removeObjectAtIndex:0];
        [_paintCanvas.lines addObject:withdrawLine];
        
        [_paintCanvas setNeedsDisplay];
    }
}

- (IBAction)paintbrushSettingAction:(id)sender
{
    PaintbrushSettingController *controller = kInstanceFromStoryboard(@"PaintbrushSettingController", @"PaintbrushSettingController");
    kPushViewControllerWithController(controller);
}

- (IBAction)clearAction:(id)sender
{
    [_paintCanvas.lines removeAllObjects];
    [_paintCanvas setNeedsDisplay];
}



@end





