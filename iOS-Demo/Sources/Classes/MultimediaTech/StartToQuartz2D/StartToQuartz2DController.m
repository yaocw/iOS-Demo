//
//  StartToQuartz2DController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/3.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "StartToQuartz2DController.h"
#import "KCView.h"

@interface StartToQuartz2DController ()

@end

@implementation StartToQuartz2DController
{
    KCView *_kcview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _kcview = [[KCView alloc] initWithFrame:CGRectMake(0, 64.0f, kDeviceWidth, kDeviceHeight - 64.0f)];
    _kcview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_kcview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _kcview.showFlag ++;
    _kcview.showFlag %=  9;
    [_kcview setNeedsDisplay];
}

@end
