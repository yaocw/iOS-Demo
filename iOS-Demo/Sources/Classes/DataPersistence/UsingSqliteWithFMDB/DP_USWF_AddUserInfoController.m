//
//  DP_USWF_AddUserInfoController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "DP_USWF_AddUserInfoController.h"
#import "DP_USWF_UserInfoModel.h"
#import "FMDB.h"

@interface DP_USWF_AddUserInfoController ()

@end

@implementation DP_USWF_AddUserInfoController
{
    
    __weak IBOutlet UITextField *_nicknameTextField;
    __weak IBOutlet UITextField *_realnameTextField;
    __weak IBOutlet UITextField *_telephoneTextField;
    __weak IBOutlet UITextField *_ageTextField;
    __weak IBOutlet UISegmentedControl *_sexSegmentedControl;
    
    
    BLKBlock _didAddedUserInfoBlock;
}

- (void)setDidAddedUserInfoBlock:(BLKBlock)aBlock
{
    _didAddedUserInfoBlock = aBlock;
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
    
    
}

#pragma mark -- UITableView ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}


#pragma mark -- Actions

- (IBAction)saveAction:(id)sender
{
    if (!_db)
    {
        [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"数据库初始化失败，请联系客服" confirm:@"确定"];
        return ;
    }
    
    
    BOOL validateResult = [Helper validateDataForNotNullValueWithInputObjects:@[_nicknameTextField, _realnameTextField, _telephoneTextField, _ageTextField] prompts:@[@"昵称", @"姓名", @"手机号码", @"年龄"]];
    
    if (validateResult)
    {
        FMResultSet *resultSet = [_db executeQueryWithFormat:@"SELECT * FROM t_user_info WHERE telephone=%@", _telephoneTextField.text];
        if (![resultSet next])
        {
            DP_USWF_UserInfoModel *userInfoModel = [DP_USWF_UserInfoModel new];
            userInfoModel.nickname = _nicknameTextField.text;
            userInfoModel.realname = _realnameTextField.text;
            userInfoModel.telephone = _telephoneTextField.text;
            userInfoModel.age = [_ageTextField.text integerValue];
            userInfoModel.sex = _sexSegmentedControl.selectedSegmentIndex;
            
            NSMutableString *realnamePinYin = [NSMutableString stringWithString:userInfoModel.realname];
            CFStringTransform((CFMutableStringRef)realnamePinYin, NULL, kCFStringTransformToLatin, false);
            CFStringTransform((CFMutableStringRef)realnamePinYin, NULL, kCFStringTransformStripDiacritics, false);
            userInfoModel.realnameFirstPinYin = [[realnamePinYin substringToIndex:1] uppercaseString];
            
            
            BOOL ret = [_db executeUpdateWithFormat:@"INSERT INTO t_user_info(nickname,realname,realname_first_pin_yin,telephone,age,sex) VALUES(%@,%@,%@,%@,%ld,%ld)", userInfoModel.nickname, userInfoModel.realname,userInfoModel.realnameFirstPinYin, userInfoModel.telephone, (long)userInfoModel.age, (long)userInfoModel.sex];
            
            if (!ret)
            {
                [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"添加数据失败，请联系客服" confirm:@"确定"];
            }
            else
            {
                [self.tableView endEditing:YES];
                _didAddedUserInfoBlock ? _didAddedUserInfoBlock() : nil;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"该用户已存在，请重新输入" confirm:@"确定"];
        }
    }
}

@end
