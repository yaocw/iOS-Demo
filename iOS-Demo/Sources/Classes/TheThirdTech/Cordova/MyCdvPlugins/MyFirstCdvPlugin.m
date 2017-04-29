//
//  MyFirstCdvPlugin.m
//  iOS-Demo
//
//  Created by yaochaowen on 2017/4/29.
//  Copyright © 2017年 yaocw. All rights reserved.
//


/**
 * 自定义插件步骤
 * 1、添加本地类，继承自“CDVPlugin”
 * 2、添加插件方法声明，参数为“CDVInvokedUrlCommand”类型
 * 3、实现插件方法
 * 4、在config.xml里添加插件映射，如下：
 *    <feature name="这里填写插件的名称">
 *        <param name="ios-package" value="这里填写插件的本地类名" />
 *        <param name="onload" value="true" />
 *    </feature>
 * 5、添加调用插件的js代码（本例子中，js代码在index.html中）
 */

#import "MyFirstCdvPlugin.h"

@implementation MyFirstCdvPlugin

- (void)printHelloWorld:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* result = nil;
    NSString* myarg = [command.arguments objectAtIndex:0];
    
    NSLog(@"js调用了native代码：%@", myarg);
    
    if (myarg != nil)
    {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"这是从native传过来的参数"];
    }
    else
    {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"这是从native传过来的参数"];
    }
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
