//
//  NSString+Size.m
//  工具类封装
//
//  Created by apple on 15/10/19.
//  Copyright © 2015年 wangzhen. All rights reserved.
//

#import "NSString+Size.h"


@implementation NSString (Size)

//计算字符窜文字的宽度
-(CGFloat)widthWithfont:(UIFont *)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

//计算字符串文字的高度
-(CGFloat)heightWithfont:(UIFont *)font width:(CGFloat)width
{
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName : font}
                                context:nil].size.height;
}



@end
