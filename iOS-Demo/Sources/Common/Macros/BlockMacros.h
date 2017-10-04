//
//  BlockMacros.h
//  RaccoonHomeClient
//
//  Created by yaochaowen on 15/10/20.
//  Copyright © 2015年 yaochaowen. All rights reserved.
//
/**
 *  Block宏
 */


#ifndef BlockMacros_h
#define BlockMacros_h

#import <Foundation/Foundation.h>


typedef void(^BLKBlock)();
typedef void (^BLKCompleteBlock)(NSString *text);
typedef void(^BLKSelecetIndexBlock)(NSInteger index);
typedef void(^BLKIndexBlock)(NSInteger index);
typedef void(^BLKArrBlock)(NSArray *arr);
typedef void(^BLKObjectBlock)(id obj);

#endif /* BlockMacros_h */
