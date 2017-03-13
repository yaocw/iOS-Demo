//
//  KeyboardToolBar.h
//  InputAccessoryDemo
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 Study. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KTBFinishInputBlock)();

@interface KeyboardToolBar : UIToolbar

//收键盘按钮
+ (KeyboardToolBar *)keyboardToolBarWithFinishInputBlock:(KTBFinishInputBlock)aBlock;

@end
