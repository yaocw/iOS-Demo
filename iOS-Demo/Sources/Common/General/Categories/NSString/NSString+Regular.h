//
//  NSString+Regular.h
//  hxj
//
//  Created by gaofu on 15/10/22.
//  Copyright © 2015年 gaofu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)



///匹配正整数
- (BOOL)isPositiveInteger;

///匹配负整数
- (BOOL)isNegativeInteger;

///匹配整数
- (BOOL)isInteger;

///匹配非负整数（正整数 + 0）
- (BOOL)isPositiveIntegerContainZero;

///匹配非正整数（负整数 + 0）
- (BOOL)isNegativeIntegerContainZero;

///匹配正浮点数
- (BOOL)isPositiveFloatingNumber;

///匹配负浮点数
- (BOOL)isNegativeFloatingNumber;

///匹配浮点数
- (BOOL)isFloatingNumber;

///匹配非负浮点数（正浮点数 + 0）
- (BOOL)isPositiveFloatingNumberContainZero;

///匹配非正浮点数（负浮点数 + 0）
- (BOOL)isNegativeFloatingNumberContainZero;

///匹配由26个英文字母组成的字符串
- (BOOL)isAllEnglishAlphabet;

///匹配由26个英文字母的大写组成的字符串
- (BOOL)isAllCapitalEnglishAlphabet;

///匹配由26个英文字母的小写组成的字符串
- (BOOL)isAllLowerEnglishAlphabet;

///匹配由数字和26个英文字母组成的字符串
- (BOOL)isEnglishAlphabetAndNumber;

///匹配由数字、26个英文字母或者下划线组成的字符串
- (BOOL)isEnglishAlphabetAndNumberAndUnderline;

///匹配中文
- (BOOL)isChineseWords;

///匹配邮件地址
- (BOOL)isEmail;

///匹配URL地址
- (BOOL)isUrl;

///匹配手机号码
- (BOOL)isTelephoneNumber;

//判断字符串是否为空(@"", nil, NULL)
- (BOOL)isBlankString;

@end
