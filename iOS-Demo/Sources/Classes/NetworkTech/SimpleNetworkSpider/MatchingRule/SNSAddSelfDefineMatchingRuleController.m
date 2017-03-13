//
//  SNSAddSelfDefineMatchingRuleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNSAddSelfDefineMatchingRuleController.h"
#import "BaseTextView.h"
#import "FMDB.h"
#import "Helper.h"

@interface SNSAddSelfDefineMatchingRuleController ()

@end

@implementation SNSAddSelfDefineMatchingRuleController
{
    __weak IBOutlet UITextField *_ruleNameTextField;
    __weak IBOutlet BaseTextView *_ruleContentTextView;
    
    BLKBlock _didAddedRuleBlock;;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
    
}

- (void)initializeBaseData
{
    
    
}

- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
    
    _ruleContentTextView.placeHolderLab.text = @"请输入匹配规则";
    
}

- (void)setDidAddedRuleBlock:(BLKBlock)aBlock
{
    _didAddedRuleBlock = aBlock;
}

#pragma mark -- UITableView ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

#pragma mark -- Actions

- (IBAction)ensureAction:(id)sender
{
    if (!_db)
    {
        [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"数据库初始化失败，请联系客服" confirm:@"确定"];
        return ;
    }
    
    
    BOOL validateResult = [Helper validateDataForNotNullValueWithInputObjects:@[_ruleNameTextField, _ruleContentTextView] prompts:@[@"规则名称", @"匹配规则"]];
    
    if (validateResult)
    {
        FMResultSet *resultSet = [_db executeQueryWithFormat:@"SELECT * FROM t_matching_rules WHERE rule_name=%@", _ruleNameTextField.text];
        if (![resultSet next])
        {
            BOOL ret = [_db executeUpdateWithFormat:@"INSERT INTO t_matching_rules(rule_name,rule_content) VALUES(%@,%@)", _ruleNameTextField.text, _ruleContentTextView.text];
            
            if (!ret)
            {
                [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"添加数据失败，请联系客服" confirm:@"确定"];
            }
            else
            {
                [self.tableView endEditing:YES];
                _didAddedRuleBlock ? _didAddedRuleBlock() : nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"该规则已存在，请重新输入" confirm:@"确定"];
        }
    }
}


@end
