//
//  NTIpAddressUtils.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTIpAddressUtils : NSObject

+ (NTIpAddressUtils *)shareManager;

- (NSString *)getIpAddress:(BOOL)preferIPv4;  //获取设备当前网络IP地址

@end
