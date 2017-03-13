//
//  TurnCardsLayout.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/23.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "TurnCardsLayout.h"

#define mCollectionViewHeight (self.collectionView.bounds.size.height)

@implementation TurnCardsLayout
{
    NSMutableArray *_attributesArray;
    
    NSInteger _numberOfSections;
    NSInteger _numberOfItemsInSection;
    CGFloat _rowHeight;
}

- (void)prepareLayout
{
    _numberOfSections = [self.collectionView numberOfSections];
    _numberOfItemsInSection = [self.collectionView numberOfItemsInSection:0];
    
    _rowHeight = mCollectionViewHeight / _numberOfSections;
    
    _attributesArray = [NSMutableArray new];
    for (int i = 0; i < _numberOfSections; i ++)
    {
        for (int j = 0; j < _numberOfItemsInSection; j++)
        {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            [_attributesArray addObject:attributes];
        }
    }
}

- (CGSize)collectionViewContentSize
{
    
    return CGSizeMake(kDeviceWidth, mCollectionViewHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake((kDeviceWidth / _numberOfItemsInSection) * indexPath.row,
                                  _rowHeight * indexPath.section,
                                  kDeviceWidth / _numberOfItemsInSection,
                                  _rowHeight);
    
    return attributes;
}

@end
