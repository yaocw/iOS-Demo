//
//  CustomPopupView.h
//  MMPopupView
//
//  Created by szhhxh on 15/11/1.
//  Copyright © 2015年 LJC. All rights reserved.
//自定义弹出窗

#import <Foundation/Foundation.h>
#import "MMPopupItem.h"
#import "MMAlertView.h"
#import "MMSheetView.h"
#import "MMDateView.h"
#import "MMPopupWindow.h"

@interface CustomPopupView : NSObject

#pragma mark - Default AlertView

+(void)alertView:(MMPopupItemHandler)block title:(NSString*)title message:(NSString *)message items:(NSString*)items,... NS_REQUIRES_NIL_TERMINATION;


#pragma mark - Confirm AlertView

+(void)alertViewWithTitle:(NSString*)title message:(NSString *)message confirm:(NSString*)confirm;

+(void)alertViewForUploadFailure;

+(void)alertViewForNetworkConnectionFailure;


#pragma mark - Input AlertView
+(void)alertViewWithTitle:(NSString*)title message:(NSString *)message placeholder:(NSString*)placeholder input:(MMPopupInputHandler)input;


#pragma mark - SheetView

+(void)sheetView:(MMPopupItemHandler)block title:(NSString*)title destructive:(NSString*)destructive otherItems:(NSString*)items,... NS_REQUIRES_NIL_TERMINATION;

+(void)sheetViewWithTitle:(NSString*)title otherItems:(NSArray*)items destructive:(NSString*)destructive click:(MMPopupItemHandler)block;


#pragma mark - DateView

+(void)dateViewWithType:(UIDatePickerMode)type date:(MMDate )dateBlock;

@end
