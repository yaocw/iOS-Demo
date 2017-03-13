//
//  UsingFBShimmeringController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/10.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "UsingFBShimmeringController.h"
#import "FBShimmeringView.h"

@interface UsingFBShimmeringController ()

@end

@implementation UsingFBShimmeringController
{
    FBShimmeringView *_shimmeringView;
    UILabel *_logoLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}


- (void)initializeUIComponents
{
    _shimmeringView = [FBShimmeringView new];

    _shimmeringView.shimmeringBeginFadeDuration = 0.3f;
    _shimmeringView.shimmeringOpacity = 0.3f;
    _shimmeringView.bounds = CGRectMake(0, 0, kDeviceWidth, 66.0f);
    _shimmeringView.center = CGPointMake(kDeviceWidth / 2.0f, kDeviceHeight / 2.0f);
    [self.view addSubview:_shimmeringView];
    
    _logoLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    _logoLabel.text = @"Hello Shimmering!";
    _logoLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:46.0f];
    _logoLabel.textColor = [UIColor blackColor];
    _logoLabel.textAlignment = NSTextAlignmentCenter;
    _logoLabel.backgroundColor = [UIColor clearColor];
    _shimmeringView.contentView = _logoLabel;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _shimmeringView.shimmering = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _shimmeringView.shimmering = NO;
}

@end
