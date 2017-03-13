//
//  CustomPopupView.m
//  MMPopupView
//
//  Created by szhhxh on 15/11/1.
//  Copyright © 2015年 LJC. All rights reserved.
//

#import "CustomPopupView.h"

static const NSUInteger kMaxLengthOfMessage = 199;  //提示信息的最大长度

@implementation CustomPopupView

#pragma mark - Default AlertView

+(void)alertView:(MMPopupItemHandler)block title:(NSString*)title message:(NSString *)message items:(NSString*)items,... NS_REQUIRES_NIL_TERMINATION
{
    if ((message != nil) && (message != NULL) && (![message isKindOfClass:[NSNull class]]) && (message.length > kMaxLengthOfMessage))
    {
        message = [message substringToIndex:kMaxLengthOfMessage];
        message = [NSString stringWithFormat:@"%@...", message];
    }
    
    NSMutableArray *itemsArr = [NSMutableArray array];
    
    NSString* tmpValue = items;
    int tmpCount = 0;
    
    va_list list;
    va_start(list,items);
    while(tmpValue != nil)
    {
        ++tmpCount;
        [itemsArr addObject:MMItemMake(tmpValue, MMItemTypeNormal, block)];
        tmpValue = va_arg(list,NSString*);
    }
    va_end(list);
    
    [[[MMAlertView alloc] initWithTitle:title detail:message items:itemsArr] showWithBlock:nil];
}


#pragma mark - Confirm AlertView

+(void)alertViewWithTitle:(NSString*)title message:(NSString *)message confirm:(NSString*)confirm
{
    if ((message != nil) && (message != NULL) && (![message isKindOfClass:[NSNull class]]) && (message.length > kMaxLengthOfMessage))
    {
        message = [message substringToIndex:kMaxLengthOfMessage];
        message = [NSString stringWithFormat:@"%@...", message];
    }
    
    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
    alertConfig.defaultTextOK = confirm;
    [[[MMAlertView alloc] initWithConfirmTitle:title detail:message] showWithBlock:nil];
}

+(void)alertViewForUploadFailure
{
    [self alertViewWithTitle:@"提示" message:@"上传失败" confirm:@"确定"];
}

+(void)alertViewForNetworkConnectionFailure
{
    [self alertViewWithTitle:@"提示" message:@"网络连接失败" confirm:@"确定"];
}


#pragma mark - Confirm AlertView

+(void)alertViewWithTitle:(NSString*)title message:(NSString *)message placeholder:(NSString*)placeholder input:(MMPopupInputHandler)input
{
    if ((message != nil) && (message != NULL) && (![message isKindOfClass:[NSNull class]]) && (message.length > kMaxLengthOfMessage))
    {
        message = [message substringToIndex:kMaxLengthOfMessage];
        message = [NSString stringWithFormat:@"%@...", message];
    }
    
    [[[MMAlertView alloc] initWithInputTitle:title detail:message placeholder:placeholder handler:^(NSString *text) {
        input(text);
    }] showWithBlock:nil];
}

#pragma mark - SheetView

+(void)sheetView:(MMPopupItemHandler)block title:(NSString*)title destructive:(NSString*)destructive otherItems:(NSString*)items,... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *itemsArr = [NSMutableArray array];
    
    int tmpCount = 0;
    NSString* tmpValue = items;
    
    va_list list;
    va_start(list,items);
    while(tmpValue != nil)
    {
        ++tmpCount;
        [itemsArr addObject:MMItemMake(tmpValue, MMItemTypeNormal, block)];
        tmpValue = va_arg(list,NSString*);
    }
    va_end(list);
    
    destructive ? [itemsArr addObject:MMItemMake(destructive, MMItemTypeHighlight, block)] : 0;
    
    [[[MMSheetView alloc] initWithTitle:title items:itemsArr] showWithBlock:nil];
}


+(void)sheetViewWithTitle:(NSString*)title otherItems:(NSMutableArray*)items destructive:(NSString*)destructive click:(MMPopupItemHandler)block
{
    NSMutableArray *itemsArr = [NSMutableArray array];
    for (NSString*item in items)
    {
        [itemsArr addObject:MMItemMake(item, MMItemTypeNormal, block)];
    }
    
    destructive ? [itemsArr addObject:MMItemMake(destructive, MMItemTypeHighlight, block)] : 0;

    [[[MMSheetView alloc] initWithTitle:title items:itemsArr] showWithBlock:nil];
}


#pragma mark - DateView

+(void)dateViewWithType:(UIDatePickerMode)type date:(MMDate)dateBlock
{
    [[[MMDateView alloc] initWithType:(UIDatePickerMode)type dateBlock:^(NSDate *date) {
        dateBlock(date);
    }] showWithBlock:nil];
}

@end
