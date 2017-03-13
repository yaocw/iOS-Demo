//
//  SNS_MatchingRuleView.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNS_MatchingRuleView : UIView

@property (nonatomic, copy) NSArray *matchingRules;

- (void)setDidChangedHeightBlock:(BLKBlock)aBlock;

@end
