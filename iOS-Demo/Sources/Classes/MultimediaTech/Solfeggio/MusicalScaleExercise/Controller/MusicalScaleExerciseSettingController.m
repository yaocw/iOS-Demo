//
//  MusicalScaleExerciseSettingController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MusicalScaleExerciseSettingController.h"
#import "ChooseMusicalScaleScopeView.h"
#import "ChooseSoundIntervalController.h"
#import "SolfeggioMacros.h"

@interface MusicalScaleExerciseSettingController ()

@property (weak, nonatomic) IBOutlet UILabel *playCountEachTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *playCountEachTimeSlider;

@property (weak, nonatomic) IBOutlet UILabel *playIntervalLabel;
@property (weak, nonatomic) IBOutlet UISlider *playIntervalSlider;

@property (weak, nonatomic) IBOutlet UILabel *musicalScaleScopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *choosedSoundIntervalLabel;

@end

@implementation MusicalScaleExerciseSettingController
{
    BLKBlock _didChangedSettingBlock;
    
    NSArray *_pianoSounds;
    NSArray *_choosedSoundIntervalArr;
    
    ChooseMusicalScaleScopeView *_musicalScaleScopeView;
    
    NSArray *_soundIntervalTitles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    NSMutableArray *tempArr = [(NSArray *)kLoadArrayFromPlistFile(@"MusicalScaleExercise") mutableCopy];
    _pianoSounds = [[tempArr reverseObjectEnumerator] allObjects];
    
    
    _soundIntervalTitles = @[
                            @"纯一度",
                            @"小二度",
                            @"大二度",
                            @"小三度",
                            @"大三度",
                            @"纯四度",
                            @"增四度/减五度",
                            @"纯五度",
                            @"小六度",
                            @"大六度",
                            @"小七度",
                            @"大七度",
                            @"纯八度"
                            ];
    
    _choosedSoundIntervalArr = [NSArray arrayWithContentsOfFile:kChoosedSoundIntervalFilePath];
}

