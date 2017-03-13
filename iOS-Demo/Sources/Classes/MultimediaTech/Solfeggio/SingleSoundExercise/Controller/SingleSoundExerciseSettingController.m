//
//  SingleSoundExerciseSettingController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SingleSoundExerciseSettingController.h"

@interface SingleSoundExerciseSettingController ()

@property (weak, nonatomic) IBOutlet UILabel *playCountEachTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *playCountEachTimeSlider;

@property (weak, nonatomic) IBOutlet UILabel *playIntervalLabel;
@property (weak, nonatomic) IBOutlet UISlider *playIntervalSlider;

@end

@implementation SingleSoundExerciseSettingController
{
    BLKBlock _didChangedSettingBlock;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)initializeUIComponents
{
    _playCountEachTimeSlider.value = ((NSNumber *)kFetchFromUserDefaults(@"SingleSoundExercisePlayCountEachTime")).integerValue;
    _playIntervalSlider.value = ((NSNumber *)kFetchFromUserDefaults(@"SingleSoundExercisePlayInterval")).integerValue;
    
    _playCountEachTimeLabel.text = [NSString stringWithFormat:@"每次播放音阶数：%d", (int)_playCountEachTimeSlider.value];
    _playIntervalLabel.text = [NSString stringWithFormat:@"音阶播放间隔(s)：%d", (int)_playIntervalSlider.value];
}

- (void)setDidChangedSettingBlock:(BLKBlock)aBlock
{
    _didChangedSettingBlock = aBlock;
}

- (IBAction)playCountChangedAction:(UISlider *)sender
{
    _playCountEachTimeLabel.text = [NSString stringWithFormat:@"每次播放音阶数：%d", (int)sender.value];
}

- (IBAction)playIntervalChangedAction:(UISlider *)sender
{
    _playIntervalLabel.text = [NSString stringWithFormat:@"音阶播放间隔(s)：%d", (int)sender.value];
}

- (IBAction)ensureAction:(id)sender
{
    kSaveToUserDefaults(@"SingleSoundExercisePlayCountEachTime", @((int)_playCountEachTimeSlider.value));
    kSaveToUserDefaults(@"SingleSoundExercisePlayInterval", @((int)_playIntervalSlider.value));
    
    _didChangedSettingBlock ? _didChangedSettingBlock() : nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
