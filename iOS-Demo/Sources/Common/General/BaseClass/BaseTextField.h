//
//  BaseTextField.h
//  hxj
//
//  Created by szhhxh on 16/1/3.
//  Copyright © 2016年 szhhxh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTextField : UITextField

@property (nonatomic, assign) NSInteger maxLengthOfText;  //可输入的最大字符数量

@property (nonatomic, assign) BOOL onlyAllowInputNumber; //设置是否只能输入数值，默认不限制
@property (nonatomic, assign) NSUInteger maxPrecisionOfDecimal;  //设置小数的精度，默认不限制

- (void)setTextChangeBlock:(BLKBlock)aBlock;

@end
