//
//  ChooseSoundIntervalController.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/10.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseSoundIntervalController : UITableViewController

@property (nonatomic, strong) NSArray *choosedSoundIntervalArr;

- (void)setDidChoosedBlock:(BLKArrBlock)aBlock;

@end
