//
//  DP_USWCD_AddUserInfoController.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMDatabase;

@interface DP_USWCD_AddUserInfoController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *context;

- (void)setDidAddedUserInfoBlock:(BLKBlock)aBlock;

@end
