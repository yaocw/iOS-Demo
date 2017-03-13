//
//  GameTechController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "GameTechController.h"

@interface GameTechController ()

@end

@implementation GameTechController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)viewWillAppear:(BOOL)animated
{
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
