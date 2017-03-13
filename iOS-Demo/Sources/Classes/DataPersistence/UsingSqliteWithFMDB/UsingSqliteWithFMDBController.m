//
//  UsingSqliteWithFMDBController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "UsingSqliteWithFMDBController.h"
#import "FMDB.h"
#import "DP_USWF_UserInfoModel.h"
#import "DP_USWF_AddUserInfoController.h"
#import "DP_USWF_UserInfoItemCell.h"
#import "BaseTextField.h"

#define kUserInfoItemCellIdentifier @"DP_USWF_UserInfoItemCell"

@interface UsingSqliteWithFMDBController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation UsingSqliteWithFMDBController
{
    __weak IBOutlet BaseTextField *_searchTextField;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet NSLayoutConstraint *_searchInputHeightConstraint;
    
    UILabel *_sectionTitleLabel;
    
    FMDatabase *_db;
    NSMutableArray *_sectionTitles;
    NSMutableArray *_sectionUserInfos;
    
    float _lastContentOffset;
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
}

- (void)initializeUIComponents
{
    _sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66.0f, 66.0f)];
    _sectionTitleLabel.center = CGPointMake(kDeviceWidth / 2.0f, kDeviceHeight / 2.0f);
    _sectionTitleLabel.textAlignment = NSTextAlignmentCenter;
    _sectionTitleLabel.font = [UIFont systemFontOfSize:22];
    _sectionTitleLabel.alpha = 0;
    _sectionTitleLabel.layer.cornerRadius = 33.0f;
    _sectionTitleLabel.layer.masksToBounds = YES;
    _sectionTitleLabel.backgroundColor = [UIColor blueColor];
    _sectionTitleLabel.textColor = [UIColor whiteColor];
    _sectionTitleLabel.text = @"A";
    [kWindow addSubview:_sectionTitleLabel];
    
    kRegisterCellForTableView(_tableView, @"DP_USWF_UserInfoItemCell", kUserInfoItemCellIdentifier);
    kRemoveBottomLinesForTableView(_tableView);
    
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    _searchTextField.maxLengthOfText = 9;
    [_searchTextField setTextChangeBlock:^{
       
        [self  fetchDataFromDatabase];
        [_tableView reloadData];
    }];
    
    [self  fetchDataFromDatabase];
    [_tableView reloadData];
}

- (void)configureDatabase
{
    NSString *sqliteFilePath = [kDocumentsDirectoryPath stringByAppendingPathComponent:@"DP_USWF_Database.sqlite"];
    _db = [FMDatabase databaseWithPath:sqliteFilePath];
    
    if ([_db open])
    {
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_user_info (nickname text NOT NULL, realname text NOT NULL, realname_first_pin_yin text NOT NULL, telephone text PRIMARY KEY, age integer NOT NULL, sex integer NOT NULL);"];
        
        if (!result)
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"数据库初始化失败，请联系客服" confirm:@"确定"];
        }
    }
}

- (void) fetchDataFromDatabase
{
    
    NSString *sqlString;
    if (kIsNotNullOrEmptyWithString(_searchTextField.text))
    {
        sqlString = [NSString stringWithFormat:@"SELECT * FROM t_user_info WHERE realname LIKE '%%%@%%' ORDER BY realname_first_pin_yin", _searchTextField.text];
    }
    else
    {
        sqlString = @"SELECT * FROM t_user_info ORDER BY realname_first_pin_yin";
    }
    
    FMResultSet *resultSet = [_db executeQuery:sqlString];
    
    
    _sectionTitles = [NSMutableArray new];
    _sectionUserInfos = [NSMutableArray new];
    NSMutableArray *theMutArr = [NSMutableArray new];
    DP_USWF_UserInfoModel *userInfoModel;
    while ([resultSet next])
    {
        userInfoModel  = [DP_USWF_UserInfoModel new];
        userInfoModel.nickname = resultSet[@"nickname"];
        userInfoModel.realname = resultSet[@"realname"];
        userInfoModel.telephone = resultSet[@"telephone"];
        userInfoModel.age = (NSInteger)resultSet[@"age"];
        userInfoModel.sex = (NSInteger)resultSet[@"sex"];
        userInfoModel.realnameFirstPinYin = resultSet[@"realname_first_pin_yin"];
        
        if (![_sectionTitles containsObject:userInfoModel.realnameFirstPinYin])
        {
            [_sectionTitles addObject:userInfoModel.realnameFirstPinYin];
            
            if (theMutArr.count > 0)
            {
                [_sectionUserInfos addObject:theMutArr];
                theMutArr = [NSMutableArray new];
            }
        }
        
        [theMutArr addObject:userInfoModel];
    }
    
    if (theMutArr.count > 0)
    {
        [_sectionUserInfos addObject:theMutArr];
    }
}


#pragma mark -- UITableView Database

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sectionUserInfos[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DP_USWF_UserInfoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoItemCellIdentifier];
    DP_USWF_UserInfoModel *userInfoModel = _sectionUserInfos[indexPath.section][indexPath.row];
    cell.realnameLabel.text = userInfoModel.realname;
    cell.telephoneLabel.text = userInfoModel.telephone;
    
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _sectionTitles;
}

#pragma mark -- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    _sectionTitleLabel.text = _sectionTitles[index];
    
    _sectionTitleLabel.alpha = 0.56f;
    [UIView animateWithDuration:0.56f animations:^{
        
        _sectionTitleLabel.alpha = 0;
    }];
    
    return index;
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
    DP_USWF_UserInfoModel *userInfoModel = _sectionUserInfos[indexPath.section][indexPath.row];
    
    BOOL deleteResult = [_db executeUpdateWithFormat:@"DELETE FROM t_user_info WHERE telephone=%@", userInfoModel.telephone];
    
    if (deleteResult)
    {
        [_sectionUserInfos[indexPath.section] removeObjectAtIndex:indexPath.row];

        if ([_sectionUserInfos[indexPath.section] count] == 0)
        {
            [_sectionTitles removeObjectAtIndex:indexPath.section];
            [_sectionUserInfos removeObjectAtIndex:indexPath.section];
            
            [tableView reloadData];
        }
        else
        {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastContentOffset = scrollView.contentOffset.y;
    [_searchTextField resignFirstResponder];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (_lastContentOffset < scrollView.contentOffset.y)
    {
        _searchInputHeightConstraint.constant = 0;
    }
    else
    {
        _searchInputHeightConstraint.constant = 46;
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_searchTextField resignFirstResponder];
    
    if ([segue.identifier isEqualToString:@"DP_USWF_AddUserInfoController"])
    {
        DP_USWF_AddUserInfoController *controller = segue.destinationViewController;
        [controller setDidAddedUserInfoBlock:^{
            
            [self  fetchDataFromDatabase];
            [_tableView reloadData];
            
        }];
        controller.db = _db;
    }
}

#pragma mark -- dealloc

- (void)dealloc
{
    [_db close];
}

@end
