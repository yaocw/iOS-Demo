//
//  MusicalScaleExerciseController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MusicalScaleExerciseController.h"

#import <AVFoundation/AVFoundation.h>

#import "SolfeggioMacros.h"
#import "LMPopMenu.h"
#import "MusicalScaleExerciseSettingController.h"

@interface MusicalScaleExerciseController ()

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repeatBtnVerticalConstraint;

@end

@implementation MusicalScaleExerciseController
{
    AVPlayer *_player;
    NSMutableArray *_currentPlayItemPaths;

    NSMutableArray *_choosedSounds;
    
    int _previousPlaySoundIndex;
    
    NSInteger _playCountEachTime;
    NSInteger _playCountSurplus;
    
    NSInteger _playInterval;
    
    int _musicalScaleScopeFrom;
    int _musicalScaleScopeTo;
    
    BOOL _isPlaying;
    BOOL _isRepeatPlay;
    
    NSTimer *_timer;
    
    NSArray *_choosedSoundIntervalArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isPlaying = NO;
    
    [_player pause];
    _player = nil;
    
    [_timer invalidate];
}

- (void)initializeBaseData
{
    _previousPlaySoundIndex = -1;
    
    _currentPlayItemPaths = [NSMutableArray new];

    _playCountEachTime = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExercisePlayCountEachTime")).integerValue;
    _playCountEachTime = (_playCountEachTime == 0 ? 1 : _playCountEachTime);
    
    _playInterval = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExercisePlayInterval")).integerValue;
    
    _musicalScaleScopeFrom = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeFrom")).intValue;
    _musicalScaleScopeTo = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeTo")).intValue;
    
    _choosedSoundIntervalArr = [NSArray arrayWithContentsOfFile:kChoosedSoundIntervalFilePath];
    
    [self fetchChoosedSounds];
}

- (void)fetchChoosedSounds
{
    _choosedSounds = [(NSArray *)kLoadArrayFromPlistFile(@"MusicalScaleExercise") mutableCopy];
    NSArray *pianoSounds = [[_choosedSounds reverseObjectEnumerator] allObjects];
    
    [_choosedSounds removeAllObjects];
    for (int i = 0; i < pianoSounds.count; i++)
    {
        if (i >= _musicalScaleScopeFrom)
        {
            if (i <= _musicalScaleScopeTo)
            {
                [_choosedSounds addObject:pianoSounds[i]];
            }
            else
            {
                break;
            }
        }
    }
}

- (void)initializeUIComponents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    _answerLabel.text = @"";
    _nextButton.hidden = YES;
    
    _repeatBtnVerticalConstraint.constant = 0;
}

- (void)playerItemDidReachEnd:(id)sender
{
    _playCountSurplus --;
    
    if (_playCountSurplus > 0)
    {
        if (_timer)
        {
            [_timer invalidate];
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:_playInterval target:self selector:@selector(playTheSound) userInfo:nil repeats:NO];
    }
    else
    {
        _isPlaying = NO;
    }
    
}

- (void)pushSettingController
{
    MusicalScaleExerciseSettingController *controller = kInstanceFromStoryboard(@"MusicalScaleExerciseSettingController", @"MusicalScaleExerciseSettingController");
    [controller setDidChangedSettingBlock:^{
        
        _playCountEachTime = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExercisePlayCountEachTime")).integerValue;
        _playCountEachTime = (_playCountEachTime == 0 ? 1 : _playCountEachTime);
        
        _playInterval = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExercisePlayInterval")).integerValue;
        
        _choosedSoundIntervalArr = [NSArray arrayWithContentsOfFile:kChoosedSoundIntervalFilePath];
        
        [_repeatButton setTitle:@"开始" forState:UIControlStateNormal];
        _nextButton.hidden = YES;
        _previousPlaySoundIndex = -1;
        _repeatBtnVerticalConstraint.constant = 0;
        
        _musicalScaleScopeFrom = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeFrom")).intValue;
        _musicalScaleScopeTo = ((NSNumber *)kFetchFromUserDefaults(@"MusicalScaleExerciseMusicalScaleScopeTo")).intValue;
        
        [self fetchChoosedSounds];
    }];
    
    kPushViewControllerWithController(controller);
}


- (IBAction)popMenuAction:(id)sender
{
    NSArray *titles = @[@"播放设置"];
    [[LMPopMenu sharePopMenu] showPopMenuWithPoint:CGPointMake(kDeviceWidth - 25, 50) menuTitles:titles menuIcons:nil clickItemBlock:^(NSInteger index) {
        
        if (index == 0)
        {
            [self pushSettingController];
            
            return ;
        }
    }];
}

