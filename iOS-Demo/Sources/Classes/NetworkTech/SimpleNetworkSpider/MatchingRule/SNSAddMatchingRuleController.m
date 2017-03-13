//
//  SNSAddMatchingRuleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNSAddMatchingRuleController.h"
#import "SNS_AddMatchingRuleCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SNS_MatchingRuleModel.h"
#import "SNSAddSelfDefineMatchingRuleController.h"
#import "FMDB.h"

#define kAddMatchingRuleCellIdentifier @"SNS_AddMatchingRuleCell"

@interface SNSAddMatchingRuleController ()

@end

@implementation SNSAddMatchingRuleController
{
    BLKObjectBlock _didSelectedRuleBlock;
    
    NSMutableArray *_matchingRules;
    NSInteger _defaultRulesCount;
    
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
    [self fetchMatchingRules];
}

- (void)initializeUIComponents
{
    kRegisterNibCell(@"SNS_AddMatchingRuleCell", kAddMatchingRuleCellIdentifier);
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
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_matching_rules (rule_name text NOT NULL, rule_content text NOT NULL);"];
        
        if (!result)
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"数据库初始化失败，请联系客服" confirm:@"确定"];
        }
    }
}

- (void) fetchMatchingRules
{
    _matchingRules = [kLoadArrayFromPlistFile(@"DefaultMatchingRules") mutableCopy];
    _defaultRulesCount = _matchingRules.count;
    
    FMResultSet *resultSet = [_db executeQuery:@"SELECT * FROM t_matching_rules"];
    while ([resultSet next])
    {
        [_matchingRules addObject:@{@"RuleName" : resultSet[@"rule_name"], @"RuleContent" : resultSet[@"rule_content"]}];
    }
}


- (void)setDidSelectedRuleBlock:(BLKObjectBlock)aBlock
{
    _didSelectedRuleBlock = aBlock;
}


#pragma mark -- UITableView Database

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _matchingRules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNS_AddMatchingRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddMatchingRuleCellIdentifier];
    NSDictionary *ruleDic = _matchingRules[indexPath.row];
    cell.matchingRuleNameLabel.text = ruleDic[@"RuleName"];
    cell.matchingRuleContentLabel.text = ruleDic[@"RuleContent"];
    
    if (indexPath.row < _defaultRulesCount)
    {
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    height = [tableView fd_heightForCellWithIdentifier:kAddMatchingRuleCellIdentifier cacheByIndexPath:indexPath configuration:^(SNS_AddMatchingRuleCell *cell) {
        
        NSDictionary *ruleDic = _matchingRules[indexPath.row];
        cell.matchingRuleNameLabel.text = ruleDic[@"RuleName"];
        cell.matchingRuleContentLabel.text = ruleDic[@"RuleContent"];
    }];
    
    return height;
}


#pragma mark -- Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SNSAddSelfDefineMatchingRuleController"])
    {
        SNSAddSelfDefineMatchingRuleController *controller = segue.destinationViewController;
        controller.db = _db;
        
        [controller setDidAddedRuleBlock:^{
            
            [self fetchMatchingRules];
            [self.tableView reloadData];
        }];
    }
}


#pragma mark -- UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *ruleDic = _matchingRules[indexPath.row];
    SNS_MatchingRuleModel *model = [SNS_MatchingRuleModel new];
    model.matchingRuleName = ruleDic[@"RuleName"];;
    model.matchingRuleContent = ruleDic[@"RuleContent"];
    
    _didSelectedRuleBlock ? _didSelectedRuleBlock(model) : nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _defaultRulesCount)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *ruleDic = _matchingRules[indexPath.row];
    
    BOOL deleteResult = [_db executeUpdateWithFormat:@"DELETE FROM t_matching_rules WHERE rule_name=%@", ruleDic[@"RuleName"]];
    
    if (deleteResult)
    {
        [_matchingRules removeObjectAtIndex:indexPath.row];
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




