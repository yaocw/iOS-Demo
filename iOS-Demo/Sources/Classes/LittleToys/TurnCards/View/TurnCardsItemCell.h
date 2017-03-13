//
//  TurnCardsItemCell.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/23.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurnCardsItemCell : UICollectionViewCell

- (void)setModel:(id)model;

- (void)showRealColorAnimation;
- (void)finishedShowRealColorBlock:(BLKBlock)aBlock;

- (void)hideRealColorAnimation;
- (void)finishedHideRealColorBlock:(BLKBlock)aBlock;

- (void)lanchingNotMatchingAnimation;
- (void)finishedNotMatchingAnimationBlock:(BLKBlock)aBlock;

- (void)lanchingDemolishedAnimation;
- (void)finishedDemolishedAnimationBlock:(BLKBlock)aBlock;


@end
