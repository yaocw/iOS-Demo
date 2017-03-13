//
//  SphereTagsController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/2.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SphereTagsController.h"
#import "STSphereTagsView.h"

@interface SphereTagsController ()

@property (nonatomic, retain) STSphereTagsView *sphereView;

@end

@implementation SphereTagsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sphereView = [[STSphereTagsView alloc] initWithFrame:CGRectMake(16.0f, 100.0f, kDeviceWidth - 32.0f, kDeviceHeight)];
    
    NSMutableArray *tags = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 50; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        btn.frame = CGRectMake(0.0f, 0.0f, 66.0f, 20.0f);
        
        btn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [btn setTitle:[NSString stringWithFormat:@"Tags:%ld", i] forState:UIControlStateNormal];
        [btn setTitleColor:kRandomColor forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [tags addObject:btn];
        [_sphereView addSubview:btn];
    }
    
    [_sphereView setCloudTags:tags];
    _sphereView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_sphereView];
}

- (void)buttonPressed:(UIButton *)btn
{
    [_sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        btn.transform = CGAffineTransformMakeScale(2., 2.);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1., 1.);
            
        } completion:^(BOOL finished) {
            
            [_sphereView timerStart];
            
        }];
        
    }];
}

@end
