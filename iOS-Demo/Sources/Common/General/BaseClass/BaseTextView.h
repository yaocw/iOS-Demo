//
//  BaseTextView.h
//  YouJia
//
//  Created by user on 15/9/1.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BTVTextDidChangedBlock)();

@interface BaseTextView : UITextView

@property (nonatomic, readonly) UILabel *placeHolderLab;
@property (nonatomic, assign) NSInteger maxLengthOfText;

- (void)setTextDidChangedBlock:(BTVTextDidChangedBlock)aBlcok;

- (void)refreshPlaceHolder;

@end
