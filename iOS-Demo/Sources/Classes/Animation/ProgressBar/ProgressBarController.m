//
//  ProgressBarController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/13.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ProgressBarController.h"

@interface ProgressBarController ()

@end

@implementation ProgressBarController

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
