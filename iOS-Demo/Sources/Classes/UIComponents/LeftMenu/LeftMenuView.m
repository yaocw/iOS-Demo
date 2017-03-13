//
//  LeftMenuView.m
//  LeftMenuDemo
//
//  Created by yaochaowen on 16/12/9.
//  Copyright © 2016年 yaochaowen. All rights reserved.
//

#import "LeftMenuView.h"

@interface LeftMenuView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LeftMenuView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCellIdentifier"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellIdentifier"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Menu - %ld", (long)indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
