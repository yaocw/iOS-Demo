//
//  LPBar_4Controller.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/13.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LPBar_4Controller.h"
#import "LPBar_4PopUpView.h"

#define kAnimationDuration 1.0f

@interface LPBar_4Controller ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation LPBar_4Controller
{
    UIView *_progressBar1;
    CAGradientLayer *_gradientLayerForBar1;
    UIView *_grayMaskView;
    
    UIView *_progressBar2;
    CAGradientLayer *_gradientLayerForBar2;
    
    NSTimer *_timer;
    float _progressBot;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    _startButton.backgroundColor = kRandomColor;
    
    
    
    
    _progressBar1 = [UIView new];
    _progressBar1.frame = CGRectMake(0, kDeviceHeight / 2.0, kDeviceWidth, 6.6f);
    [self.view addSubview:_progressBar1];
    
    _gradientLayerForBar1 = [CAGradientLayer layer];
    _gradientLayerForBar1.colors = @[(__bridge id)kRandomColor.CGColor, (__bridge id)kRandomColor.CGColor];
    _gradientLayerForBar1.locations = @[@0.0, @1.0];
    _gradientLayerForBar1.startPoint = CGPointMake(0, 0);
    _gradientLayerForBar1.endPoint = CGPointMake(1.0, 0);
    _gradientLayerForBar1.frame = CGRectMake(0, 0, kDeviceWidth, 6.6f);
    [_progressBar1.layer addSublayer:_gradientLayerForBar1];
    
    _grayMaskView = [UIView new];
    _grayMaskView.backgroundColor = [UIColor grayColor];
    _grayMaskView.frame = CGRectMake(0, 0, kDeviceWidth, 6.6f);
    [_progressBar1 addSubview:_grayMaskView];
    
    
    
    
    _progressBar2 = [UIView new];
    _progressBar2.frame = CGRectMake(0, kDeviceHeight / 2.0 - 66.0f, kDeviceWidth, 6.6f);
    [self.view addSubview:_progressBar2];
    
    _gradientLayerForBar2 = [CAGradientLayer layer];
    _gradientLayerForBar2.colors = @[(__bridge id)[UIColor orangeColor].CGColor, (__bridge id)[UIColor orangeColor].CGColor, (__bridge id)[UIColor grayColor].CGColor, (__bridge id)[UIColor grayColor].CGColor];
    _gradientLayerForBar2.locations = @[@0.0, @0.0, @0.0, @0.0];
    _gradientLayerForBar2.startPoint = CGPointMake(0, 0);
    _gradientLayerForBar2.endPoint = CGPointMake(1.0, 0);
    _gradientLayerForBar2.frame = CGRectMake(0, 0, kDeviceWidth, 6.6f);
    [_progressBar2.layer addSublayer:_gradientLayerForBar2];
    
    
    
    LPBar_4PopUpView *theView = [[LPBar_4PopUpView alloc] initWithFrame:CGRectMake(0, 100, 100.0f, 100.0f)];
    [self.view addSubview:theView];
    
}

- (void)startAnimationForBar1
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        CGRect frame = _grayMaskView.frame;
        frame.size.width = 0;
        frame.origin.x = kDeviceWidth;
        _grayMaskView.frame = frame;
        
    }];
}

- (void)startAnimationForBar2
{
    if (_progressBot >= 1.0)
    {
        [_timer invalidate];
    }
    else
    {
        _progressBot = _progressBot + 0.1f;
    }

    _gradientLayerForBar2.locations = @[@0.0, @(_progressBot), @(_progressBot), @1.0];

}

- (IBAction)resetAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"开始"])
    {
        [sender setTitle:@"重置" forState:UIControlStateNormal];
        
        CGRect frame = _grayMaskView.frame;
        frame.size.width = kDeviceWidth;
        frame.origin.x = 0;
        _grayMaskView.frame = frame;
        [self startAnimationForBar1];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(startAnimationForBar2) userInfo:nil repeats:YES];
    }
    else
    {
        [sender setTitle:@"开始" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect frame = _grayMaskView.frame;
            frame.size.width = kDeviceWidth;
            frame.origin.x = 0;
            _grayMaskView.frame = frame;
            
        } completion:^(BOOL finished) {
            
            _gradientLayerForBar1.colors = @[(__bridge id)kRandomColor.CGColor, (__bridge id)kRandomColor.CGColor];
            
        }];
        
        
        _progressBot = 0;
        _gradientLayerForBar2.locations = @[@0.0, @0.0, @0.0, @0.0];
        [_timer invalidate];
    }
}


- (void)dealloc
{
    [_timer invalidate];
}

@end
