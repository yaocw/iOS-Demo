//
//  UIComponentsController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/6.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "UIComponentsController.h"

@interface UIComponentsController ()

@end

@implementation UIComponentsController

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
