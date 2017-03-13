//
//  DataPersistenceController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "DataPersistenceController.h"

@interface DataPersistenceController ()

@end

@implementation DataPersistenceController

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
