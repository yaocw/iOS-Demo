//
//  MyCollectionViewLayoutController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/21.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MyCollectionViewLayoutController.h"
#import "MyCollectionViewLayoutCell.h"
#import "MyCollectionViewLayout.h"
#import "MyCollectionViewLayoutModel.h"

#define mMyCollectionViewLayoutCellIdentifier @"MyCollectionViewLayoutCell"

@interface MyCollectionViewLayoutController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MyCollectionViewLayoutController

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
    MyCollectionViewLayout *myCollectionViewLayout = [MyCollectionViewLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) collectionViewLayout:myCollectionViewLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewLayoutCell" bundle:nil] forCellWithReuseIdentifier:mMyCollectionViewLayoutCellIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = UIEdgeInsetsZero;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

#pragma mark -- UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 90;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mMyCollectionViewLayoutCellIdentifier forIndexPath:indexPath];
    MyCollectionViewLayoutModel *model = [MyCollectionViewLayoutModel new];
    model.backgroundColor = kRandomColor;
    
    [cell setModel:model];
    
    return cell;
}


@end
