//
//  ScrollAnimation_1Controller.m
//  iOS-Demo
//
//  Created by 姚朝文(外包) on 2017/4/12.
//  Copyright © 2017年 yaocw. All rights reserved.
//

#import "ScrollAnimation_1Controller.h"

#import "SACircleView.h"

static CGFloat kAnimationDuration = 0.66f;

@interface ScrollAnimation_1Controller () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *leverView;

@end

@implementation ScrollAnimation_1Controller
{
    NSMutableArray *_theViews;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    _theViews = [NSMutableArray new];
}

- (void)initializeUIComponents
{
    SACircleView *theCircleView = nil;
    UIView *theView = nil;
    for (int i = 0; i < 3; i ++)
    {
        theCircleView = kInstanceFromXib(@"SACircleView");
        theCircleView.titleLabel.text = [NSString stringWithFormat:@"%d", i];
        theCircleView.backgroundColor = kRandomColor;
        theCircleView.bounds = CGRectMake(0.f, 0.f, kDeviceWidth - 64.f, kDeviceWidth - 64.f);
        theCircleView.center = CGPointMake(kDeviceWidth / 2.f, kDeviceHeight / 2.f - 32.f);
        theCircleView.layer.cornerRadius = (kDeviceWidth - 64.f) / 2.f;
        theCircleView.layer.masksToBounds = YES;
        
        theView = [UIView new];
        theView.frame = CGRectMake(kDeviceWidth * i, 0.f, kDeviceWidth, kDeviceHeight);
        [theView addSubview:theCircleView];
        
        [_theViews addObject:theView];
        [_scrollView addSubview:theView];
    }
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kDeviceWidth * 3.f, 0.f);
    _scrollView.contentOffset = CGPointMake(kDeviceWidth, 0.f);
    _scrollView.delegate = self;
    
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(10.f * M_PI / 180.f);
    _leverView.transform = transform;
}

- (void)resetScrollViewContent
{
    UIView *theView = nil;
    for (int i = 0; i < _theViews.count; i ++)
    {
        theView = _theViews[i];
        theView.frame = CGRectMake(kDeviceWidth * i, 0.f, kDeviceWidth, kDeviceHeight);
    }
    
    _scrollView.contentOffset = CGPointMake(kDeviceWidth, -64.f);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(45.f * M_PI / 180.f);
        _leverView.transform = transform;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < (kDeviceWidth - 1.f))
    {
        UIView *theLastView = _theViews.lastObject;
        [_theViews removeLastObject];
        [_theViews insertObject:theLastView atIndex:0];
        
        [self resetScrollViewContent];
    }
    else if (scrollView.contentOffset.x > (kDeviceWidth + 1.f)) {
        UIView *theFirstView = _theViews.firstObject;
        [_theViews removeObjectAtIndex:0];
        [_theViews addObject:theFirstView];
        
        [self resetScrollViewContent];
    }
    
    _scrollView.scrollEnabled = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _scrollView.scrollEnabled = NO;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(10.f * M_PI / 180.f);
        _leverView.transform = transform;
    }];
}



@end
