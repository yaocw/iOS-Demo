//
//  HillsViewController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "HillsViewController.h"

static CGFloat kMaxHillHeight = 100.f;
static CGFloat kMinHillHeight = 20.f;

static CGFloat kIncreaseStep = 2.5f;

@interface HillsViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hill1HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hill2HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hill3HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hill4HeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hill5HeightConstraint;

@end

@implementation HillsViewController
{
    CADisplayLink *_displayLink;
    
    CGFloat _maxHill1Height;
    CGFloat _maxHill2Height;
    CGFloat _maxHill3Height;
    CGFloat _maxHill4Height;
    CGFloat _maxHill5Height;
    
    BOOL _hill1DirectionFlag;
    BOOL _hill2DirectionFlag;
    BOOL _hill3DirectionFlag;
    BOOL _hill4DirectionFlag;
    BOOL _hill5DirectionFlag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_displayLink invalidate];
}

- (void)initializeBaseData
{
    _maxHill1Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
    _maxHill2Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
    _maxHill3Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
    _maxHill4Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
    _maxHill5Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
}

- (void)initializeUIComponents
{
    _hill1HeightConstraint.constant = _maxHill1Height;
    _hill2HeightConstraint.constant = _maxHill2Height;
    _hill3HeightConstraint.constant = _maxHill3Height;
    _hill4HeightConstraint.constant = _maxHill4Height;
    _hill5HeightConstraint.constant = _maxHill5Height;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(id)sender
{
    if (_hill1DirectionFlag)
    {
        _hill1HeightConstraint.constant += kIncreaseStep;
        
        if (_hill1HeightConstraint.constant + kIncreaseStep >= _maxHill1Height) {
            _hill1DirectionFlag = !_hill1DirectionFlag;
        }
    }
    else
    {
        _hill1HeightConstraint.constant -= kIncreaseStep;
        if (_hill1HeightConstraint.constant - kIncreaseStep <= kMinHillHeight) {
            _hill1DirectionFlag = !_hill1DirectionFlag;
            _maxHill1Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
        }
    }
    
    
    
    
    
    
    
    if (_hill2DirectionFlag)
    {
        _hill2HeightConstraint.constant += kIncreaseStep;
        
        if (_hill2HeightConstraint.constant + kIncreaseStep >= _maxHill2Height) {
            _hill2DirectionFlag = !_hill2DirectionFlag;
        }
    }
    else
    {
        _hill2HeightConstraint.constant -= kIncreaseStep;
        if (_hill2HeightConstraint.constant - kIncreaseStep <= kMinHillHeight) {
            _hill2DirectionFlag = !_hill2DirectionFlag;
            _maxHill2Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
        }
    }
    
    
    
    
    
    
    
    if (_hill3DirectionFlag)
    {
        _hill3HeightConstraint.constant += kIncreaseStep;
        
        if (_hill3HeightConstraint.constant + kIncreaseStep >= _maxHill3Height) {
            _hill3DirectionFlag = !_hill3DirectionFlag;
        }
    }
    else
    {
        _hill3HeightConstraint.constant -= kIncreaseStep;
        if (_hill3HeightConstraint.constant - kIncreaseStep <= kMinHillHeight) {
            _hill3DirectionFlag = !_hill3DirectionFlag;
            _maxHill3Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
        }
    }
    
    
    
    
    
    
    if (_hill4DirectionFlag)
    {
        _hill4HeightConstraint.constant += kIncreaseStep;
        
        if (_hill4HeightConstraint.constant + kIncreaseStep >= _maxHill4Height) {
            _hill4DirectionFlag = !_hill4DirectionFlag;
        }
    }
    else
    {
        _hill4HeightConstraint.constant -= kIncreaseStep;
        if (_hill4HeightConstraint.constant - kIncreaseStep <= kMinHillHeight) {
            _hill4DirectionFlag = !_hill4DirectionFlag;
            _maxHill4Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
        }
    }
    
    
    
    
    
    
    if (_hill5DirectionFlag)
    {
        _hill5HeightConstraint.constant += kIncreaseStep;
        
        if (_hill5HeightConstraint.constant + kIncreaseStep >= _maxHill5Height) {
            _hill5DirectionFlag = !_hill5DirectionFlag;
        }
    }
    else
    {
        _hill5HeightConstraint.constant -= kIncreaseStep;
        if (_hill5HeightConstraint.constant - kIncreaseStep <= kMinHillHeight) {
            _hill5DirectionFlag = !_hill5DirectionFlag;
            _maxHill5Height = kGetRandomFloatWithLimit(kMinHillHeight + 50.f, kMaxHillHeight);
        }
    }
}

@end






