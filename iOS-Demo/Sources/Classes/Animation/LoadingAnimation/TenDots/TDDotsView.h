//
//  TDDotsView.h
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDDotsView : UIView

@property(nonatomic, assign, readonly) CGSize dotSize;
@property(nonatomic, assign, readonly) CGFloat animationDuration;
@property(nonatomic, assign, readonly) NSUInteger numberOfDots;

- (instancetype)initWithFrame:(CGRect)frame dotSize:(CGSize)dotSize animationDuration:(CGFloat)animationDuration numberOfDots:(NSUInteger)numberOfDots;

- (void)startWithAnimation;

@end