- (void)initializeUIComponents
{
    _playCountEachTimeSlider.value = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExercisePlayCountEachTime")).integerValue;
    _playIntervalSlider.value = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExercisePlayInterval")).integerValue;
    
    _playCountEachTimeLabel.text = [NSString stringWithFormat:@"每次播放音阶数：%d", (int)_playCountEachTimeSlider.value];
    _playIntervalLabel.text = [NSString stringWithFormat:@"音阶播放间隔(s)：%d", (int)_playIntervalSlider.value];
    
    [self setTextToMusicalScaleScopeLabel];
    [self setTextToChoosedSoundIntervalLabel];
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
    kSaveToUserDefaults(@"MusicalScaleExercisePlayCountEachTime", @((int)_playCountEachTimeSlider.value));
    kSaveToUserDefaults(@"MusicalScaleExercisePlayInterval", @((int)_playIntervalSlider.value));
    kSaveToUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeFrom", @(_musicalScaleScopeView.musicalScaleScopeFrom));
    kSaveToUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeTo", @(_musicalScaleScopeView.musicalScaleScopeTo));
    
    
    //创建目录
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:kSolfeggioFileDirectory isDirectory:&isDir];
    if (!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:kSolfeggioFileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //创建文件
    if (![fileManager fileExistsAtPath:kChoosedSoundIntervalFilePath])
    {
        [fileManager createFileAtPath:kChoosedSoundIntervalFilePath contents:nil attributes:nil];
    }
    
    //序列化对象
    if (![_choosedSoundIntervalArr writeToFile:kChoosedSoundIntervalFilePath atomically:YES])
    {
        [CustomPopupView alertViewWithTitle:@"温馨提示" message:@"保存失败，请重新尝试" confirm:@"确定"];
        return ;
    }
    
    _didChangedSettingBlock ? _didChangedSettingBlock() : nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseMusicalScaleScopeAction:(id)sender
{
    _musicalScaleScopeView = (ChooseMusicalScaleScopeView *)kInstanceFromXib(@"ChooseMusicalScaleScopeView");
    
    kWeakSelf(weakSelf);
    [_musicalScaleScopeView setDidChoosedBlock:^{
        [weakSelf setTextToMusicalScaleScopeLabel];
    }];
    
    [kWindow addSubview:_musicalScaleScopeView];
}

- (void)setTextToMusicalScaleScopeLabel
{
    
    int musicalScaleScopeFrom = 0;
    int musicalScaleScopeTo = 0;
    if (_musicalScaleScopeView)
    {
        musicalScaleScopeFrom = _musicalScaleScopeView.musicalScaleScopeFrom;
        musicalScaleScopeTo = _musicalScaleScopeView.musicalScaleScopeTo;
    }
    else
    {
        musicalScaleScopeFrom = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeFrom")).intValue;
        musicalScaleScopeTo = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeTo")).intValue;
    }
    
    
    
    NSString *musicalScaleScopeFromTitle = _pianoSounds[musicalScaleScopeFrom];
    NSString *musicalScaleScopeToTitle = _pianoSounds[musicalScaleScopeTo];
    
    
    musicalScaleScopeFromTitle = [musicalScaleScopeFromTitle stringByReplacingOccurrencesOfString:@"[d]" withString:@"大字" options:NSRegularExpressionSearch range:NSMakeRange(0, musicalScaleScopeFromTitle.length)];
    musicalScaleScopeFromTitle = [musicalScaleScopeFromTitle stringByReplacingOccurrencesOfString:@"[x]" withString:@"小字" options:NSRegularExpressionSearch range:NSMakeRange(0, musicalScaleScopeFromTitle.length)];
    musicalScaleScopeFromTitle = [musicalScaleScopeFromTitle stringByReplacingOccurrencesOfString:@"-" withString:@"组 "];
    
    
    musicalScaleScopeToTitle = [musicalScaleScopeToTitle stringByReplacingOccurrencesOfString:@"[d]" withString:@"大字" options:NSRegularExpressionSearch range:NSMakeRange(0, musicalScaleScopeToTitle.length)];
    musicalScaleScopeToTitle = [musicalScaleScopeToTitle stringByReplacingOccurrencesOfString:@"[x]" withString:@"小字" options:NSRegularExpressionSearch range:NSMakeRange(0, musicalScaleScopeToTitle.length)];
    musicalScaleScopeToTitle = [musicalScaleScopeToTitle stringByReplacingOccurrencesOfString:@"-" withString:@"组 "];
    
    
    _musicalScaleScopeLabel.text = [NSString stringWithFormat:@"音阶范围：%@ - %@", musicalScaleScopeFromTitle, musicalScaleScopeToTitle];
}


- (IBAction)chooseMusicalSoundIntervalAction:(id)sender
{
    ChooseSoundIntervalController *controller = kInstanceFromStoryboard(@"ChooseSoundIntervalController", @"ChooseSoundIntervalController");

    [controller setDidChoosedBlock:^(NSArray *arr) {
        _choosedSoundIntervalArr = arr;

        [self setTextToChoosedSoundIntervalLabel];
    }];
    
    controller.choosedSoundIntervalArr = _choosedSoundIntervalArr;
    
    kPushViewControllerWithController(controller);
}

- (void)setTextToChoosedSoundIntervalLabel
{
    if (_choosedSoundIntervalArr.count > 0)
    {
        NSMutableString *theTitle = [NSMutableString new];
        for (NSNumber *theIndex in _choosedSoundIntervalArr)
        {
            [theTitle appendString:_soundIntervalTitles[theIndex.intValue]];
            [theTitle appendString:@"  "];
        }
        
        _choosedSoundIntervalLabel.text = theTitle;
    }
    else
    {
        _choosedSoundIntervalLabel.text = @"无";
    }
    
}


@end
