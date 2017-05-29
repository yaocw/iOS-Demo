//
//  StaveForTwoView.h
//  iOS-Demo
//
//  Created by yaochaowen on 2017/5/29.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaveForTwoView : UIView

@property (nonatomic, copy) NSArray *notesLevel;
@property (nonatomic, assign) NSInteger centerLevelOfNotes;
@property (nonatomic, assign) NSInteger focusIndex;

@end
