//
//  SNSAddSelfDefineMatchingRuleController.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMDatabase;

@interface SNSAddSelfDefineMatchingRuleController : UITableViewController

@property (nonatomic, strong) FMDatabase *db;

- (void)setDidAddedRuleBlock:(BLKBlock)aBlock;

@end
