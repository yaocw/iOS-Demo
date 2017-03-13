//
//  SS_Canvas.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/2.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SS_Canvas.h"
#import "SS_Dot.h"
#import "SS_Line.h"

@implementation SS_Canvas

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.lines = [NSMutableArray new];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_lines.count > 0)
    {
        
        SS_Dot *dot;
        for (SS_Line *line in _lines)
        {
            
            CGContextSetLineWidth(context, line.paintbrushSize);
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextSetStrokeColorWithColor(context, line.paintbrushColor.CGColor);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            
            
            UIBezierPath *paintPath = [UIBezierPath bezierPath];
            
            for (int i = 0; i < line.lineDots.count; i ++)
            {
                dot = line.lineDots[i];
                
                if (i == 0)
                {
                    [paintPath moveToPoint:dot.dotPoint];
                }
                else
                {
                    [paintPath addLineToPoint:dot.dotPoint];
                }
            }
            
            CGContextAddPath(context, paintPath.CGPath);
            
            CGContextStrokePath(context);
        }
    }
    else
    {
        CGContextStrokePath(context);
    }
}

@end
