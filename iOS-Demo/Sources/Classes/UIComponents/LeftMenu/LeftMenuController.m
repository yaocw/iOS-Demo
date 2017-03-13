//
//  LeftMenuController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/5.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LeftMenuController.h"
#import "LeftMenuView.h"
#import "MainContentView.h"

@interface LeftMenuController () <UIScrollViewDelegate>

@end

@implementation LeftMenuController
{
    UIScrollView *_mainScrollView;
    
    LeftMenuView *_firstLevelView;
    MainContentView *_secondLevelView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initUIComponents];
}

- (void)initUIComponents
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _mainScrollView.backgroundColor = [UIColor lightGrayColor];
    _mainScrollView.delegate = self;
    
    _mainScrollView.contentSize = CGSizeMake(kDeviceWidth * 2 - 66, 0);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.alwaysBounceHorizontal = YES;
    [self.view addSubview:_mainScrollView];
    
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"LeftMenuView" owner:nil options:nil];
    _firstLevelView = [nibContents lastObject];
    _firstLevelView.frame = CGRectMake(0, 0, kDeviceWidth - 66, kDeviceHeight);
    _firstLevelView.backgroundColor = [UIColor orangeColor];
    [_mainScrollView addSubview:_firstLevelView];
    
    
    nibContents = [[NSBundle mainBundle] loadNibNamed:@"MainContentView" owner:nil options:nil];
    _secondLevelView = [nibContents lastObject];
    _secondLevelView.frame = CGRectMake(kDeviceWidth - 66, 0, kDeviceWidth, kDeviceHeight);
    _secondLevelView.layer.shadowOpacity = 0.5;
    _secondLevelView.layer.shadowColor = [UIColor grayColor].CGColor;
    _secondLevelView.layer.shadowRadius = 5;
    _secondLevelView.layer.shadowOffset = CGSizeMake(1, 1);
    [_mainScrollView addSubview:_secondLevelView];
    
    
    _mainScrollView.contentOffset = CGPointMake(kDeviceWidth - 66, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0) {
        _firstLevelView.frame = CGRectMake(scrollView.contentOffset.x, 0, kDeviceWidth - 66, kDeviceHeight);
        _secondLevelView.frame = CGRectMake(scrollView.contentOffset.x + kDeviceWidth - 66, _secondLevelView.frame.origin.y, _secondLevelView.bounds.size.width, _secondLevelView.bounds.size.height);
        
    } else {
        
        if (scrollView.contentOffset.x > (kDeviceWidth - 66)) {
            
            _firstLevelView.frame = CGRectMake(scrollView.contentOffset.x - (kDeviceWidth - 66), 0, kDeviceWidth - 66, kDeviceHeight);
            _secondLevelView.frame = CGRectMake(scrollView.contentOffset.x, 0, kDeviceWidth, kDeviceHeight);
            
        } else {
            _secondLevelView.bounds = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + (scrollView.contentOffset.x - kDeviceWidth + 66) / 3.0);
        }
    }
}


@end