- (IBAction)repeatSoundsAction:(UIButton *)sender
{
    if (_choosedSounds.count == 0)
    {
        [CustomPopupView alertView:^(NSInteger index) {
            
            if (index == 0)
            {
                [self pushSettingController];
            }
            
        } title:@"温馨提示" message:@"当前没有选择音阶范围，请选择" items:@"确定", @"取消", nil];
        
        return ;
    }
    
    if (_choosedSoundIntervalArr.count == 0)
    {
        [CustomPopupView alertView:^(NSInteger index) {
            
            if (index == 0)
            {
                [self pushSettingController];
            }
            
        } title:@"温馨提示" message:@"当前没有选择音程，请选择" items:@"确定", @"取消", nil];
        
        return ;
    }
    
    
    int musicalScaleScope = _musicalScaleScopeTo - _musicalScaleScopeFrom;
    
    int maxMusicalSoundInterval = 0;
    for (NSNumber *theNumber in _choosedSoundIntervalArr)
    {
        if (maxMusicalSoundInterval < theNumber.intValue)
        {
            maxMusicalSoundInterval = theNumber.intValue;
        }
    }
    
    if (musicalScaleScope < maxMusicalSoundInterval)
    {
        [CustomPopupView alertView:^(NSInteger index) {
            
            if (index == 0)
            {
                [self pushSettingController];
            }
            
        } title:@"温馨提示" message:@"当前音阶范围内没有该音程，请重新设置" items:@"确定", @"取消", nil];
        
        return ;
    }
    
    
    

    
    if ([sender.titleLabel.text isEqualToString:@"开始"] || _isPlaying)
    {
        _isRepeatPlay = NO;
        [_currentPlayItemPaths removeAllObjects];
        _previousPlaySoundIndex = -1;
    }
    else
    {
        _isRepeatPlay = YES;
    }
    
    [sender setTitle:@"重复" forState:UIControlStateNormal];
    _nextButton.hidden = NO;
    _repeatBtnVerticalConstraint.constant = -60;
    _isPlaying = YES;
    _playCountSurplus = _playCountEachTime;
    
    [self playTheSound];
}

- (IBAction)nextSoundsAction:(id)sender
{
    _isRepeatPlay = NO;
    _isPlaying = YES;
    _previousPlaySoundIndex = -1;
    _playCountSurplus = _playCountEachTime;
    [_currentPlayItemPaths removeAllObjects];
    [self playTheSound];
}

- (void)playTheSound
{
    if (_isRepeatPlay)
    {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_currentPlayItemPaths[_playCountEachTime - _playCountSurplus] ofType:@"mp3"]]];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [_player play];
        
        NSString *answerText = _currentPlayItemPaths[_playCountEachTime - _playCountSurplus];
        answerText = [answerText stringByReplacingOccurrencesOfString:@"[d]" withString:@"大字" options:NSRegularExpressionSearch range:NSMakeRange(0, answerText.length)];
        answerText = [answerText stringByReplacingOccurrencesOfString:@"[x]" withString:@"小字" options:NSRegularExpressionSearch range:NSMakeRange(0, answerText.length)];
        answerText = [answerText stringByReplacingOccurrencesOfString:@"-" withString:@"组 "];
        
        _answerLabel.text = answerText;
    }
    else
    {
        int randomInt = [self generateRandomIntBySoundInterval];
        
        [_currentPlayItemPaths addObject:_choosedSounds[randomInt]];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_choosedSounds[randomInt] ofType:@"mp3"]]];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [_player play];
        
        NSString *answerText = _choosedSounds[randomInt];
        answerText = [answerText stringByReplacingOccurrencesOfString:@"[d]" withString:@"大字" options:NSRegularExpressionSearch range:NSMakeRange(0, answerText.length)];
        answerText = [answerText stringByReplacingOccurrencesOfString:@"[x]" withString:@"小字" options:NSRegularExpressionSearch range:NSMakeRange(0, answerText.length)];
        answerText = [answerText stringByReplacingOccurrencesOfString:@"-" withString:@"组 "];
        
        _answerLabel.text = answerText;
    }
}

- (int)generateRandomIntBySoundInterval
{
    int retRandomInt = 0;
    int randomIntForSoundInterval = kGetRandomIntWithUpperLimit(_choosedSoundIntervalArr.count);
    int randomSoundInterval = ((NSNumber *)_choosedSoundIntervalArr[randomIntForSoundInterval]).intValue;
    int choosedScaleScope = _musicalScaleScopeTo - _musicalScaleScopeFrom;
    
    if (_previousPlaySoundIndex == -1)
    {
        retRandomInt = kGetRandomIntWithUpperLimit(choosedScaleScope + 1);
        
        if (((retRandomInt + randomSoundInterval) > choosedScaleScope)
            && ((retRandomInt - randomSoundInterval) < 0))
        {
            BOOL isUpPlay = kGetRandomIntWithUpperLimit(2) == 0;
            if (isUpPlay)
            {
                retRandomInt = choosedScaleScope;
            }
            else
            {
                retRandomInt = 0;
            }
        }
    }
    else
    {
        BOOL isUpPlay = kGetRandomIntWithUpperLimit(2) == 0;
        if (isUpPlay)
        {
            if ((_previousPlaySoundIndex + randomSoundInterval) > choosedScaleScope)
            {
                retRandomInt = _previousPlaySoundIndex - randomSoundInterval;
            }
            else
            {
                retRandomInt = _previousPlaySoundIndex + randomSoundInterval;
            }
        }
        else
        {
            if ((_previousPlaySoundIndex - randomSoundInterval) < 0)
            {
                retRandomInt = _previousPlaySoundIndex + randomSoundInterval;
            }
            else
            {
                retRandomInt = _previousPlaySoundIndex - randomSoundInterval;
            }
        }
    }
    
    _previousPlaySoundIndex = retRandomInt;
    
    return retRandomInt;
}

- (IBAction)showTheAnswerAction:(UISwitch *)sender
{
    if (sender.isOn)
    {
        _answerLabel.hidden = NO;
    }
    else
    {
        _answerLabel.hidden = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
