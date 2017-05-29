//
//  RecognizeStaveForTwoController.m
//  iOS-Demo
//
//  Created by yaochaowen on 2017/5/29.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "RecognizeStaveForTwoController.h"
#import "StaveForTwoView.h"
#import "LMPopMenu.h"

#import <AVFoundation/AVFoundation.h>

#define mCenterLevelOfNotesForTrebleClef 14
#define mCenterLevelOfNotesForBassClef 16

@interface RecognizeStaveForTwoController ()

@property (weak, nonatomic) IBOutlet UIImageView *trebleClefImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bassClefImageView;

@property (weak, nonatomic) IBOutlet StaveForTwoView *staveView;
@property (weak, nonatomic) IBOutlet UILabel *noteLevelLabel;

@property (weak, nonatomic) IBOutlet UIView *practiseModeOptView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfLevelsForPlayingSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfNotesForPlayingSegControl;
@property (weak, nonatomic) IBOutlet UISlider *chooseLevelsSlider;

@property (weak, nonatomic) IBOutlet UIStepper *playSpeedStepper;

@end

@implementation RecognizeStaveForTwoController
{
    BOOL _isUsingTrebleClef;
    BOOL _isUsingPractiseMode;
    
    NSMutableArray *_musicalSounds;
    
    AVPlayer *_player;
    
    NSMutableArray *_currentNotesLevel;
    
    CADisplayLink *_displayLink;
    BOOL _isPlaying;
    NSInteger _counter;
    
    NSInteger _indexOfCurrentPlaying;
    
    NSString *_noteLevelText;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self clear];
}

- (void)clear
{
    [_displayLink invalidate];
    [_player pause];
    
    _displayLink = nil;
    _player = nil;
    
    _isPlaying = NO;
}

- (void)initializeBaseData
{
    _isUsingTrebleClef = YES;
    _isUsingPractiseMode = YES;
    
    _currentNotesLevel = [NSMutableArray new];
    
    [self loadTheMusicalSounds];
    
    _trebleClefImageView.hidden = NO;
    _bassClefImageView.hidden = YES;
}

- (void)loadTheMusicalSounds
{
    if (_isUsingTrebleClef)
    {
        _musicalSounds = [(NSArray *)kLoadArrayFromPlistFile(@"MusicalSoundsForTrebleClef") mutableCopy];
        _musicalSounds = (NSMutableArray *)[[_musicalSounds reverseObjectEnumerator] allObjects];
        
        _staveView.centerLevelOfNotes = mCenterLevelOfNotesForTrebleClef;
    }
    else
    {
        _musicalSounds = [(NSArray *)kLoadArrayFromPlistFile(@"MusicalSoundsForBassClef") mutableCopy];
        _musicalSounds = (NSMutableArray *)[[_musicalSounds reverseObjectEnumerator] allObjects];
        
        _staveView.centerLevelOfNotes = mCenterLevelOfNotesForBassClef;
    }
}


- (void)initializeUIComponents
{
    [self nextNoteForRandom];
}


- (void)nextNoteForRandom
{
    UIButton *tempButton = [UIButton new];
    tempButton.tag = 1;
    [self nextNoteAction:tempButton];
}


#pragma mark -- Actions

- (IBAction)popMenuAction:(id)sender
{
    NSArray *titles = @[@"高音谱表", @"低音谱表"];
    [[LMPopMenu sharePopMenu] showPopMenuWithPoint:CGPointMake(kDeviceWidth - 25, 50) menuTitles:titles menuIcons:nil clickItemBlock:^(NSInteger index) {
        
        [self clear];
        
        if (index == 0)
        {
            _isUsingTrebleClef = YES;
            
            _trebleClefImageView.hidden = NO;
            _bassClefImageView.hidden = YES;
            
            [self loadTheMusicalSounds];
            [self nextNoteForRandom];
            
            return ;
        }
        
        if (index == 1)
        {

            _isUsingTrebleClef = NO;
            
            _trebleClefImageView.hidden = YES;
            _bassClefImageView.hidden = NO;
            
            [self loadTheMusicalSounds];
            [self nextNoteForRandom];
            
            return ;
        }
    }];
}

