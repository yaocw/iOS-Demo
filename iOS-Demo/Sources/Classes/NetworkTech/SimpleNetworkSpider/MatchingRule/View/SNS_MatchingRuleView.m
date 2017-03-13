//
//  SNS_MatchingRuleView.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNS_MatchingRuleView.h"
#import "SNS_MatchingRuleCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SNS_MatchingRuleModel.h"
#import "UIView+Extend.h"
#import "SNSAddMatchingRuleController.h"

#define kMatchingRuleCellIdentifier @"SNS_MatchingRuleCell"

@interface SNS_MatchingRuleView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SNS_MatchingRuleView
{
    BLKBlock _didChangedHeightBlock;
    
    UITableView *_tableView;
    NSMutableArray *_matchingRuleModelArr;
    
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
    _matchingRuleModelArr = [NSMutableArray new];
    SNS_MatchingRuleModel *lastModel = [SNS_MatchingRuleModel new];
    lastModel.matchingRuleName = @"添加匹配规则";
    lastModel.isLastModel = YES;
    [_matchingRuleModelArr addObject:lastModel];
}

- (void)initializeUIComponents
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.editing = YES;
    _tableView.allowsSelectionDuringEditing = YES;
    [self addSubview:_tableView];
    
    kRegisterCellForTableView(_tableView, @"SNS_MatchingRuleCell", kMatchingRuleCellIdentifier);
    kRemoveBottomLinesForTableView(_tableView);
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (NSArray *)matchingRules
{
    NSMutableArray *theMutArr = [NSMutableArray arrayWithArray:_matchingRuleModelArr];
    [theMutArr removeLastObject];
    
    return [theMutArr copy];
}


#pragma mark -- UITableView Database

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _matchingRuleModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNS_MatchingRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMatchingRuleCellIdentifier];
    SNS_MatchingRuleModel *model = _matchingRuleModelArr[indexPath.row];
    
    
    if (model.isLastModel)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell setEditing:NO animated:NO];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setEditing:YES animated:YES];
    }
    
    
    [cell setModel:model];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (_matchingRuleModelArr.count - 1))
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
    [_matchingRuleModelArr removeObjectAtIndex:indexPath.row];
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
    height = [tableView fd_heightForCellWithIdentifier:kMatchingRuleCellIdentifier cacheByIndexPath:indexPath configuration:^(SNS_MatchingRuleCell * cell) {
        
        [cell setModel:_matchingRuleModelArr[indexPath.row]];
    }];
    
    _tableViewHeight += height;
    
    if (indexPath.row == (_matchingRuleModelArr.count - 1))
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
    
    if (indexPath.row == (_matchingRuleModelArr.count - 1))
    {
        SNSAddMatchingRuleController *controller = kInstanceFromStoryboard(@"SNSAddMatchingRuleController", @"SNSAddMatchingRuleController");
        [controller setDidSelectedRuleBlock:^(SNS_MatchingRuleModel *obj) {
            
            if (obj)
            {
                BOOL isExistTheSameRule = NO;
                for (SNS_MatchingRuleModel *theModel in _matchingRuleModelArr)
                {
                    if ([theModel.matchingRuleName isEqualToString:obj.matchingRuleName])
                    {
                        isExistTheSameRule = YES;
                    }
                }
                
                if (!isExistTheSameRule)
                {
                    [_matchingRuleModelArr insertObject:obj atIndex:(_matchingRuleModelArr.count - 1)];
                    [_tableView reloadData];
                }
            }
        }];
        
        [self.currentNavigationController pushViewController:controller animated:YES];
    }
}

@end
