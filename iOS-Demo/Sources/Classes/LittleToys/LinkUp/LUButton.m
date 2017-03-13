//
//  LUButton.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/22.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LUButton.h"

@implementation LUButton

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 2.0f;
    }
    else
    {
        self.layer.borderWidth = 0;
    }
}

@end
