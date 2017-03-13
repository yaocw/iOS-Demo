//
//  AnimationController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/5.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "AnimationController.h"

@interface AnimationController ()

@end

@implementation AnimationController

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
