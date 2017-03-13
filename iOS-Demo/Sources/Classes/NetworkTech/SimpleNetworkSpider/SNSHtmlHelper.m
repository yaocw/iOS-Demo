//
//  SNSHtmlHelper.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNSHtmlHelper.h"

@implementation SNSHtmlHelper

+ (NSString *)htmlFromUrl:(NSString *)urlString
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (data == nil || data.length == 0)
    {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    }
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    
    if (retStr == nil || [retStr isEqualToString:@""])
    {
        retStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }
    
    return retStr;
}

@end
