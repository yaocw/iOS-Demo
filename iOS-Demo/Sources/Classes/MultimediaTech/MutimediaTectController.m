//
//  MutimediaTectController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/7.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MutimediaTectController.h"

@interface MutimediaTectController ()

@end

@implementation MutimediaTectController


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
