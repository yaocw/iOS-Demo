//
//  MyCollectionViewLayoutCell.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/21.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MyCollectionViewLayoutCell.h"
#import "MyCollectionViewLayoutModel.h"

@implementation MyCollectionViewLayoutCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setModel:(MyCollectionViewLayoutModel *)model
{
    self.backgroundColor = model.backgroundColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   [UIView animateWithDuration:0.33f animations:^{
       
       
       [UIView animateWithDuration:0.33f animations:^{
           
           self.alpha = 0;
       }];
   } completion:^(BOOL finished) {
      
       [UIView animateWithDuration:0.33f animations:^{
           
           self.alpha = 1;
       }];
   }];
}

@end
