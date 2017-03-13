//
//  MyCollectionViewLayout.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/21.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MyCollectionViewLayout.h"

@implementation MyCollectionViewLayout
{
    NSMutableArray *_attributesArray;
}

- (void)prepareLayout
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    _attributesArray = [NSMutableArray new];
    
    for (int i = 0; i < itemCount; i++)
    {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [_attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize
{
    
    return CGSizeMake(kDeviceWidth, (_attributesArray.count / 3.0f) * 60.0f);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(((kDeviceWidth / 3.0) * (indexPath.row % 3)),
                                  60.0f * (indexPath.row / 3),
                                  kDeviceWidth / 3.0,
                                  60.0f);
    
    return attributes;
}

@end
