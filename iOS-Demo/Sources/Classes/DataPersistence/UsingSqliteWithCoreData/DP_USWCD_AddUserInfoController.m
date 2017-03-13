//
//  DP_USWCD_AddUserInfoController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "DP_USWCD_AddUserInfoController.h"
#import "DP_USWCD_UserInfoModel+CoreDataClass.h"
#import "FMDB.h"

@interface DP_USWCD_AddUserInfoController ()

@end

@implementation DP_USWCD_AddUserInfoController
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
    if (!_context)
    {
        [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"数据库初始化失败，请联系客服" confirm:@"确定"];
        return ;
    }
    
    
    BOOL validateResult = [Helper validateDataForNotNullValueWithInputObjects:@[_nicknameTextField, _realnameTextField, _telephoneTextField, _ageTextField] prompts:@[@"昵称", @"姓名", @"手机号码", @"年龄"]];
    
    if (validateResult)
    {
        
        DP_USWCD_UserInfoModel *userInfoModel = [NSEntityDescription insertNewObjectForEntityForName:@"DP_USWCD_UserInfoModel" inManagedObjectContext:_context];
        userInfoModel.nickname = _nicknameTextField.text;
        userInfoModel.realname = _realnameTextField.text;
        userInfoModel.telephone = _telephoneTextField.text;
        userInfoModel.age = [_ageTextField.text integerValue];
        userInfoModel.sex = _sexSegmentedControl.selectedSegmentIndex;
        
        NSMutableString *realnamePinYin = [NSMutableString stringWithString:userInfoModel.realname];
        CFStringTransform((CFMutableStringRef)realnamePinYin, NULL, kCFStringTransformToLatin, false);
        CFStringTransform((CFMutableStringRef)realnamePinYin, NULL, kCFStringTransformStripDiacritics, false);
        userInfoModel.realnameFirstPinYin = [[realnamePinYin substringToIndex:1] uppercaseString];
        
        
        NSError *error = nil;
        if (_context.hasChanges)
        {
            [_context save:&error];
        }
        
        if (error)
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"添加数据失败，请联系客服" confirm:@"确定"];
            return ;
        }
        else
        {
            [self.tableView endEditing:YES];
            _didAddedUserInfoBlock ? _didAddedUserInfoBlock() : nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
