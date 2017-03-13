//
//  UsingUserDefaultsController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "UsingUserDefaultsController.h"

@interface UsingUserDefaultsController ()

@end

@implementation UsingUserDefaultsController
{
    __weak IBOutlet UILabel *_nicknameLabel;
    __weak IBOutlet UILabel *_realnameLabel;
    __weak IBOutlet UILabel *_telephoneLabel;
    
    BOOL _isEditing;
    
    NSString *_nickname;
    NSString *_realname;
    NSString *_telephone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
    
}

- (void)initializeBaseData
{
    _nickname = kFetchFromUserDefaults(@"DP_UUD_nickname");
    if (kIsNullOrEmptyWithString(_nickname))
    {
        _nickname = @"Lenvit";
        kSaveToUserDefaults(@"DP_UUD_nickname", _nickname);
    }
    
    _realname = kFetchFromUserDefaults(@"DP_UUD_realname");
    if (kIsNullOrEmptyWithString(_realname))
    {
        _realname = @"姚朝文";
        kSaveToUserDefaults(@"DP_UUD_realkname", _realname);
    }
    
    _telephone = kFetchFromUserDefaults(@"DP_UUD_telephone");
    if (kIsNullOrEmptyWithString(_telephone))
    {
        _telephone = @"15994671505";
        kSaveToUserDefaults(@"DP_UUD_telephone", _telephone);
    }
    
    _nicknameLabel.text = _nickname;
    _realnameLabel.text = _realname;
    _telephoneLabel.text = _telephone;
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
    for (int i = 0; i < 3; i ++)
    {
        theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        _isEditing ? (theCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator) : (theCell.accessoryType = UITableViewCellAccessoryNone);
    }
    
    if (!_isEditing)
    {
        kSaveToUserDefaults(@"DP_UUD_nickname", _nickname);
        kSaveToUserDefaults(@"DP_UUD_realname", _realname);
        kSaveToUserDefaults(@"DP_UUD_telephone", _telephone);
        kSynchronizeForUserDefaults;
        
    }
}


@end
