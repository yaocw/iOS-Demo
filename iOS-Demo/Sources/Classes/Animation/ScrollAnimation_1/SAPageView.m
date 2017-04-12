//
//  SAPageView.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/12.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "SAPageView.h"

@implementation SAPageView
{
    UIImageView *_bgImageView;
}

- (void)refresh
{
    if (!_bgImageView)
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _bgImageView.image = kLoadLocalImage(@"sex_girl_1.jpg");
        _bgImageView.alpha = 0.f;
        [self addSubview:_bgImageView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = self.frame;
        [self addSubview:effectView];
    }
    
    [UIView animateWithDuration:0.66f animations:^{
        
        _bgImageView.alpha = 1.f;
    }];
}

@end
