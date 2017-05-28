//
//  RecognizeStaveController.m
//  iOS-Demo
//
//  Created by yaochaowen on 2017/5/27.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "RecognizeStaveController.h"
#import "StaveView.h"

#import <AVFoundation/AVFoundation.h>

#define mCenterLevelOfNotesForTrebleClef 14
#define mCenterLevelOfNotesForBassClef 16

@interface RecognizeStaveController ()

@property (weak, nonatomic) IBOutlet UIImageView *trebleClefImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bassClefImageView;

@property (weak, nonatomic) IBOutlet StaveView *staveView;
@property (weak, nonatomic) IBOutlet UILabel *noteLevelLabel;

@property (weak, nonatomic) IBOutlet UIView *practiseModeOptView;
@property (weak, nonatomic) IBOutlet UIView *testModeOptView;

@property (weak, nonatomic) IBOutlet UIButton *showResultButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *divideThreePartsSegControl;

@end

@implementation RecognizeStaveController
{
    BOOL _isUsingTrebleClef;
    BOOL _isUsingPractiseMode;
    
    NSMutableArray *_musicalSounds;
    
    AVPlayer *_player;
    
    NSInteger _previousNoteLevel;
    NSInteger _currentNoteLevel;
    
    UIButton *_previousAnswerButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    _isUsingTrebleClef = YES;
    _isUsingPractiseMode = YES;
    _previousNoteLevel = 1;
    
    [self loadTheMusicalSounds];
    
    _practiseModeOptView.hidden = NO;
    _testModeOptView.hidden = YES;
    
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
    tempButton.tag = 3;
    [self nextNoteAction:tempButton];
}


#pragma mark -- Actions

- (IBAction)nextNoteAction:(UIButton *)sender
{
    if (!_isUsingPractiseMode)
    {
        _showResultButton.hidden = NO;
        _resultLabel.hidden = YES;
        
        if (_previousAnswerButton)
        {
            _previousAnswerButton.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    NSInteger centerLevelOfNotes = 0;
    if (_isUsingTrebleClef)
    {
        centerLevelOfNotes = mCenterLevelOfNotesForTrebleClef;
    }
    else
    {
        centerLevelOfNotes = mCenterLevelOfNotesForBassClef;
    }
    
    switch (sender.tag)
    {
        case 0:
        {
            _currentNoteLevel = _previousNoteLevel;
            break;
        }
            
        case 1:
        {
            _currentNoteLevel = _previousNoteLevel + 1;
            
            if (_divideThreePartsSegControl.selectedSegmentIndex == 0)
            {
                _currentNoteLevel > 29 ? (_currentNoteLevel = 29) : _currentNoteLevel;
            }
            else if (_divideThreePartsSegControl.selectedSegmentIndex == 1)
            {
                _currentNoteLevel > (centerLevelOfNotes - 5) ? (_currentNoteLevel = centerLevelOfNotes - 5) : _currentNoteLevel;
            }
            else if (_divideThreePartsSegControl.selectedSegmentIndex == 2)
            {
                _currentNoteLevel > (centerLevelOfNotes + 4) ? (_currentNoteLevel = centerLevelOfNotes + 4) : _currentNoteLevel;
            }
            else
            {
                _currentNoteLevel > 29 ? (_currentNoteLevel = 29) : _currentNoteLevel;
            }
            
            break;
        }
            
        case 2:
        {
            _currentNoteLevel = _previousNoteLevel - 1;
            
            if (_divideThreePartsSegControl.selectedSegmentIndex == 0)
            {
                _currentNoteLevel < (centerLevelOfNotes + 5) ? (_currentNoteLevel = centerLevelOfNotes + 5) : _currentNoteLevel;
            }
            else if (_divideThreePartsSegControl.selectedSegmentIndex == 1)
            {
                _currentNoteLevel < 1 ? (_currentNoteLevel = 1) : _currentNoteLevel;
            }
            else if (_divideThreePartsSegControl.selectedSegmentIndex == 2)
            {
                _currentNoteLevel < (centerLevelOfNotes - 4) ? (_currentNoteLevel = centerLevelOfNotes - 4) : _currentNoteLevel;
            }
            else
            {
                _currentNoteLevel < 1 ? (_currentNoteLevel = 1) : _currentNoteLevel;
            }
            
            break;
        }
            
        case 3:
        {
            if (_divideThreePartsSegControl.selectedSegmentIndex == 0)
            {
                _currentNoteLevel = kGetRandomIntWithLimit(centerLevelOfNotes + 4, _musicalSounds.count + 1);
            }
            else if (_divideThreePartsSegControl.selectedSegmentIndex == 1)
            {
                _currentNoteLevel = kGetRandomIntWithLimit(0, centerLevelOfNotes - 4);
            }
            else if (_divideThreePartsSegControl.selectedSegmentIndex == 2)
            {
                _currentNoteLevel = kGetRandomIntWithLimit(centerLevelOfNotes - 5, centerLevelOfNotes + 5);
            }
            else
            {
                _currentNoteLevel = kGetRandomIntWithLimit(0, _musicalSounds.count + 1);
            }
            
            break;
        }
            
        default:
            break;
    }
    
    _previousNoteLevel = _currentNoteLevel;
    [self playSoundWithPath:_musicalSounds[_currentNoteLevel - 1]];
    
    
    NSString *noteLevelText;
    switch (_currentNoteLevel % 7) {
        case 0:
        {
            noteLevelText = @"Si - 7";
            break;
        }
            
        case 1:
        {
            noteLevelText = @"Do - 1";
            break;
        }
            
        case 2:
        {
            noteLevelText = @"Re - 2";
            break;
        }
            
        case 3:
        {
            noteLevelText = @"Mi - 3";
            break;
        }
            
        case 4:
        {
            noteLevelText = @"Fa - 4";
            break;
        }
            
        case 5:
        {
            noteLevelText = @"Sol - 5";
            break;
        }
            
        case 6:
        {
            noteLevelText = @"La - 6";
            break;
        }
        default:
            break;
    }
    _noteLevelLabel.text = noteLevelText;
    _resultLabel.text = noteLevelText;
    
    
    _staveView.noteLevel = _currentNoteLevel;
    [_staveView setNeedsDisplay];
}

- (void)playSoundWithPath:(NSString *)soundPath
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundPath ofType:@"mp3"]]];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    [_player play];
}

