//
//  MusicalScaleItemHeaderView.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/6.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicalScaleItemHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *choosedMusicalScaleLabel;

- (void)setCollapseFlag:(NSString *)collapseFlag;

- (void)setDidClickHeaderViewBlock:(BLKBlock)aBlock;

@end
