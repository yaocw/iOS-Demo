//
//  MainController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/5.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData];
    [self initializeUIComponents];
}

- (void)initializeData
{
    
}

- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
}


#pragma mark -- TableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *cellContentView = [cell contentView];
    cellContentView.layer.transform = CATransform3DMakeTranslation(0, -56.0f, 0);
    cellContentView.layer.opacity = 0;
    
    [UIView animateWithDuration:0.66f animations:^{
        cellContentView.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
        cellContentView.layer.opacity = 1;
    } completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}



@end
