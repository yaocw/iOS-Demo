//
//  ChooseMusicalScaleScopeView.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseMusicalScaleScopeView : UIView

@property (nonatomic, assign) int musicalScaleScopeFrom;
@property (nonatomic, assign) int musicalScaleScopeTo;

- (void)setDidChoosedBlock:(BLKBlock)aBlock;

@end
