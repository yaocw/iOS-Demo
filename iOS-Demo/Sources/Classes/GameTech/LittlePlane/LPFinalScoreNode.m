//
//  LPFinalScoreNode.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/10.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LPFinalScoreNode.h"

#define mRestartButtonNodeName @"RestartButton"

@interface LPFinalScoreNode ()

@property (strong, nonatomic) SKLabelNode *finalScoreLabelNode;

@property (strong, nonatomic) SKSpriteNode *restartButtonNode;
@property (strong, nonatomic) SKLabelNode *restartButtonTitleLabelNode;

@end

@implementation LPFinalScoreNode
{
    BLKObjectBlock _didClickRestartButtonBlock;
}

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithColor:color size:size])
    {
        self.userInteractionEnabled = YES;
        
        _finalScoreLabelNode = [SKLabelNode labelNodeWithFontNamed:kMyFavorityFontName];
        _finalScoreLabelNode.fontSize = 26.0f;
        _finalScoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _finalScoreLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _finalScoreLabelNode.position = CGPointMake(size.width / 2.0f, (size.height / 2.0f) + 50.0f);
        _finalScoreLabelNode.fontColor = kRandomColor;
        [self addChild:_finalScoreLabelNode];
        
        
        _restartButtonNode = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:17.f/255.0f green:39.0f/255.0f blue:57.0f/255.0f alpha:1.f] size:CGSizeMake(100.0f, 60.0f)];
        _restartButtonNode.position = CGPointMake(size.width / 2.0f, size.height / 2.0f - 50);
        _restartButtonNode.name = mRestartButtonNodeName;
        [self addChild:_restartButtonNode];
        
        
        _restartButtonTitleLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _restartButtonTitleLabelNode.text = @"Restart";
        _restartButtonTitleLabelNode.fontSize = 20.0f;
        _restartButtonTitleLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _restartButtonTitleLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _restartButtonTitleLabelNode.position = CGPointMake(0.f, 0.f);
        _restartButtonTitleLabelNode.fontColor = [UIColor whiteColor];
        [_restartButtonNode addChild:_restartButtonTitleLabelNode];
        
    }
    
    return self;
}

+ (LPFinalScoreNode *)finalScoreNodeWithSize:(CGSize)size
{
    LPFinalScoreNode *finalScoreNode = [LPFinalScoreNode spriteNodeWithColor:[UIColor colorWithRed:255.f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.6f] size:size];
    finalScoreNode.anchorPoint = CGPointMake(0, 0);
    
    return finalScoreNode;
}

- (void)setDidClickRestartButtonBlock:(BLKObjectBlock)aBlock
{
    _didClickRestartButtonBlock = aBlock;
}

- (void)showInScene:(SKScene *)scene
{
    _finalScoreLabelNode.text = [NSString stringWithFormat:@"您的最终得分：%ld", (long)_finalScore];
    
    self.alpha = 0.0f;
    [scene addChild:self];
    
    [self runAction:[SKAction fadeInWithDuration:0.3f]];
}

- (void)dismiss
{
    [self runAction:[SKAction fadeOutWithDuration:0.3f] completion:^{
        
        [self removeFromParent];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    SKNode *touchNode = [self nodeAtPoint:location];
    
    if (touchNode == _restartButtonNode || touchNode == _restartButtonTitleLabelNode)
    {
        _didClickRestartButtonBlock ? _didClickRestartButtonBlock(self) : nil;
    }
}

@end
