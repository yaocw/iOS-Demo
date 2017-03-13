//
//  MusicalScaleItemHeaderView.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/6.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MusicalScaleItemHeaderView.h"

@implementation MusicalScaleItemHeaderView
{
    __weak IBOutlet UIImageView *arrowImageView;
    
    BLKBlock _didClickHeaderViewBlock;
}

- (void)setCollapseFlag:(NSString *)collapseFlag
{
    if ([collapseFlag isEqualToString:@"YES"])
    {
        arrowImageView.image = [UIImage imageNamed:@"bottom_arrow"];
    }
    else
    {
        arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    }
}

- (void)setDidClickHeaderViewBlock:(BLKBlock)aBlock
{
    _didClickHeaderViewBlock = aBlock;
}

- (IBAction)clickAction:(id)sender
{
    _didClickHeaderViewBlock == nil ? nil : _didClickHeaderViewBlock();
}


@end
