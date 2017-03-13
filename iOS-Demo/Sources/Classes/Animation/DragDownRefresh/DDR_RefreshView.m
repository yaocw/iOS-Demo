//
//  DDR_RefreshView.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/2.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "DDR_RefreshView.h"

#define mDegreesToRadians(x) (M_PI * (x) / 180.0f)

@implementation DDR_RefreshView
{
    __weak IBOutlet UIImageView *_sunImageView;
    
    CADisplayLink *_displaylink;
    
    CGFloat _rotationAngle;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _rotationAngle = 0;
    
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(lanchAnimation)];
    [_displaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)lanchAnimation
{
    _rotationAngle ++;
    
    _sunImageView.transform = CGAffineTransformMakeRotation(mDegreesToRadians(_rotationAngle));
}

@end
