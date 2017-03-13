//
//  OverallAnimationsController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/8.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "OverallAnimationsController.h"

@interface OverallAnimationsController ()

@end

@implementation OverallAnimationsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
}


#pragma mark -- TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
