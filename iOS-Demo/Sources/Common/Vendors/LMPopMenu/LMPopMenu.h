//
//  LMPopMenu.h
//  MobileOfficing
//
//  Created by yaochaowen on 16/8/2.
//  Copyright © 2016年 SZHHXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMPopMenu : NSObject

+ (instancetype)sharePopMenu;

- (void)showPopMenuWithPoint:(CGPoint)point menuTitles:(NSArray *)titles menuIcons:(NSArray *)icons clickItemBlock:(BLKSelecetIndexBlock)aBlock;

@end
