//
//  ObjectSerializationController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ObjectSerializationController.h"
#import "DP_OS_UserInfoModel.h"

#define kDataPersistenceFileDirectory ([kDocumentsDirectoryPath stringByAppendingPathComponent:@"DataPersistence/ObjectSerialization"])
#define kDataPersistenceUserInfoFilePath ([kDataPersistenceFileDirectory stringByAppendingPathComponent:@"UserInfo.plist"])

@interface ObjectSerializationController ()

@end

@implementation ObjectSerializationController
{
    __weak IBOutlet UILabel *_nicknameLabel;
    __weak IBOutlet UILabel *_realnameLabel;
    __weak IBOutlet UILabel *_telephoneLabel;
    __weak IBOutlet UILabel *_ageLabel;
    __weak IBOutlet UILabel *_sexLabel;
    
    BOOL _isEditing;
    
    NSString *_nickname;
    NSString *_realname;
    NSString *_telephone;
    NSInteger _age;
    NSInteger _sex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
    
}

- (void)initializeBaseData
{
//    NSDictionary *userInfoDic = [NSDictionary dictionaryWithContentsOfFile:kDataPersistenceUserInfoFilePath];
//    
//    _nickname = userInfoDic[@"nickname"];
//    if (kIsNullOrEmptyWithString(_nickname))
//    {
//        _nickname = @"Lenvit";
//    }
//    
//    _realname = userInfoDic[@"realname"];
//    if (kIsNullOrEmptyWithString(_realname))
//    {
//        _realname = @"姚朝文";
//    }
//    
//    _telephone = userInfoDic[@"telephone"];
//    if (kIsNullOrEmptyWithString(_telephone))
//    {
//        _telephone = @"15994671505";
//    }
//    
//    _age = [userInfoDic[@"age"] integerValue];
//    if (_age == 0)
//    {
//        _age = 28;
//    }
//    
//    _sex = [userInfoDic[@"sex"] integerValue];
//    
//    _nicknameLabel.text = _nickname;
//    _realnameLabel.text = _realname;
//    _telephoneLabel.text = _telephone;
//    _ageLabel.text = [NSString stringWithFormat:@"%ld", (long)_age];
//    
//    if (_sex == 0)
//    {
//        _sexLabel.text = @"女";
//    }
//    else
//    {
//        _sexLabel.text = @"男";
//    }
    
    
    
    
    
    
    DP_OS_UserInfoModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kDataPersistenceUserInfoFilePath];
    
    _nickname = userInfoModel.nickname;
    if (kIsNullOrEmptyWithString(_nickname))
    {
        _nickname = @"Lenvit";
    }
    
    _realname = userInfoModel.realname;
    if (kIsNullOrEmptyWithString(_realname))
    {
        _realname = @"姚朝文";
    }
    
    _telephone = userInfoModel.telephone;
    if (kIsNullOrEmptyWithString(_telephone))
    {
        _telephone = @"15994671505";
    }
    
    _age = userInfoModel.age;
    if (_age == 0)
    {
        _age = 28;
    }
    
    _sex = userInfoModel.sex;
    
    
    _nicknameLabel.text = _nickname;
    _realnameLabel.text = _realname;
    _telephoneLabel.text = _telephone;
    _ageLabel.text = [NSString stringWithFormat:@"%ld", (long)_age];
    
    if (_sex == 0)
    {
        _sexLabel.text = @"女";
    }
    else
    {
        _sexLabel.text = @"男";
    }
    
    
}

- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
    
}


#pragma mark -- UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            [CustomPopupView alertViewWithTitle:@"修改昵称" message:nil placeholder:@"请输入昵称" input:^(NSString *text) {
                
                if (kIsNotNullOrEmptyWithString(text))
                {
                    _nickname = text;
                    _nicknameLabel.text = text;
                }
            }];
            
            break;
        }
            
        case 1:
        {
            [CustomPopupView alertViewWithTitle:@"修改姓名" message:nil placeholder:@"请输入姓名" input:^(NSString *text) {
                
                if (kIsNotNullOrEmptyWithString(text))
                {
                    _realname = text;
                    _realnameLabel.text = text;
                }
            }];
            
            break;
        }
            
        case 2:
        {
            [CustomPopupView alertViewWithTitle:@"修改电话号码" message:nil placeholder:@"请输入电话号码" input:^(NSString *text) {
                
                if (kIsNotNullOrEmptyWithString(text))
                {
                    _telephone = text;
                    _telephoneLabel.text = text;
                }
            }];
            
            break;
        }
            
        case 3:
        {
            [CustomPopupView alertViewWithTitle:@"修改年龄" message:nil placeholder:@"请输入年龄" input:^(NSString *text) {
                
                if (kIsNotNullOrEmptyWithString(text))
                {
                    _age = [text integerValue];
                    _ageLabel.text = text;
                }
            }];
            
            break;
        }
            
        case 4:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _sex = 1;
                _sexLabel.text = @"男";
            }];
            UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _sex = 0;
                _sexLabel.text = @"女";
            }];
            [alertController addAction:maleAction];
            [alertController addAction:femaleAction];
            
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
            
        default:
            break;
    }
}


- (IBAction)editAction:(UIBarButtonItem *)sender
{
    _isEditing = !_isEditing;
    _isEditing ? (sender.title = @"完成") : (sender.title = @"编辑") ;
    
    
    [self.tableView setAllowsSelection:_isEditing];
    
    UITableViewCell *theCell;
    for (int i = 0; i < 5; i ++)
    {
        theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        _isEditing ? (theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator) : (theCell.accessoryType = UITableViewCellAccessoryNone);
    }
    
    if (!_isEditing)
    {
        //创建目录
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL existed = [fileManager fileExistsAtPath:kDataPersistenceFileDirectory isDirectory:&isDir];
        if (!(isDir == YES && existed == YES))
        {
            [fileManager createDirectoryAtPath:kDataPersistenceFileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        //创建文件
        if (![fileManager fileExistsAtPath:kDataPersistenceUserInfoFilePath])
        {
            [fileManager createFileAtPath:kDataPersistenceUserInfoFilePath contents:nil attributes:nil];
        }
        
//        NSDictionary *userInfoDic = @{@"nickname" : _nickname, @"realname" : _realname, @"telephone" : _telephone, @"age" : @(_age), @"sex" : @(_sex)};
//        
//        //序列化对象
//        if (![userInfoDic writeToFile:kDataPersistenceUserInfoFilePath atomically:YES])
//        {
//            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"保存失败，请重新尝试" confirm:@"确定"];
//            return ;
//        }
        
        
        DP_OS_UserInfoModel *userInfoModel = [DP_OS_UserInfoModel new];
        userInfoModel.nickname = _nickname;
        userInfoModel.realname = _realname;
        userInfoModel.telephone = _telephone;
        userInfoModel.age = _age;
        userInfoModel.sex = _sex;
        if (![NSKeyedArchiver archiveRootObject:userInfoModel toFile:kDataPersistenceUserInfoFilePath])
        {
            [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"保存失败，请重新尝试" confirm:@"确定"];
            return ;
        }
    }
}

@end







