//
//  ChooseMusicalScaleController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/6.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ChooseMusicalScaleController.h"
#import "MusicalScaleItemHeaderView.h"
#import "MusicalScaleItemCell.h"
#import "SolfeggioMacros.h"

static NSString * const kMusicalScaleItemCellIdentifier = @"MusicalScaleItemCell";
static NSString * const kMusicalScaleItemHeaderViewIdentifier = @"MusicalScaleItemHeaderView";

@interface ChooseMusicalScaleController ()

@end

@implementation ChooseMusicalScaleController
{
    BLKBlock _didChangedSoundsBlock;
    
    NSDictionary *_pianoSoundsDic;
    
    NSArray *_sectionTitles;
    NSMutableDictionary *_sectionCollapseFlag;
    NSMutableDictionary *_sectionChoosedSounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    _pianoSoundsDic = kLoadDictionaryFromPlistFile(@"SingleSoundExercise");
    
    _sectionChoosedSounds = [NSMutableDictionary dictionaryWithContentsOfFile:kSectionChoosedSoundsFilePath];
    if (_sectionChoosedSounds == nil)
    {
        _sectionChoosedSounds = [NSMutableDictionary new];
    }
    
    _sectionCollapseFlag = [NSMutableDictionary new];
    _sectionTitles = [_pianoSoundsDic allKeys];
    for (NSString *title in _sectionTitles)
    {
        [_sectionCollapseFlag setObject:@"NO" forKey:title];
    }
}

- (void)initializeUIComponents
{
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicalScaleItemHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kMusicalScaleItemHeaderViewIdentifier];
    
    kRegisterNibCell(@"MusicalScaleItemCell", kMusicalScaleItemCellIdentifier);
    self.tableView.tableFooterView = [UIView new];
}

- (void)setDidChangedSoundsBlock:(BLKBlock)aBlock
{
    _didChangedSoundsBlock = aBlock;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([((NSString *)_sectionCollapseFlag[_sectionTitles[section]]) isEqualToString:@"YES"])
    {
        NSArray *sectionItems = _pianoSoundsDic[_sectionTitles[section]];
        return sectionItems.count + 1;
    }
    else
    {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MusicalScaleItemHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMusicalScaleItemHeaderViewIdentifier];
    headerView.titleLabel.text = _sectionTitles[section];
    [headerView setCollapseFlag:_sectionCollapseFlag[_sectionTitles[section]]];
    
    NSArray *theChoosedSounds = _sectionChoosedSounds[_sectionTitles[section]];
    if (theChoosedSounds.count > 0)
    {
        NSMutableString *choosedSoundTitles = [NSMutableString new];
        for (NSString *theStr in theChoosedSounds)
        {
            [choosedSoundTitles appendString:theStr];
            
            if (![theStr isEqualToString:[theChoosedSounds lastObject]])
            {
                [choosedSoundTitles appendString:@"、"];
            }
        }
        headerView.choosedMusicalScaleLabel.text = [NSString stringWithFormat:@"已选：%@", [choosedSoundTitles stringByReplacingOccurrencesOfString:@"[0-9a-z].|-" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, choosedSoundTitles.length)]];
    }
    else
    {
        headerView.choosedMusicalScaleLabel.text = @"已选：无";
    }
    
    [headerView setDidClickHeaderViewBlock:^{
        if ([_sectionCollapseFlag[_sectionTitles[section]] isEqualToString:@"NO"])
        {
            _sectionCollapseFlag[_sectionTitles[section]] = @"YES";
        }
        else
        {
            _sectionCollapseFlag[_sectionTitles[section]] = @"NO";
        }
        
        [tableView reloadData];
    }];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        MusicalScaleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicalScaleItemCellIdentifier];
        NSArray *sectionItems = _pianoSoundsDic[_sectionTitles[indexPath.section]];
        NSArray *theChoosedSounds = _sectionChoosedSounds[_sectionTitles[indexPath.section]];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (sectionItems.count == theChoosedSounds.count)
        {
            cell.titleLabel.text = @"全部取消";
        }
        else
        {
            cell.titleLabel.text = @"全部选择";
        }
        
        return cell;
    }
    else
    {
        MusicalScaleItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kMusicalScaleItemCellIdentifier];
        NSArray *sectionItems = _pianoSoundsDic[_sectionTitles[indexPath.section]];
        cell.titleLabel.text = [(NSString *)sectionItems[indexPath.row - 1] stringByReplacingOccurrencesOfString:@"[0-9a-z].|-" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, ((NSString *)sectionItems[indexPath.row - 1]).length)];
        
        NSArray *theChoosedSounds = _sectionChoosedSounds[_sectionTitles[indexPath.section]];
        if ([theChoosedSounds containsObject:sectionItems[indexPath.row - 1]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
}



#pragma mark - Table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 62.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        MusicalScaleItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.titleLabel.text isEqualToString:@"全部选择"])
        {
            cell.titleLabel.text = @"全部取消";
            
            NSArray *sectionItems = _pianoSoundsDic[_sectionTitles[indexPath.section]];
            _sectionChoosedSounds[_sectionTitles[indexPath.section]] = sectionItems;
        }
        else
        {
            cell.titleLabel.text = @"全部选择";
            _sectionChoosedSounds[_sectionTitles[indexPath.section]] = @[];
        }
    }
    else
    {
        NSArray *sectionItems = _pianoSoundsDic[_sectionTitles[indexPath.section]];
        NSArray *theChoosedSounds = _sectionChoosedSounds[_sectionTitles[indexPath.section]];
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:theChoosedSounds];
        if ([tempArr containsObject:sectionItems[indexPath.row - 1]])
        {
            [tempArr removeObject:sectionItems[indexPath.row - 1]];
        }
        else
        {
            [tempArr addObject:sectionItems[indexPath.row - 1]];
        }
        _sectionChoosedSounds[_sectionTitles[indexPath.section]] = tempArr;
    }
    
    [tableView reloadData];
}

- (IBAction)ensureAction:(id)sender
{
    //创建目录
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:kSolfeggioFileDirectory isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:kSolfeggioFileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //创建文件
    if (![fileManager fileExistsAtPath:kSectionChoosedSoundsFilePath])
    {
        [fileManager createFileAtPath:kSectionChoosedSoundsFilePath contents:nil attributes:nil];
    }
    
    //序列化对象
    if ([_sectionChoosedSounds writeToFile:kSectionChoosedSoundsFilePath atomically:YES])
    {
        _didChangedSoundsBlock ? _didChangedSoundsBlock() : nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"保存失败，请重新尝试" confirm:@"确定"];
    }
}



@end
