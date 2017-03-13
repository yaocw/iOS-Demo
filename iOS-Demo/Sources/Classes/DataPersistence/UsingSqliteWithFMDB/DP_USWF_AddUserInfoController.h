//
//  DP_USWF_AddUserInfoController.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMDatabase;

@interface DP_USWF_AddUserInfoController : UITableViewController

@property (nonatomic, strong) FMDatabase *db;

- (void)setDidAddedUserInfoBlock:(BLKBlock)aBlock;

@end
