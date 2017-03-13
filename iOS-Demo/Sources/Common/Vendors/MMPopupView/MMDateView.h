//
//  MMDateView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/7/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"

typedef void(^MMDate)(NSDate*date);

@interface MMDateView : MMPopupView

-(instancetype)initWithType:(UIDatePickerMode)type dateBlock:(MMDate)dateBlock;

@end
