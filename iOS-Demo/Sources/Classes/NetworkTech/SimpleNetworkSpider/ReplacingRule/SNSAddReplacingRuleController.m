//
//  SNSAddReplacingRuleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNSAddReplacingRuleController.h"
#import "SNS_AddReplacingRuleCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SNS_ReplacingRuleModel.h"
#import "SNSAddSelfDefineReplacingRuleController.h"
#import "FMDB.h"

#define kAddReplacingRuleCellIdentifier @"SNS_AddReplacingRuleCell"

@interface SNSAddReplacingRuleController ()

@end

@implementation SNSAddReplacingRuleController
{
    BLKObjectBlock _didSelectedRuleBlock;
    
    NSMutableArray *_replacingRules;
    
    FMDatabase *_db;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
    
}

- (void)initializeBaseData
{
    [self configureDatabase];
    [self fetchReplacingRules];
}

- (void)initializeUIComponents
{
    kRegisterNibCell(@"SNS_AddReplacingRuleCell", kAddReplacingRuleCellIdentifier);
    kRemoveBottomLinesForTableView(self.tableView);
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)configureDatabase
{
    NSString *sqliteFilePath = [kDocumentsDirectoryPath stringByAppendingPathComponent:@"NT_SNS_Database.sqlite"];
    _db = [FMDatabase databaseWithPath:sqliteFilePath];
    
    if ([_db open])
    {
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_replacing_rules (before_replace_content text NOT NULL, after_replace_content text NOT NULL);"];
        
        if (!result)
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"数据库初始化失败，请联系客服" confirm:@"确定"];
        }
    }
}

- (void) fetchReplacingRules
{
    _replacingRules = [NSMutableArray new];
    
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM t_replacing_rules"];
    while ([resultSet next])
    {
        [_replacingRules addObject:@{@"BeforeReplaceContent" : resultSet[@"before_replace_content"], @"AfterReplaceContent" : resultSet[@"after_replace_content"]}];
    }
}


- (void)setDidSelectedRuleBlock:(BLKObjectBlock)aBlock
{
    _didSelectedRuleBlock = aBlock;
}


#pragma mark -- UITableView Database

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _replacingRules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNS_AddReplacingRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddReplacingRuleCellIdentifier];
    NSDictionary *ruleDic = _replacingRules[indexPath.row];
    cell.beforeReplaceContentLabel.text = ruleDic[@"BeforeReplaceContent"];
    cell.afterReplaceContentLabel.text = ruleDic[@"AfterReplaceContent"];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    height = [tableView fd_heightForCellWithIdentifier:kAddReplacingRuleCellIdentifier cacheByIndexPath:indexPath configuration:^(SNS_AddReplacingRuleCell *cell) {
        
        NSDictionary *ruleDic = _replacingRules[indexPath.row];
        cell.beforeReplaceContentLabel.text = ruleDic[@"BeforeReplaceContent"];
        cell.afterReplaceContentLabel.text = ruleDic[@"AfterReplaceContent"];
    }];
    
    return height;
}


#pragma mark -- Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SNSAddSelfDefineReplacingRuleController"])
    {
        SNSAddSelfDefineReplacingRuleController *controller = segue.destinationViewController;
        controller.db = _db;
        
        [controller setDidAddedRuleBlock:^{
            
            [self fetchReplacingRules];
            [self.tableView reloadData];
        }];
    }
}


#pragma mark -- UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *ruleDic = _replacingRules[indexPath.row];
    SNS_ReplacingRuleModel *model = [SNS_ReplacingRuleModel new];
    model.beforeReplaceContent = ruleDic[@"BeforeReplaceContent"];;
    model.afterReplaceContent = ruleDic[@"AfterReplaceContent"];
    
    _didSelectedRuleBlock ? _didSelectedRuleBlock(model) : nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *ruleDic = _replacingRules[indexPath.row];
    
    BOOL deleteResult = [_db executeUpdateWithFormat:@"DELETE FROM t_replacing_rules WHERE before_replace_content=%@ AND after_replace_content=%@", ruleDic[@"BeforeReplaceContent"], ruleDic[@"AfterReplaceContent"]];
    
    if (deleteResult)
    {
        [_replacingRules removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark -- Actions



#pragma mark -- dealloc

- (void)dealloc
{
    [_db close];
    _db = nil;
}
@end
