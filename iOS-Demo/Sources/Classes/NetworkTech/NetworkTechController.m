//
//  NetworkTechController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "NetworkTechController.h"
#import "NTIpAddressUtils.h"

@interface NetworkTechController ()

@end

@implementation NetworkTechController

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
    
    //获取ip地址
    if (indexPath.row == 0)
    {
        NSString *ipAddress = [[NTIpAddressUtils shareManager] getIpAddress:YES];
        if (kIsNotNullOrEmptyWithString(ipAddress))
        {
            [CustomPopupView alertViewWithTitle:@"IP地址" message:ipAddress confirm:@"确定"];
        }
        else
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"获取IP地址失败" confirm:@"确定"];
        }
    }
}

@end
