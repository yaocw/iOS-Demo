//
//  Helper.h
//  YouJia
//
//  Created by user on 15/6/25.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Helper : NSObject

/**
 *  确保源字符串不为nil/NULL，当字符串为nil/NULL等时，将返回空字符串
 */
+ (NSString *)ensureStringToNotNULL:(NSString *)sourceString;

/**
 *  判断一个字符串是否为空（字符串为空的情况包括字符串对象为空和字符串值为空的情况）
 */
+ (BOOL)isNullOrEmptyString:(NSString *)sourceString;

/**
 *  判断一个对象是否为空
 */
+ (BOOL)isNullObject:(id)sourceObject;

//是否为空字符串
+ (BOOL)isNilStr:(NSString*)siftStr;

/**
 *  必填字段校验
 */
+ (BOOL)validateDataForNotNullValueWithInputObjects:(NSArray *)inputObjects prompts:(NSArray *)prompts;

/**
 * 根据角度得到圆圈轨迹上的坐标
 */
+ (CGPoint)pointFromAngle:(int)angleInt centerPoint:(CGPoint)centerPoint radius:(CGFloat)radius;

/**
 * 计算中心点到任意点的角度
 */
+ (CGFloat)angleFromNorthWithP1:(CGPoint)p1 p2:(CGPoint)p2 flipped:(BOOL)flipped;

@end



