//
//  UsingSqliteWithCoreDataController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "UsingSqliteWithCoreDataController.h"
#import "BaseTextField.h"
#import "DP_USWCD_UserInfoModel+CoreDataClass.h"
#import "DP_USWCD_UserInfoItemCell.h"
#import "DP_USWCD_AddUserInfoController.h"

#define kUserInfoItemCellIdentifier @"DP_USWCD_UserInfoItemCell"

@interface UsingSqliteWithCoreDataController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation UsingSqliteWithCoreDataController
{
    __weak IBOutlet BaseTextField *_searchTextField;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet NSLayoutConstraint *_searchInputHeightConstraint;
    
    NSManagedObjectContext *_context;
    
    UILabel *_sectionTitleLabel;
    
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
    [self fetchDataFromDatabase];
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
    
    kRegisterCellForTableView(_tableView, @"DP_USWCD_UserInfoItemCell", kUserInfoItemCellIdentifier);
    kRemoveBottomLinesForTableView(_tableView);
    
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    _searchTextField.maxLengthOfText = 9;
    [_searchTextField setTextChangeBlock:^{
        
        [self fetchDataFromDatabase];
        [_tableView reloadData];
    }];
    
    [self fetchDataFromDatabase];
    [_tableView reloadData];
}

- (void)configureDatabase
{
    // 创建上下文对象，并发队列设置为主队列
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // 创建托管对象模型，并使用Company.momd路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"DP_USWCD_Database" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    
    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"DP_USWCD_Database"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
    
    // 上下文对象设置属性为持久化存储器
    _context.persistentStoreCoordinator = coordinator;
}

- (void)fetchDataFromDatabase
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DP_USWCD_UserInfoModel"];
    
    if (kIsNotNullOrEmptyWithString(_searchTextField.text))
    {
        NSPredicate * predicate= [NSPredicate predicateWithFormat:@"SELF.realname CONTAINS %@", _searchTextField.text];
        request.predicate = predicate;
    }
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"realnameFirstPinYin" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error = nil;
    NSArray *userInfos = [_context executeFetchRequest:request error:&error];
    
    if (error)
    {
        [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"数据库初始化失败，请联系客服" confirm:@"确定"];
        return ;
    }
    
    _sectionTitles = [NSMutableArray new];
    _sectionUserInfos = [NSMutableArray new];
    NSMutableArray *theMutArr = [NSMutableArray new];
    for (DP_USWCD_UserInfoModel *userInfoModel in userInfos)
    {
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
    DP_USWCD_UserInfoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoItemCellIdentifier];
    DP_USWCD_UserInfoModel *userInfoModel = _sectionUserInfos[indexPath.section][indexPath.row];
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
    DP_USWCD_UserInfoModel *userInfoModel = _sectionUserInfos[indexPath.section][indexPath.row];
    
    [_context deleteObject:userInfoModel];
    
    NSError *error;
    if ([_context hasChanges])
    {
        [_context save:&error];
    }
    
    if (!error)
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
    
    if ([segue.identifier isEqualToString:@"DP_USWCD_AddUserInfoController"])
    {
        DP_USWCD_AddUserInfoController *controller = segue.destinationViewController;
        [controller setDidAddedUserInfoBlock:^{
            
            [self fetchDataFromDatabase];
            [_tableView reloadData];
        }];
        controller.context = _context;
    }
}

@end
