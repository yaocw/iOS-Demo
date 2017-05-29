//
//  StaveForTwoView.m
//  iOS-Demo
//
//  Created by yaochaowen on 2017/5/29.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "StaveForTwoView.h"

#define mNoteSize CGSizeMake(20.f, 16.f)
#define mSpaceOfStaveLine 18.f
#define mStaveLineHeight 2.f
#define mStaveLineColor [UIColor blackColor].CGColor

#define mSpaceOfNotes 33.f

#define mFocusNoteColor [UIColor orangeColor].CGColor
#define mNormalNoteColor [UIColor blackColor].CGColor

#define mFocusNoteLineHeight 3.f
#define mNormalNoteLineHeight 2.f


@implementation StaveForTwoView

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    
    CGFloat height = rect.size.height;
    CGFloat midHeight = height * 0.5;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, mStaveLineHeight);
    CGContextSetStrokeColorWithColor(context, mStaveLineColor);
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
    
    if (_notesLevel.count == 0)
    {
        CGContextStrokePath(context);
    }
    else
    {
        int noteLevel = 0;
        CGFloat noteCenter_y = 0.f;
        CGFloat firstNote_x = 80.f;
        
        for (NSNumber *theNoteLevel in _notesLevel)
        {
            noteLevel = theNoteLevel.intValue;
            
            if (noteLevel > _centerLevelOfNotes)
            {
                NSInteger spaceNoteLevel = noteLevel - _centerLevelOfNotes;
                noteCenter_y = midHeight - (spaceNoteLevel * (mSpaceOfStaveLine * 0.5f)) - mNoteSize.height * 0.5f;
                
                CGFloat tempTheFifthStaveLine_y = midHeight - (2 * mSpaceOfStaveLine);
                for (int i = 1; i < (spaceNoteLevel / 2) - 1; i ++)
                {
                    CGMutablePathRef staveLinesPath = CGPathCreateMutable();
                    CGPathMoveToPoint(staveLinesPath, &transform, firstNote_x - 3.f, tempTheFifthStaveLine_y - (i * mSpaceOfStaveLine));
                    CGPathAddLineToPoint(staveLinesPath, &transform, firstNote_x + mNoteSize.width + 3.f, tempTheFifthStaveLine_y - (i * mSpaceOfStaveLine));
                    CGContextAddPath(context, staveLinesPath);
                }
            }
            else if (noteLevel == _centerLevelOfNotes)
            {
                noteCenter_y = midHeight - mNoteSize.height * 0.5f;
            }
            else
            {
                NSInteger spaceNoteLevel = _centerLevelOfNotes - noteLevel;
                noteCenter_y = midHeight + (spaceNoteLevel * (mSpaceOfStaveLine * 0.5f)) - mNoteSize.height * 0.5f;
                
                CGFloat tempTheFifthStaveLine_y = midHeight + (2 * mSpaceOfStaveLine);
                for (int i = 1; i < (spaceNoteLevel / 2) - 1; i ++)
                {
                    CGMutablePathRef staveLinesPath = CGPathCreateMutable();
                    CGPathMoveToPoint(staveLinesPath, &transform, firstNote_x - 3.f, tempTheFifthStaveLine_y + (i * mSpaceOfStaveLine));
                    CGPathAddLineToPoint(staveLinesPath, &transform, firstNote_x + mNoteSize.width + 3.f, tempTheFifthStaveLine_y + (i * mSpaceOfStaveLine));
                    CGContextAddPath(context, staveLinesPath);
                }
            }
            
            firstNote_x += mSpaceOfNotes;
        }
        
        CGContextStrokePath(context);
        
        int index = 0;
        noteLevel = 0;
        noteCenter_y = 0.f;
        firstNote_x = 80.f;
        for (NSNumber *theNoteLevel in _notesLevel)
        {
            noteLevel = theNoteLevel.intValue;
            
            if (noteLevel > _centerLevelOfNotes)
            {
                NSInteger spaceNoteLevel = noteLevel - _centerLevelOfNotes;
                noteCenter_y = midHeight - (spaceNoteLevel * (mSpaceOfStaveLine * 0.5f)) - mNoteSize.height * 0.5f;
            }
            else if (noteLevel == _centerLevelOfNotes)
            {
                noteCenter_y = midHeight - mNoteSize.height * 0.5f;
            }
            else
            {
                NSInteger spaceNoteLevel = _centerLevelOfNotes - noteLevel;
                noteCenter_y = midHeight + (spaceNoteLevel * (mSpaceOfStaveLine * 0.5f)) - mNoteSize.height * 0.5f;
            }
            
            CGMutablePathRef notePath = CGPathCreateMutable();
            CGPathAddEllipseInRect(notePath, &transform, CGRectMake(firstNote_x, noteCenter_y, mNoteSize.width, mNoteSize.height));
            CGContextAddPath(context, notePath);
            
            if (_notesLevel.count == 2)
            {
                CGContextSetLineWidth(context, mFocusNoteLineHeight);
                CGContextSetStrokeColorWithColor(context, mFocusNoteColor);
                CGContextStrokePath(context);
            }
            else
            {
                if (_focusIndex == index)
                {
                    CGContextSetLineWidth(context, mFocusNoteLineHeight);
                    CGContextSetStrokeColorWithColor(context, mFocusNoteColor);
                    CGContextStrokePath(context);
                }
                else
                {
                    CGContextSetLineWidth(context, mNormalNoteLineHeight);
                    CGContextSetStrokeColorWithColor(context, mNormalNoteColor);
                    CGContextStrokePath(context);
                }
            }
            
            firstNote_x += mSpaceOfNotes;
            index ++;
        }
    }
}


@end
