//
//  Helper.m
//  YouJia
//
//  Created by user on 15/6/25.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import "Helper.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@implementation Helper


+ (NSString *)ensureStringToNotNULL:(NSString *)sourceString
{
    if (sourceString == nil || sourceString == NULL || [sourceString isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    return sourceString;
}

/**
 *  判断一个对象是否为空
 */
+ (BOOL)isNullObject:(id)sourceObject
{
    if (sourceObject == nil || sourceObject == NULL || [sourceObject isKindOfClass:[NSNull class]]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isNilStr:(NSString*)siftStr
{
    
    if (siftStr == nil)
    {
        return YES;
    }
    
    if (siftStr == NULL)
    {
        return YES;
    }
    
    if ([siftStr isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    return NO;
}


/**
 *  判断一个字符串是否为空（字符串为空的情况包括字符串对象为空和字符串值为空的情况）
 */
+ (BOOL)isNullOrEmptyString:(NSString *)sourceString {
    if (sourceString == nil || sourceString == NULL || [sourceString isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    
    sourceString =  [sourceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([sourceString isEqualToString:@""])
    {
        return YES;
    }
    
    return NO;
}



/**
 *  必填字段校验
 */
+ (BOOL)validateDataForNotNullValueWithInputObjects:(NSArray *)inputObjects prompts:(NSArray *)prompts
{
    if ([Helper isNullObject:inputObjects] || inputObjects.count <= 0)
    {
        return YES;
    }
    
    
    NSInteger index = 0;
    
    for (id inputObject in inputObjects)
    {
        NSString *text;
        
        if ([inputObject isKindOfClass:[UITextField class]] || [inputObject isKindOfClass:[UITextView class]] || [inputObject isKindOfClass:[UILabel class]])
        {
            text = [inputObject valueForKey:@"text"];
        }
        else if ([inputObject isKindOfClass:[NSString class]])
        {
            text = inputObject;
        }
        
        if ([Helper isNullOrEmptyString:text])
        {
            if (![Helper isNullObject:prompts] && prompts.count > index)
            {
                [CustomPopupView alertViewWithTitle:[NSString stringWithFormat:@"[ %@ ]  不能为空", prompts[index]] message:nil confirm:@"确定"];
            }
            else
            {
                [CustomPopupView alertViewWithTitle:@"必填字段不能为空" message:nil confirm:@"确定"];
            }
            
            return NO;
        }
        
        index ++;
    }
    
    return YES;
}


/**
 * 根据角度得到圆圈轨迹上的坐标
 */
+ (CGPoint)pointFromAngle:(int)angleInt centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius
{
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(angleInt)));
    
    return result;
}

/**
 * 计算中心点到任意点的角度
 */
+ (CGFloat)angleFromNorthWithP1:(CGPoint)p1 p2:(CGPoint)p2 flipped:(BOOL)flipped
{
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}


@end
