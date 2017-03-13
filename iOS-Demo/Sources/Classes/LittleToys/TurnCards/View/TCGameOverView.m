//
//  TCGameOverView.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/24.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "TCGameOverView.h"

@implementation TCGameOverView
{
    BLKBlock _dissmissViewBlock;
}

- (void)dissmissViewBlock:(BLKBlock)aBlock
{
    _dissmissViewBlock = aBlock;
}

- (IBAction)clickAction:(id)sender
{
    _dissmissViewBlock ? _dissmissViewBlock() : nil;
    
    [UIView animateWithDuration:0.66f animations:^{
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
    
}

@end
