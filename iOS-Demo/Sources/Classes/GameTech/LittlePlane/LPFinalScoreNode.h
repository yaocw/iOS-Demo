//
//  LPFinalScoreNode.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/10.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface LPFinalScoreNode : SKSpriteNode

@property (nonatomic, assign) NSInteger finalScore;

+ (LPFinalScoreNode *)finalScoreNodeWithSize:(CGSize)size;

- (void)setDidClickRestartButtonBlock:(BLKObjectBlock)aBlock;

- (void)showInScene:(SKScene *)scene;
- (void)dismiss;

@end
