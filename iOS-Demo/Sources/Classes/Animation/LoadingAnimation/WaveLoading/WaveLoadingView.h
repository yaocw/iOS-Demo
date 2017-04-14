//
//  WaveLoadingView.h
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/14.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveLoadingView : UIView

+ (instancetype)loadingView;

- (void)startLoading;

- (void)stopLoading;

@end
