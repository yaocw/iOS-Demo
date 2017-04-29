//
//  MyFirstCdvPlugin.h
//  iOS-Demo
//
//  Created by yaochaowen on 2017/4/29.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import <Cordova/CDV.h>

@interface MyFirstCdvPlugin : CDVPlugin

- (void)printHelloWorld:(CDVInvokedUrlCommand *)command;

@end
