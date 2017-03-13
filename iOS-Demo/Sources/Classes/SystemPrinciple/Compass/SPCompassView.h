//
//  SPCompassView.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/20.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPCompassView : UIView

/**
 *  初始化
 *
 *  @param radius 半径（最小不小于50，最大不大于控件短边的一半）
 *
 *  @return 返回罗盘对象
 */
+ (instancetype)sharedWithRect:(CGRect)rect radius:(CGFloat)radius;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *calibrationColor;
@property (nonatomic, strong) UIColor *northColor;
@property (nonatomic, strong) UIColor *horizontalColor;

@end
