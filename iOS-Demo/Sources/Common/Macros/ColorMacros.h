//
//  ColorMacros.h
//  RaccoonHomeClient
//
//  Created by gaofu on 15/10/20.
//  Copyright © 2015年 gaofu. All rights reserved.
//
/**
 *  颜色宏
 */


#ifndef ColorMacros_h
#define ColorMacros_h

/**
 *  16进制颜色
 *
 *  @param Hex 16进制颜色字符串
  *  @param a   透明度
 */
#define kHexColor(Hex) [UIColor colorWithHexColorString:Hex]
#define kHexColorAndAlpha(Hex,a) [UIColor colorWithHexString:Hex alpha:a]



/**
 * 产生随机颜色
 */
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#define kRandomColorWithAlpha(alpha) [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:alpha]

#endif /* ColorMacros_h */
