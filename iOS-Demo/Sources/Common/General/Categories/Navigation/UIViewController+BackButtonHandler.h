//
//  UIViewController+BackButtonHandler.h
//  ksf
//
//  Created by zhuda on 16/3/10.
//  Copyright © 2016年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackButtonHandlerProtocol <NSObject>

@optional

// Override this method in UIViewController derived class to handle 'Back' button click

-(BOOL)navigationShouldPopOnBackButton;

@end
@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end
