//
//  SNSAddSelfDefineReplacingRuleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNSAddSelfDefineReplacingRuleController.h"
#import "BaseTextView.h"
#import "FMDB.h"
#import "Helper.h"

@interface SNSAddSelfDefineReplacingRuleController ()

@end

@implementation SNSAddSelfDefineReplacingRuleController
{
    __weak IBOutlet BaseTextView *_beforeReplaceContentTextView;
    __weak IBOutlet BaseTextView *_afterReplaceContentTextView;
    
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
    
    _beforeReplaceContentTextView.placeHolderLab.text = @"请输入你替换的内容";
    _afterReplaceContentTextView.placeHolderLab.text = @"请输入替换后的内容";
    
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
    
    
    BOOL validateResult = [Helper validateDataForNotNullValueWithInputObjects:@[_beforeReplaceContentTextView] prompts:@[@"要替换的内容不能为空"]];
    
    if (validateResult)
    {
        FMResultSet *resultSet = [_db executeQueryWithFormat:@"SELECT * FROM t_replacing_rules WHERE before_replace_content=%@ AND after_replace_content=%@", _beforeReplaceContentTextView.text, _afterReplaceContentTextView.text];
        if (![resultSet next])
        {
            BOOL ret = [_db executeUpdateWithFormat:@"INSERT INTO t_replacing_rules(before_replace_content,after_replace_content) VALUES(%@,%@)", _beforeReplaceContentTextView.text, _afterReplaceContentTextView.text];
            
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
