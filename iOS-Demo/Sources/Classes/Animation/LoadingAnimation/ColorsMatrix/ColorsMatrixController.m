//
//  ColorsMatrixController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "ColorsMatrixController.h"

#import "CMColorsBoxView.h"

@interface ColorsMatrixController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation ColorsMatrixController

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
    for (int i = 0; i < 10; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            CMColorsBoxView *boxView = [CMColorsBoxView new];
            boxView.frame = CGRectMake(i * 20.f, j * 20.f, 20.f, 20.f);
            [_mainView addSubview:boxView];
        }
    }
    
}

@end
