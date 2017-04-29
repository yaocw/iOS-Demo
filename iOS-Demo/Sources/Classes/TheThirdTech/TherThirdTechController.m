//
//  TherThirdTechController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/18.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "TherThirdTechController.h"

@interface TherThirdTechController ()

@end

@implementation TherThirdTechController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
