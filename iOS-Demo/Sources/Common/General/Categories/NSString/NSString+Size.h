//
//  NSString+Size.h
//  工具类封装
//
//  Created by apple on 15/10/19.
//  Copyright © 2015年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

//计算字符窜文字的宽度
-(CGFloat)widthWithfont:(UIFont *)font height:(CGFloat)height;

//计算字符串文字的高度
-(CGFloat)heightWithfont:(UIFont *)font width:(CGFloat)width;

@end
