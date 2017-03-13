//
//  SS_Line.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/1.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SS_Line : NSObject

@property (nonatomic, strong) NSMutableArray *lineDots;

@property (nonatomic, assign) CGFloat paintbrushSize;
@property (nonatomic, strong) UIColor *paintbrushColor;

@end
