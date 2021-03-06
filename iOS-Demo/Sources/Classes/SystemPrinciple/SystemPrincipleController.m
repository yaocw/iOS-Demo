//
//  SystemPrincipleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/20.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SystemPrincipleController.h"

@interface SystemPrincipleController ()

@end

@implementation SystemPrincipleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
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
