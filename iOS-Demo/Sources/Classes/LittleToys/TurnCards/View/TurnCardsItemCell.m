//
//  TurnCardsItemCell.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/23.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "TurnCardsItemCell.h"
#import "TurnCardsModel.h"

#define mAnimationDuration 0.66f

@implementation TurnCardsItemCell
{
    NSTimer *_timer;
    
    BLKBlock _finishedShowRealColorBlock;
    BLKBlock _finishedHideRealColorBlock;
    BLKBlock _finishedNotMatchingAnimationBlock;
    BLKBlock _finishedDemolishedAnimationBlock;
    
    TurnCardsModel *_model;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.masksToBounds = YES;
}

- (void)setModel:(TurnCardsModel *)model
{
    _model = model;
    
    if (model.isDemolished)
    {   
        self.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
}





- (void)finishedShowRealColorBlock:(BLKBlock)aBlock
{
    _finishedShowRealColorBlock = aBlock;
}


- (void)showRealColorAnimation
{
    [UIView animateWithDuration:mAnimationDuration animations:^{
        
        self.layer.transform = CATransform3DMakeRotation(M_PI * 0.5f, 0, 1, 0);
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = _model.realColor;
        
        [UIView animateWithDuration:mAnimationDuration animations:^{
            
            self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            
        } completion:^(BOOL finished) {
            
            _finishedShowRealColorBlock ? _finishedShowRealColorBlock() : nil;
        }];
    }];
}


- (void)finishedHideRealColorBlock:(BLKBlock)aBlock
{
    _finishedHideRealColorBlock = aBlock;
}

- (void)hideRealColorAnimation
{
    [UIView animateWithDuration:mAnimationDuration animations:^{
        
        self.layer.transform = CATransform3DMakeRotation(M_PI * 0.5f, 0, 1, 0);
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [UIView animateWithDuration:mAnimationDuration animations:^{
            
            self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            
        } completion:^(BOOL finished) {
            
            _finishedHideRealColorBlock ? _finishedHideRealColorBlock() : nil;
        }];
    }];
}


- (void)finishedNotMatchingAnimationBlock:(BLKBlock)aBlock
{
    _finishedNotMatchingAnimationBlock = aBlock;
}

- (void)lanchingNotMatchingAnimation
{
    [UIView animateWithDuration:mAnimationDuration animations:^{
        
        self.layer.transform = CATransform3DMakeRotation(M_PI * 0.5f, 0, 1, 0);
        
    } completion:^(BOOL finished) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [UIView animateWithDuration:mAnimationDuration animations:^{
            
            self.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            
        } completion:^(BOOL finished) {
            
            _finishedNotMatchingAnimationBlock ? _finishedNotMatchingAnimationBlock() : nil;
        }];
    }];
}



- (void)finishedDemolishedAnimationBlock:(BLKBlock)aBlock
{
    _finishedDemolishedAnimationBlock = aBlock;
}

- (void)lanchingDemolishedAnimation
{
    [UIView animateWithDuration:mAnimationDuration animations:^{
        
        self.backgroundColor = [UIColor whiteColor];
        
    } completion:^(BOOL finished) {
        
        _finishedDemolishedAnimationBlock ? _finishedDemolishedAnimationBlock() : nil;
    }];
}

@end
