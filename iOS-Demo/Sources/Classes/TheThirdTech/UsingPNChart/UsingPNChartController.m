//
//  UsingPNChartController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "UsingPNChartController.h"

@interface UsingPNChartController ()

@end

@implementation UsingPNChartController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    kRemoveBottomLinesForTableView(self.tableView);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController * viewController = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"lineChart"])
    {
        viewController.title = @"Line Chart";
    }
    else if ([segue.identifier isEqualToString:@"barChart"])
    {
        viewController.title = @"Bar Chart";
    }
    else if ([segue.identifier isEqualToString:@"circleChart"])
    {
        viewController.title = @"Circle Chart";
    }
    else if ([segue.identifier isEqualToString:@"pieChart"])
    {
        viewController.title = @"Pie Chart";
    }
    else if ([segue.identifier isEqualToString:@"scatterChart"])
    {
        viewController.title = @"Scatter Chart";
    }
    else if ([segue.identifier isEqualToString:@"radarChart"])
    {
        viewController.title = @"Radar Chart";
    }
}

@end
