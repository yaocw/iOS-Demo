//
//  ChooseMusicalScaleScopeView.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ChooseMusicalScaleScopeView.h"

@interface ChooseMusicalScaleScopeView () <UIPickerViewDataSource ,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation ChooseMusicalScaleScopeView
{
    BLKBlock _didChoosedBlock;
    
    NSMutableArray *_componentTitles;
    
    int _privateMusicalScaleScopeFrom;
    int _privateMusicalScaleScopeTo;
}

- (void)setDidChoosedBlock:(BLKBlock)aBlock
{
    _didChoosedBlock = aBlock;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initializeBaseData];
    [self initializeUIComponents];
    
}

- (void)initializeBaseData
{
    NSArray *playSounds = [(NSArray *)kLoadArrayFromPlistFile(@"MusicalScaleExercise") mutableCopy];
    playSounds = [[playSounds reverseObjectEnumerator] allObjects];
    
    _privateMusicalScaleScopeFrom = 0;
    _privateMusicalScaleScopeTo = 0;
    
    _componentTitles = [NSMutableArray new];
    NSString *theTitle;
    for (NSString *theStr in playSounds)
    {
        theTitle = [theStr stringByReplacingOccurrencesOfString:@"[d]" withString:@"大字" options:NSRegularExpressionSearch range:NSMakeRange(0, theStr.length)];
        theTitle = [theTitle stringByReplacingOccurrencesOfString:@"[x]" withString:@"小字" options:NSRegularExpressionSearch range:NSMakeRange(0, theStr.length)];
        theTitle = [theTitle stringByReplacingOccurrencesOfString:@"-" withString:@"组 "];
        
        [_componentTitles addObject:theTitle];
    }
}

- (void)initializeUIComponents
{
    self.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 265.0f);
    visualEffectView.alpha = 0.78f;
    [self addSubview:visualEffectView];
    
    [self bringSubviewToFront:_backgroundButton];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _componentTitles.count ;
    }
    else
    {
        return _componentTitles.count - _privateMusicalScaleScopeFrom;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _componentTitles[row];
    }
    else
    {
        return _componentTitles[row + _privateMusicalScaleScopeFrom];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        _privateMusicalScaleScopeFrom = (int)row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        _privateMusicalScaleScopeTo = _privateMusicalScaleScopeFrom;
    }
    else
    {
        _privateMusicalScaleScopeTo = _privateMusicalScaleScopeFrom + (int)row;
    }
}

- (IBAction)backgroundClickAction:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)cancelAction:(id)sender
{
    [self removeFromSuperview];
}


- (IBAction)ensureAction:(id)sender
{
    _musicalScaleScopeFrom = _privateMusicalScaleScopeFrom;
    _musicalScaleScopeTo = _privateMusicalScaleScopeTo;
    
    _didChoosedBlock ? _didChoosedBlock() : nil;
    
    [self removeFromSuperview];
}

@end
