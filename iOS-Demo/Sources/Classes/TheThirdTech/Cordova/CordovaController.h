//
//  CordovaController.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/18.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Cordova/CDVViewController.h>
#import <Cordova/CDVCommandDelegateImpl.h>
#import <Cordova/CDVCommandQueue.h>

@interface CordovaController : CDVViewController

@end


@interface CordovaCommandDelegate : CDVCommandDelegateImpl

@end

@interface CordovaCommandQueue : CDVCommandQueue

@end
