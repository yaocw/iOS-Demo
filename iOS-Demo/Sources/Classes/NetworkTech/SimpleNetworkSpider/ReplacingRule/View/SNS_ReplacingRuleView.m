//
//  SNS_ReplacingRuleView.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNS_ReplacingRuleView.h"
#import "SNS_ReplacingRuleCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SNS_ReplacingRuleModel.h"
#import "SNSAddReplacingRuleController.h"

#define kReplacingRuleCellIdentifier @"SNS_ReplacingRuleCell"

@interface SNS_ReplacingRuleView ()  <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SNS_ReplacingRuleView
{
    BLKBlock _didChangedHeightBlock;
    
    UITableView *_tableView;
    NSMutableArray *_replacingRuleModelArr;
    
    CGFloat _tableViewHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)setDidChangedHeightBlock:(BLKBlock)aBlock
{
    _didChangedHeightBlock = aBlock;
}

- (void)initializeBaseData
{
    _replacingRuleModelArr = [NSMutableArray new];
    SNS_ReplacingRuleModel *lastModel = [SNS_ReplacingRuleModel new];
    lastModel.beforeReplaceContent = @"添加替换规则";
    lastModel.isLastModel = YES;
    [_replacingRuleModelArr addObject:lastModel];
}

- (void)initializeUIComponents
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.editing = YES;
    _tableView.allowsSelectionDuringEditing = YES;
    [self addSubview:_tableView];
    
    kRegisterCellForTableView(_tableView, @"SNS_ReplacingRuleCell", kReplacingRuleCellIdentifier);
    kRemoveBottomLinesForTableView(_tableView);
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (NSArray *)replacingRules
{
    NSMutableArray *theMutArr = [NSMutableArray arrayWithArray:_replacingRuleModelArr];
    [theMutArr removeLastObject];
    
    return [theMutArr copy];
}

#pragma mark -- UITableView Database

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _replacingRuleModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNS_ReplacingRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:kReplacingRuleCellIdentifier];
    SNS_ReplacingRuleModel *model = _replacingRuleModelArr[indexPath.row];
    
    if (model.isLastModel)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    [cell setModel:model];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (_replacingRuleModelArr.count - 1))
    {
        return NO;
    }
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_replacingRuleModelArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark -- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        _tableViewHeight = 0;
    }
    
    CGFloat height = 0;
    height = [tableView fd_heightForCellWithIdentifier:kReplacingRuleCellIdentifier cacheByIndexPath:indexPath configuration:^(SNS_ReplacingRuleCell * cell) {
        
        [cell setModel:_replacingRuleModelArr[indexPath.row]];
    }];
    
    _tableViewHeight += height;
    
    if (indexPath.row == (_replacingRuleModelArr.count - 1))
    {
        CGRect theFrame = _tableView.frame;
        theFrame.size.height = _tableViewHeight;
        _tableView.frame = theFrame;
        theFrame.origin.y = 32.0f;
        self.frame = theFrame;
        
        _didChangedHeightBlock ? _didChangedHeightBlock() : nil;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == (_replacingRuleModelArr.count - 1))
    {
        SNSAddReplacingRuleController *controller = kInstanceFromStoryboard(@"SNSAddReplacingRuleController", @"SNSAddReplacingRuleController");
        [controller setDidSelectedRuleBlock:^(SNS_ReplacingRuleModel *obj) {
            
            if (obj)
            {
                BOOL isExistTheSameRule = NO;
                for (SNS_ReplacingRuleModel *theModel in _replacingRuleModelArr)
                {
                    if ([theModel.beforeReplaceContent isEqualToString:obj.beforeReplaceContent]
                        && [theModel.afterReplaceContent isEqualToString:obj.afterReplaceContent])
                    {
                        isExistTheSameRule = YES;
                    }
                }
                
                if (!isExistTheSameRule)
                {
                    [_replacingRuleModelArr insertObject:obj atIndex:(_replacingRuleModelArr.count - 1)];
                    [_tableView reloadData];
                }
            }
        }];
        
        [self.currentNavigationController pushViewController:controller animated:YES];
    }
}

@end
