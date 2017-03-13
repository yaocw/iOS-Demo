//
//  SingleSoundExerciseController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SingleSoundExerciseController.h"

#import <AVFoundation/AVFoundation.h>

#import "SolfeggioMacros.h"
#import "LMPopMenu.h"
#import "ChooseMusicalScaleController.h"
#import "SingleSoundExerciseSettingController.h"

@interface SingleSoundExerciseController ()

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repeatBtnVerticalConstraint;

@end

@implementation SingleSoundExerciseController
{
    AVPlayer *_player;
    NSMutableArray *_currentPlayItemPaths;
    
    NSDictionary *_sectionChoosedSounds;
    NSMutableArray *_choosedSounds;
    
    NSInteger _playCountEachTime;
    NSInteger _playCountSurplus;
    
    NSInteger _playInterval;
    
    BOOL _isPlaying;
    BOOL _isRepeatPlay;
    
    NSTimer *_timer;
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
    _currentPlayItemPaths = [NSMutableArray new];
    
    [self fetchChoosedSounds];
    
    _playCountEachTime = ((NSNumber *)kFetchFromUserDefaults(@"SingleSoundExercisePlayCountEachTime")).integerValue;
    _playCountEachTime = (_playCountEachTime == 0 ? 1 : _playCountEachTime);
    
    _playInterval = ((NSNumber *)kFetchFromUserDefaults(@"SingleSoundExercisePlayInterval")).integerValue;
}

- (void)fetchChoosedSounds
{
    _sectionChoosedSounds = [NSMutableDictionary dictionaryWithContentsOfFile:kSectionChoosedSoundsFilePath];
    
    _choosedSounds = [NSMutableArray new];
    NSArray *theAllKeys = [_sectionChoosedSounds allKeys];
    NSArray *theArr = nil;
    for (NSString *theStr in theAllKeys)
    {
        theArr = _sectionChoosedSounds[theStr];
        if (theArr.count > 0)
        {
            [_choosedSounds addObjectsFromArray:theArr];
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


- (IBAction)popMenuAction:(id)sender
{
    NSArray *titles = @[@"选择音阶", @"播放设置"];
    [[LMPopMenu sharePopMenu] showPopMenuWithPoint:CGPointMake(kDeviceWidth - 25, 50) menuTitles:titles menuIcons:nil clickItemBlock:^(NSInteger index) {
        
        if (index == 0)
        {
            [self pushChooseMusicalScaleController];
            
            return ;
        }
        
        if (index == 1)
        {
            SingleSoundExerciseSettingController *controller = kInstanceFromStoryboard(@"SingleSoundExerciseSettingController", @"SingleSoundExerciseSettingController");
            [controller setDidChangedSettingBlock:^{
                
                _playCountEachTime = ((NSNumber *)kFetchFromUserDefaults(@"SingleSoundExercisePlayCountEachTime")).integerValue;
                _playCountEachTime = (_playCountEachTime == 0 ? 1 : _playCountEachTime);
                
                _playInterval = ((NSNumber *)kFetchFromUserDefaults(@"SingleSoundExercisePlayInterval")).integerValue;
                
                [_repeatButton setTitle:@"开始" forState:UIControlStateNormal];
                _nextButton.hidden = YES;
                _repeatBtnVerticalConstraint.constant = 0;
            }];
            
            kPushViewControllerWithController(controller);
            
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
                [self pushChooseMusicalScaleController];
            }
        } title:@"温馨提示" message:@"当前没有选择音阶范围，请选择" items:@"确定", @"取消", nil];
    }
    else
    {
        if ([sender.titleLabel.text isEqualToString:@"开始"] || _isPlaying)
        {
            _isRepeatPlay = NO;
            [_currentPlayItemPaths removeAllObjects];
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
}

- (void)pushChooseMusicalScaleController
{
    ChooseMusicalScaleController *controller = kInstanceFromStoryboard(@"ChooseMusicalScaleController", @"ChooseMusicalScaleController");
    [controller setDidChangedSoundsBlock:^{
        [self fetchChoosedSounds];
        [_repeatButton setTitle:@"开始" forState:UIControlStateNormal];
        _nextButton.hidden = YES;
        _repeatBtnVerticalConstraint.constant = 0;
    }];
    
    kPushViewControllerWithController(controller);
}

- (IBAction)nextSoundsAction:(id)sender
{
    _isRepeatPlay = NO;
    _isPlaying = YES;
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
        answerText = [answerText stringByReplacingOccurrencesOfString:@"[0-9a-z-]*" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, answerText.length)];
        
        NSArray *theAllKeys = [_sectionChoosedSounds allKeys];
        NSArray *theArr = nil;
        for (int i = 0; i < theAllKeys.count; i++)
        {
            theArr = _sectionChoosedSounds[theAllKeys[i]];
            if ([theArr containsObject:_currentPlayItemPaths[_playCountEachTime - _playCountSurplus]])
            {
                answerText = [NSString stringWithFormat:@"%@ - %@", theAllKeys[i], answerText];
                break ;
            }
        }
        
        _answerLabel.text = answerText;
    }
    else
    {
        int randomInt = kGetRandomIntWithUpperLimit(_choosedSounds.count);
        [_currentPlayItemPaths addObject:_choosedSounds[randomInt]];
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_choosedSounds[randomInt] ofType:@"mp3"]]];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [_player play];
        
        NSString *answerText = _choosedSounds[randomInt];
        answerText = [answerText stringByReplacingOccurrencesOfString:@"[0-9a-z-]*" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, answerText.length)];
        
        NSArray *theAllKeys = [_sectionChoosedSounds allKeys];
        NSArray *theArr = nil;
        for (int i = 0; i < theAllKeys.count; i++)
        {
            theArr = _sectionChoosedSounds[theAllKeys[i]];
            if ([theArr containsObject:_choosedSounds[randomInt]])
            {
                answerText = [NSString stringWithFormat:@"%@ - %@", theAllKeys[i], answerText];
                break ;
            }
        }
        
        _answerLabel.text = answerText;
    }
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
