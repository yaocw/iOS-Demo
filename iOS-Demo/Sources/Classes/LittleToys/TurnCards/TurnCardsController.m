//
//  TurnCardsController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/23.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "TurnCardsController.h"
#import "TurnCardsItemCell.h"
#import "TurnCardsLayout.h"
#import "TurnCardsModel.h"
#import "TCGameOverView.h"

#define mNumberOfSections 3
#define mNumberOfItemsInSection 4

#define mTurnCardsItemCellIdentifier @"TurnCardsItemCell"

@interface TurnCardsController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TurnCardsController
{
    NSMutableArray *_cardModels;

    TurnCardsModel *_theFirstModel;
    TurnCardsModel *_theSecondModel;
    TurnCardsItemCell *_theFirstCell;
    TurnCardsItemCell *_theSecondCell;
    
    BOOL _isMatchFailureAnimating;
    BOOL _isDemolishedAnimating;
    
    NSUInteger _numberOfDemolished;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)initializeBaseData
{
    NSMutableArray *realColors = [NSMutableArray new];
    UIColor *randomColor;
    for (int i = 0; i < (mNumberOfSections * mNumberOfItemsInSection) / 2; i ++)
    {
        randomColor = kRandomColor;
        [realColors addObject:randomColor];
        [realColors addObject:randomColor];
    }
    
    
    _cardModels = [NSMutableArray new];
    
    NSMutableArray *theMutArr;
    int randomColorIndex;
    for (int i = 0; i < mNumberOfItemsInSection; i ++)
    {
        theMutArr = [NSMutableArray new];
        for (int j = 0; j < mNumberOfSections; j++)
        {
            TurnCardsModel *model = [TurnCardsModel new];
            model.isShowedTheRealColor = NO;
            model.isDemolished = NO;

            randomColorIndex = kGetRandomIntWithUpperLimit(realColors.count);
            model.realColor = realColors[randomColorIndex];
            [realColors removeObjectAtIndex:randomColorIndex];
            
            
            [theMutArr addObject:model];
        }
        
        [_cardModels addObject:theMutArr];
    }
}

- (void)initializeUIComponents
{
    TurnCardsLayout *turnCardsLayout = [TurnCardsLayout new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.0f, kDeviceWidth, kDeviceHeight - 64.0f) collectionViewLayout:turnCardsLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"TurnCardsItemCell" bundle:nil] forCellWithReuseIdentifier:mTurnCardsItemCellIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = UIEdgeInsetsZero;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

#pragma mark -- UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return mNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mNumberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TurnCardsItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mTurnCardsItemCellIdentifier forIndexPath:indexPath];
    TurnCardsModel *model = _cardModels[indexPath.row][indexPath.section];
    [cell setModel:model];
    
    return cell;
}

#pragma mark -- UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TurnCardsModel *model = _cardModels[indexPath.row][indexPath.section];
    
    if (!model.isDemolished)
    {
        if (!_isMatchFailureAnimating && !_isDemolishedAnimating)
        {
            model.isShowedTheRealColor = !model.isShowedTheRealColor;
            
            if (_theFirstModel == nil && _theSecondModel == nil)
            {
                _theFirstModel = model;
                
                _theFirstCell = (TurnCardsItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
                [_theFirstCell showRealColorAnimation];
            }
            else if (_theFirstModel != nil && _theSecondModel == nil && !model.isShowedTheRealColor)
            {
                _isMatchFailureAnimating = YES;
                
                _theFirstModel = model;
                
                _theFirstCell = (TurnCardsItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
                [_theFirstCell finishedHideRealColorBlock:^{
                    
                    _theFirstModel = nil;
                    _isMatchFailureAnimating = NO;
                }];
                [_theFirstCell hideRealColorAnimation];
                
            }
            else if (_theFirstModel != nil && _theSecondModel == nil)
            {
                _theSecondModel = model;
                _theSecondCell = (TurnCardsItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
                
                [_theSecondCell finishedShowRealColorBlock:^{
                    
                    if (CGColorEqualToColor(_theFirstModel.realColor.CGColor, _theSecondModel.realColor.CGColor))
                    {
                        _numberOfDemolished += 2;
                        
                        
                        if (_numberOfDemolished == (mNumberOfSections * mNumberOfItemsInSection))
                        {
                            TCGameOverView *gameOverView = kInstanceFromXib(@"TCGameOverView");
                            gameOverView.frame = CGRectMake(0, 0, 0, 0);
                            gameOverView.alpha = 0.0f;
                            [gameOverView dissmissViewBlock:^{
                                
                                [self restartAction:nil];
                            }];
                            [kWindow addSubview:gameOverView];
                            
                            [UIView animateWithDuration:0.66f animations:^{
                                
                                gameOverView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
                                gameOverView.alpha = 1.0f;
                            }];
                        }
                        else
                        {
                            
                            _isDemolishedAnimating = YES;
                            
                            _theFirstModel.isDemolished = YES;
                            [_theFirstCell lanchingDemolishedAnimation];
                            
                            
                            _theSecondModel.isDemolished = YES;
                            [_theSecondCell finishedDemolishedAnimationBlock:^{
                                
                                _theFirstModel = nil;
                                [_theFirstCell finishedShowRealColorBlock:nil];
                                [_theFirstCell finishedHideRealColorBlock:nil];
                                
                                _theSecondModel = nil;
                                [_theSecondCell finishedShowRealColorBlock:nil];
                                [_theSecondCell finishedHideRealColorBlock:nil];
                                [_theSecondCell finishedNotMatchingAnimationBlock:nil];
                                
                                _isDemolishedAnimating = NO;
                                
                            }];
                            [_theSecondCell lanchingDemolishedAnimation];
                        }
                    }
                    else
                    {
                        _theFirstModel.isShowedTheRealColor = NO;
                        [_theFirstCell lanchingNotMatchingAnimation];
                        
                        
                        _theSecondModel.isShowedTheRealColor = NO;
                        [_theSecondCell finishedNotMatchingAnimationBlock:^{
                            
                            _theFirstModel = nil;
                            [_theFirstCell finishedShowRealColorBlock:nil];
                            [_theFirstCell finishedHideRealColorBlock:nil];
                            
                            _theSecondModel = nil;
                            [_theSecondCell finishedShowRealColorBlock:nil];
                            [_theSecondCell finishedHideRealColorBlock:nil];
                            [_theSecondCell finishedDemolishedAnimationBlock:nil];
                        }];
                        
                        [_theSecondCell lanchingNotMatchingAnimation];
                    }
                }];
                
                [_theSecondCell showRealColorAnimation];
            }
            else
            {
                model.isShowedTheRealColor = !model.isShowedTheRealColor;
            }
        }
    }
}

- (IBAction)restartAction:(id)sender
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    
    _theFirstModel = nil;
    _theFirstCell = nil;
    
    _theSecondModel = nil;
    _theSecondCell = nil;
    
    _isMatchFailureAnimating = NO;
    
    _numberOfDemolished = 0;
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

@end