- (IBAction)nextNoteAction:(UIButton *)sender
{
    [self clear];
    
    NSInteger numberOfLevelsForPlaying = (int)(_numberOfLevelsForPlayingSegControl.selectedSegmentIndex + 3);
    NSInteger numberOfNotesForPlaying = (int)(_numberOfNotesForPlayingSegControl.selectedSegmentIndex + 3);
    NSInteger chooseNotesLevel = (int)_chooseLevelsSlider.value;
    
    //随机产生音符并播放
    if (sender.tag == 1)
    {
        [_currentNotesLevel removeAllObjects];
        
        for (int i = 0; i < numberOfNotesForPlaying; i++)
        {
            [_currentNotesLevel addObject:@(kGetRandomIntWithLimit(chooseNotesLevel, chooseNotesLevel + numberOfLevelsForPlaying + 1))];
        }
    }
    
    
    NSMutableString *tempNoteLevelText = [NSMutableString new];
    int noteLevel = 0;
    int index = 0;
    
    for (NSNumber *theNoteLevel in _currentNotesLevel)
    {
        noteLevel = theNoteLevel.intValue;
        
        switch (noteLevel % 7) {
            case 0:
            {
                [tempNoteLevelText appendString:@"7"];
                break;
            }
                
            case 1:
            {
                [tempNoteLevelText appendString:@"1"];
                break;
            }
                
            case 2:
            {
                [tempNoteLevelText appendString:@"2"];
                break;
            }
                
            case 3:
            {
                [tempNoteLevelText appendString:@"3"];
                break;
            }
                
            case 4:
            {
                [tempNoteLevelText appendString:@"4"];
                break;
            }
                
            case 5:
            {
                [tempNoteLevelText appendString:@"5"];
                break;
            }
                
            case 6:
            {
                [tempNoteLevelText appendString:@"6"];
                break;
            }
            default:
                break;
        }
        
        index ++;
        if (index < _currentNotesLevel.count)
        {
            [tempNoteLevelText appendString:@" "];
        }
    }
    
    _noteLevelText = tempNoteLevelText;
    
//    NSMutableAttributedString *noteLevelTextAttrString = [[NSMutableAttributedString alloc] initWithString:_noteLevelText];
//    [noteLevelTextAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
//    _noteLevelLabel.attributedText = noteLevelTextAttrString;
    
    _staveView.notesLevel = _currentNotesLevel;
    [self playSounds];
}

- (void)playSounds
{
    if (_isPlaying)
    {
        return;
    }
    
    _counter = (int)_playSpeedStepper.value;
    _isPlaying = YES;
    _indexOfCurrentPlaying = 0;
    
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)handleDisplayLink
{
    _counter ++;
    if (_counter >= ((int)_playSpeedStepper.value))
    {
        if (_indexOfCurrentPlaying >= _currentNotesLevel.count)
        {
            [self clear];
            
            _staveView.focusIndex = _indexOfCurrentPlaying;
            [_staveView setNeedsDisplay];
            
            _noteLevelLabel.text = _noteLevelText;
        }
        else
        {
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_musicalSounds[((NSNumber *)_currentNotesLevel[_indexOfCurrentPlaying]).intValue - 1] ofType:@"mp3"]]];
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            [_player play];
            
            NSMutableAttributedString *noteLevelTextAttrString = [[NSMutableAttributedString alloc] initWithString:_noteLevelText];
            [noteLevelTextAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50.f] range:NSMakeRange(_indexOfCurrentPlaying * 2, 1)];
            [noteLevelTextAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(_indexOfCurrentPlaying * 2, 1)];
            _noteLevelLabel.attributedText = noteLevelTextAttrString;
            
            
            _staveView.focusIndex = _indexOfCurrentPlaying;
            [_staveView setNeedsDisplay];
            
            _indexOfCurrentPlaying ++;
            _counter = 0;
        }
        
    }
}

- (IBAction)chooseLevelsAction:(UISlider *)sender
{
    if (_displayLink != nil || _player != nil)
    {
        [self clear];
    }
    
    NSInteger numberOfLevelsForPlaying = (int)(_numberOfLevelsForPlayingSegControl.selectedSegmentIndex + 3);
    NSInteger chooseNotesLevel = (int)_chooseLevelsSlider.value;
    
    _staveView.notesLevel = @[@(chooseNotesLevel + 1), @(chooseNotesLevel + numberOfLevelsForPlaying)];
    [_staveView setNeedsDisplay];
}

- (IBAction)choosedLevelsTouchUpAction:(id)sender
{
    [self nextNoteForRandom];
}

- (IBAction)chooseNumberOfLevelsAction:(UISegmentedControl *)sender
{
    NSInteger numberOfLevelsForPlaying = (int)(sender.selectedSegmentIndex + 3);
    _chooseLevelsSlider.maximumValue = (float)(_musicalSounds.count - numberOfLevelsForPlaying);
    
    [self clear];
    [self nextNoteForRandom];
}

- (IBAction)chooseNumberOfNotesForPlayingAction:(UISegmentedControl *)sender
{
    [self clear];
    [self nextNoteForRandom];
}

- (IBAction)playSpeedAction:(id)sender
{
    [self clear];
    [self nextNoteForRandom];
}

#pragma mark -- dealloc

- (void)dealloc
{
    [self clear];
}

@end
