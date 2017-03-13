//
//  DragDownRefreshController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/2.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "DragDownRefreshController.h"
#import "DDR_RefreshView.h"

@interface DragDownRefreshController ()

@end

@implementation DragDownRefreshController
{
    DDR_RefreshView *_refreshView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData];
    [self initializeUIComponents];
}

- (void)initializeData
{
    
}

- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
    _refreshView = kInstanceFromXib(@"DDR_RefreshView");
    [_refreshView setFrame:CGRectMake(0.f, 0.f, self.tableView.frame.size.width, 0.f)];
    [self.tableView addSubview:_refreshView];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [_refreshView setFrame:CGRectMake(0.f, 0.f, self.tableView.frame.size.width, self.tableView.contentOffset.y)];
}


- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

@end





