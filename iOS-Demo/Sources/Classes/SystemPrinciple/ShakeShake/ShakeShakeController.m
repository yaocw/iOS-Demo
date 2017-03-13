//
//  ShakeShakeController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/20.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ShakeShakeController.h"

#import <AVFoundation/AVFoundation.h>

#define kMainViewHeight (kDeviceHeight - 64.0f)

@interface ShakeShakeController ()

@end

@implementation ShakeShakeController
{
    __weak IBOutlet UIImageView *_upImageView;
    __weak IBOutlet UIImageView *_downImageView;
    
    
    AVPlayer *_player;
    BOOL _isHandlingShake;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    
    [_player pause];
    _player = nil;
}

- (void)initializeUIComponents
{
    _upImageView.frame = CGRectMake(0, 64.0f, kDeviceWidth, kMainViewHeight/2.0f);
    _downImageView.frame = CGRectMake(0, kMainViewHeight/2.0f + 64.0f, kDeviceWidth, kMainViewHeight/2.0f);
    
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playSound
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shake_shake" ofType:@"mp3"]]];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    [_player play];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playAnimation
{
    [UIView animateWithDuration:0.58f animations:^{
        
        _upImageView.frame = CGRectMake(0, -(kDeviceHeight/2.0f) + 172.0f, kDeviceWidth, kMainViewHeight/2.0f);
        _downImageView.frame = CGRectMake(0, kMainViewHeight - 64.0f, kDeviceWidth, kMainViewHeight/2.0f);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.58f animations:^{
            
            _upImageView.frame = CGRectMake(0, 64.0f, kDeviceWidth, kMainViewHeight/2.0f);
            _downImageView.frame = CGRectMake(0, kMainViewHeight/2.0f + 64.0f, kDeviceWidth, kMainViewHeight/2.0f);
        }];
        
    }];
}

- (void)playerItemDidReachEnd:(id)sender
{
    _isHandlingShake = NO;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake && !_isHandlingShake)
    {
        _isHandlingShake = YES;
        [self playSound];
        [self playAnimation];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
//        NSLog(@"cancel shake ...");
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
//        NSLog(@"End shake ...");
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
