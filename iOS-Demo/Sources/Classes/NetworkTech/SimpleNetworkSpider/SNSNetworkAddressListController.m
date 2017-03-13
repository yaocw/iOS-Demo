//
//  SNSNetworkAddressListController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNSNetworkAddressListController.h"
#import "SNS_NetworkAddressItemCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define kNetworkAddressItemCellIdentifier @"SNS_NetworkAddressItemCell"

@interface SNSNetworkAddressListController ()

@end

@implementation SNSNetworkAddressListController
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeUIComponents];
}

- (void)initializeUIComponents
{
    kRegisterNibCell(@"SNS_NetworkAddressItemCell", kNetworkAddressItemCellIdentifier);
    kRemoveBottomLinesForTableView(self.tableView);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fetchedResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNS_NetworkAddressItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kNetworkAddressItemCellIdentifier];
    cell.networkAddressLabel.text = _fetchedResults[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    height = [tableView fd_heightForCellWithIdentifier:kNetworkAddressItemCellIdentifier cacheByIndexPath:indexPath configuration:^(SNS_NetworkAddressItemCell *cell) {
        
        cell.networkAddressLabel.text = _fetchedResults[indexPath.row];
    }];
    
    return height < 56.0f ? 56.0f : height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_fetchedResults[indexPath.row]]];
}



@end




