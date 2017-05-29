//
//  StaveView.m
//  iOS-Demo
//
//  Created by yaochaowen on 2017/5/27.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "StaveView.h"

#define mNoteSize CGSizeMake(20.f, 16.f)
#define mSpaceOfStaveLine 18.f
#define mStaveLineHeight 2.f
#define mStaveLineColor [UIColor blackColor].CGColor
#define mShortStaveLineWidth 50.f

@implementation StaveView

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat midWidth = width * 0.5f;
    
    CGFloat height = rect.size.height;
    CGFloat midHeight = height * 0.5;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, mStaveLineHeight);
    CGContextSetStrokeColorWithColor(context, mStaveLineColor);
    CGContextSetFillColorWithColor(context, mStaveLineColor);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
    
    
    CGMutablePathRef staveLinesPath = CGPathCreateMutable();
    CGPathMoveToPoint(staveLinesPath, &transform, 0.f, midHeight);
    CGPathAddLineToPoint(staveLinesPath, &transform, width, midHeight);
    CGContextAddPath(context, staveLinesPath);
    
    for (int i = 1; i <= 2; i ++)
    {
        CGMutablePathRef staveLinesPath = CGPathCreateMutable();
        CGPathMoveToPoint(staveLinesPath, &transform, 0.f, midHeight - (i * mSpaceOfStaveLine));
        CGPathAddLineToPoint(staveLinesPath, &transform, width, midHeight - (i * mSpaceOfStaveLine));
        CGContextAddPath(context, staveLinesPath);
    }
    
    for (int i = 1; i <= 2; i ++)
    {
        CGMutablePathRef staveLinesPath = CGPathCreateMutable();
        CGPathMoveToPoint(staveLinesPath, &transform, 0.f, midHeight + (i * mSpaceOfStaveLine));
        CGPathAddLineToPoint(staveLinesPath, &transform, width, midHeight + (i * mSpaceOfStaveLine));
        CGContextAddPath(context, staveLinesPath);
    }
    
    
    CGFloat noteCenter_y = 0.f;
    if (_noteLevel > _centerLevelOfNotes)
    {
        NSInteger spaceNoteLevel = _noteLevel - _centerLevelOfNotes;
        noteCenter_y = midHeight - (spaceNoteLevel * (mSpaceOfStaveLine * 0.5f)) - mNoteSize.height * 0.5f;
        
        CGFloat tempTheFifthStaveLine_y = midHeight - (2 * mSpaceOfStaveLine);
        for (int i = 1; i < (spaceNoteLevel / 2) - 1; i ++)
        {
            CGMutablePathRef staveLinesPath = CGPathCreateMutable();
            CGPathMoveToPoint(staveLinesPath, &transform, midWidth - (mShortStaveLineWidth * 0.5f), tempTheFifthStaveLine_y - (i * mSpaceOfStaveLine));
            CGPathAddLineToPoint(staveLinesPath, &transform, midWidth + (mShortStaveLineWidth * 0.5f), tempTheFifthStaveLine_y - (i * mSpaceOfStaveLine));
            CGContextAddPath(context, staveLinesPath);
        }
    }
    else if (_noteLevel == _centerLevelOfNotes)
    {
        noteCenter_y = midHeight - mNoteSize.height * 0.5f;
    }
    else
    {
        NSInteger spaceNoteLevel = _centerLevelOfNotes - _noteLevel;
        noteCenter_y = midHeight + (spaceNoteLevel * (mSpaceOfStaveLine * 0.5f)) - mNoteSize.height * 0.5f;
        
        CGFloat tempTheFifthStaveLine_y = midHeight + (2 * mSpaceOfStaveLine);
        for (int i = 1; i < (spaceNoteLevel / 2) - 1; i ++)
        {
            CGMutablePathRef staveLinesPath = CGPathCreateMutable();
            CGPathMoveToPoint(staveLinesPath, &transform, midWidth - (mShortStaveLineWidth * 0.5f), tempTheFifthStaveLine_y + (i * mSpaceOfStaveLine));
            CGPathAddLineToPoint(staveLinesPath, &transform, midWidth + (mShortStaveLineWidth * 0.5f), tempTheFifthStaveLine_y + (i * mSpaceOfStaveLine));
            CGContextAddPath(context, staveLinesPath);
        }
    }
    
    
    CGMutablePathRef notePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(notePath, &transform, CGRectMake(midWidth - mNoteSize.width * 0.5f, noteCenter_y, mNoteSize.width, mNoteSize.height));
    CGContextAddPath(context, notePath);
    
    
    
    CGContextStrokePath(context);
}


@end
