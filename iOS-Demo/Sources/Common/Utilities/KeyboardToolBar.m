//
//  KeyboardToolBar.m
//  InputAccessoryDemo
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 Study. All rights reserved.
//

#import "KeyboardToolBar.h"

@implementation KeyboardToolBar {
    KTBFinishInputBlock _finishInputBlock;
}

+ (KeyboardToolBar *)keyboardToolBarWithFinishInputBlock:(KTBFinishInputBlock)aBlock
{
    KeyboardToolBar *keyboardToolBarInstance = [self new];
    [keyboardToolBarInstance setFinishInputBlock:aBlock];
    return keyboardToolBarInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,44);
        UIBarButtonItem *flexibleBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *finishInputBarBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishInput)];
        
        self.tintColor = [UIColor blackColor];
        self.items = @[flexibleBarBtnItem, finishInputBarBtnItem];
        
    }
    return self;
}

- (void)setFinishInputBlock:(KTBFinishInputBlock)aBlock
{
    _finishInputBlock = aBlock;
}


- (void)finishInput {
    if (_finishInputBlock) {
        _finishInputBlock();
    }
}


@end