- (IBAction)showResultAction:(id)sender
{
    _showResultButton.hidden = YES;
    _resultLabel.hidden = NO;
}

- (IBAction)answerAction:(UIButton *)sender
{
    if (_previousAnswerButton)
    {
        _previousAnswerButton.backgroundColor = [UIColor lightGrayColor];
    }
    
    if (sender.tag == (_currentNoteLevel % 7))
    {
        [self playSoundWithPath:@"answer_right"];
        [self nextNoteForRandom];
    }
    else
    {
        sender.backgroundColor = kHexColor(@"FF6FCF");
        [self playSoundWithPath:@"answer_wrong"];
    }
    
    _previousAnswerButton = sender;
}



- (IBAction)switchClefAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        _isUsingTrebleClef = YES;
        
        _trebleClefImageView.hidden = NO;
        _bassClefImageView.hidden = YES;
    }
    else
    {
        _isUsingTrebleClef = NO;
        
        _trebleClefImageView.hidden = YES;
        _bassClefImageView.hidden = NO;
    }
    
    [self loadTheMusicalSounds];
    [self nextNoteForRandom];
}

- (IBAction)switchModeAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        _isUsingPractiseMode = YES;
        
        _practiseModeOptView.hidden = NO;
        _testModeOptView.hidden = YES;
        
        [self nextNoteForRandom];
    }
    else
    {
        _isUsingPractiseMode = NO;
        
        _practiseModeOptView.hidden = YES;
        _testModeOptView.hidden = NO;
        
        _showResultButton.hidden = NO;
        _resultLabel.hidden = YES;
        
        if (_previousAnswerButton)
        {
            _previousAnswerButton.backgroundColor = [UIColor lightGrayColor];
        }
        
        [self nextNoteForRandom];
    }
}

- (IBAction)divideThreePartsAction:(id)sender
{
    [self nextNoteForRandom];
}


#pragma mark -- dealloc

- (void)dealloc
{
    [_player pause];
}

@end
