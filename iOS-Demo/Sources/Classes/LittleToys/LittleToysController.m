//
//  LittleToysController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/21.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LittleToysController.h"

@interface LittleToysController ()

@end

@implementation LittleToysController

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
