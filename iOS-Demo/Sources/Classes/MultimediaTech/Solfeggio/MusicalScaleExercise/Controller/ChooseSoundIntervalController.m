//
//  ChooseSoundIntervalController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/10.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ChooseSoundIntervalController.h"

@interface ChooseSoundIntervalController ()

@property (weak, nonatomic) IBOutlet UISwitch *multiSelectSwitch;

@end

@implementation ChooseSoundIntervalController
{
    BLKArrBlock _didChoosedBlock;
    BOOL _allowsMultipleSelection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)setDidChoosedBlock:(BLKArrBlock)aBlock
{
    _didChoosedBlock = aBlock;
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    self.tableView.tableFooterView = [UIView new];
    
    if (_choosedSoundIntervalArr.count > 1)
    {
        _allowsMultipleSelection = YES;
        [_multiSelectSwitch setOn:YES];
    }
    else
    {
        _allowsMultipleSelection = NO;
        [_multiSelectSwitch setOn:NO];
    }
    
    NSUInteger rows = [self.tableView numberOfRowsInSection:0];
    UITableViewCell *theCell;
    for (int i = 1; i < rows; i++)
    {
        theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if ([_choosedSoundIntervalArr containsObject:@(i - 1)])
        {
            theCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != 0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        if (!_allowsMultipleSelection)
        {
            NSUInteger rows = [self.tableView numberOfRowsInSection:0];
            
            UITableViewCell *theCell;
            for (int i = 1; i < rows; i++)
            {
                if (i != indexPath.row)
                {
                    theCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    theCell.accessoryType = UITableViewCellAccessoryNone;                    
                }
            }
        }
    }
    
    [tableView reloadData];
}


- (IBAction)multiSelectValueChangedAction:(UISwitch *)sender
{
    _allowsMultipleSelection = sender.isOn;
    
    NSUInteger rows = [self.tableView numberOfRowsInSection:0];
    
    UITableViewCell *theCell;
    for (int i = 1; i < rows; i++)
    {
        theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        theCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self.tableView reloadData];
}


- (IBAction)ensureAction:(id)sender
{
    NSUInteger rows = [self.tableView numberOfRowsInSection:0];
    
    NSMutableArray *theMutArr = [NSMutableArray new];
    UITableViewCell *theCell;
    for (int i = 1; i < rows; i++)
    {
        theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (theCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            [theMutArr addObject:@(i - 1)];
        }
    }
    
    _choosedSoundIntervalArr = [theMutArr copy]  ;
    
    _didChoosedBlock ? _didChoosedBlock(_choosedSoundIntervalArr) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
