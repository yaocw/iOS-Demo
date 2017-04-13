//
//  LoadingAnimationController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "LoadingAnimationController.h"

@interface LoadingAnimationController ()

@end

@implementation LoadingAnimationController

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
