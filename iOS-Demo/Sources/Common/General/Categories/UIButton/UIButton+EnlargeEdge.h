//
//  UIButton+EnlargeEdge.h
//  YouJia
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeEdge)
/**
 *  修改Btn的点击范围
 */
- (void)setEnlargeEdge:(CGFloat) size;

- (void)setEnlargeEdgeWithOffSet:(UIEdgeInsets)offset;

@end
