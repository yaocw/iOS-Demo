//
//  TDDotView.h
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDDotView : UIView

@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGPoint originPoint;
@property(nonatomic, assign) CGPoint destinationPoint;
@property(nonatomic, assign) CGFloat animationDuration;

- (void)startWithAnimationWithDelay:(CGFloat)delay complete:(BLKIndexBlock)complete;
- (void)resetWithAnimationWithDelay:(CGFloat)delay complete:(BLKIndexBlock)complete;

@end
