//
//  LPBar_3Controller.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/13.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LPBar_3Controller.h"

#define kSquareSpace 1.0f
#define kSquareWidth 16.6f
#define kSquareHeight 6.6f
#define kNumberOfLights 5
#define kAnimationDurationForBar 0.3f

@interface LPBar_3Controller ()

@end

@implementation LPBar_3Controller
{
    UIView *_progressBar;
    NSMutableArray *_squaresForBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
    [self startAnimation];
}

- (void)initializeBaseData
{
    _squaresForBar = [NSMutableArray new];
}

- (void)initializeUIComponents
{
    _progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 99.0f, kDeviceWidth, kSquareHeight)];
    _progressBar.backgroundColor = [UIColor whiteColor];
    
    int numberOfSquaresInRow = (kDeviceWidth - kSquareSpace) / (kSquareSpace + kSquareWidth);
    float adjustSpaceForCenter = ((kDeviceWidth - kSquareSpace) - ((kSquareSpace + kSquareWidth) * numberOfSquaresInRow)) / 2.0f;
    
    UIView *theView;
    for (int i = 0; i < numberOfSquaresInRow; i ++)
    {
        theView = [UIView new];
        theView.frame = CGRectMake(adjustSpaceForCenter + kSquareSpace + (i * (kSquareWidth + kSquareSpace)), 0, kSquareWidth, kSquareHeight);
        theView .backgroundColor = kRandomColor;
        theView.alpha = 0;
        
        [_squaresForBar addObject:theView];
        [_progressBar addSubview:theView];
    }
    
    [self.view addSubview:_progressBar];
    
}

- (void)startAnimation
{
    UIView *theView;
    for (int i = 0; i < _squaresForBar.count; i++)
    {
        theView = _squaresForBar[i];
        [UIView animateWithDuration:kAnimationDurationForBar delay:(kAnimationDurationForBar * i) options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            theView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            if (i >= kNumberOfLights)
            {
                [UIView animateWithDuration:kAnimationDurationForBar animations:^{
                    
                    ((UIView *)_squaresForBar[i - kNumberOfLights]).alpha = 0;
                }];
            }
            
            if (i == (_squaresForBar.count - 1))
            {
                for (int j = 0; j < kNumberOfLights; j++)
                {
                    [UIView animateWithDuration:kAnimationDurationForBar delay:(kAnimationDurationForBar * j) options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        ((UIView *)_squaresForBar[_squaresForBar.count - (kNumberOfLights - j)]).alpha = 0;
                        
                    } completion:nil];
                }
                
                [self performSelector:@selector(resetProgressBar) withObject:nil afterDelay:kNumberOfLights * kAnimationDurationForBar];
            }
            
        }];
    }
}

- (void)resetProgressBar
{
    for (UIView *theView in _squaresForBar)
    {
        theView.alpha = 0;
        theView.backgroundColor = kRandomColor;
    }
    [self startAnimation];
}
@end
