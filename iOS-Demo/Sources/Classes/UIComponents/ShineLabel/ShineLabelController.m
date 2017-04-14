//
//  ShineLabelController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/14.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "ShineLabelController.h"

#import "RQShineLabel.h"

@interface ShineLabelController ()

@end

@implementation ShineLabelController
{
    RQShineLabel *_shineLabel;
    
    BOOL _shineLabelAppear;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    _shineLabel = [[RQShineLabel alloc] initWithFrame:CGRectMake(0.f, 64.f, kDeviceWidth, kDeviceWidth - 64.f)];
    _shineLabel.numberOfLines = 0;
    _shineLabel.text = @"我就是我，是颜色不一样的烟火。For something this complicated, it’s really hard to design products by focus groups. A lot of times, people don’t know what they want until you show it to them. 致-张国荣";
    _shineLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0f];
    _shineLabel.backgroundColor = [UIColor clearColor];
    _shineLabel.textColor = kRandomColor;
    [_shineLabel sizeToFit];
    [self.view addSubview:_shineLabel];
    
    [_shineLabel shine];
    _shineLabelAppear = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_shineLabelAppear)
    {
        [_shineLabel fadeOut];
    }
    else
    {
        [_shineLabel shine];
    }
    
    _shineLabelAppear = !_shineLabelAppear;
}

@end




