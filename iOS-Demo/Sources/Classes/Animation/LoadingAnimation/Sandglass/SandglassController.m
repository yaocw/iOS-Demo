//
//  SandglassController.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "SandglassController.h"

static CGFloat kMaxMaskHeight = 80.f;
static CGFloat kIncreaseStep = 0.5f;

@interface SandglassController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMaskHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMaskHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *sandglassView;

@end

@implementation SandglassController
{
    CADisplayLink *_displayLink;
    
    BOOL _flowDirectionFlag;  //yes表示正向，no 表示反向
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
    _topMaskHeightConstraint.constant = 0.f;
    _bottomMaskHeightConstraint.constant = kMaxMaskHeight;
}

- (void)initializeUIComponents
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)handleDisplayLink:(id)sender
{
    if (_flowDirectionFlag)
    {
        _topMaskHeightConstraint.constant -= kIncreaseStep;
        _bottomMaskHeightConstraint.constant += kIncreaseStep;
        
        if (_topMaskHeightConstraint.constant - kIncreaseStep <= 0.f)
        {
            _flowDirectionFlag = !_flowDirectionFlag;
            
            
            [UIView animateWithDuration:0.66f animations:^{
                
                CGAffineTransform transform = CGAffineTransformMakeRotation(0.f * M_PI / 180.f);
                _sandglassView.transform = transform;
            }];
        }
    }
    else
    {
        _topMaskHeightConstraint.constant += kIncreaseStep;
        _bottomMaskHeightConstraint.constant -= kIncreaseStep;
        
        if (_bottomMaskHeightConstraint.constant - kIncreaseStep <= 0.f)
        {
            _flowDirectionFlag = !_flowDirectionFlag;
            
            [UIView animateWithDuration:0.66f animations:^{
                
                CGAffineTransform transform = CGAffineTransformMakeRotation(180.f * M_PI / 180.f);
                _sandglassView.transform = transform;
            }];
        }
    }
}


@end






