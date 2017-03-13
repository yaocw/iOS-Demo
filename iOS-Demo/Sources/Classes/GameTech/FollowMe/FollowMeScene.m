//
//  FollowMeScene.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "FollowMeScene.h"

@interface FollowMeScene ()

@property(nonatomic, assign) BOOL contentCreated;

@end

@implementation FollowMeScene

- (void)didMoveToView:(SKView *)view
{
    if (!_contentCreated)
    {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor orangeColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKAction *generateCircleNodeAction = [SKAction sequence:@[
                                                              [SKAction performSelector:@selector(createCircleNode) onTarget:self],
                                                              [SKAction waitForDuration:0.5]
                                                              ]];
    [self runAction:[SKAction repeatActionForever:generateCircleNodeAction]];
}

- (void)createCircleNode
{
    if ([self children].count >= 100)
    {
        return ;
    }
    
    SKShapeNode *circleNode = [SKShapeNode shapeNodeWithCircleOfRadius:10];
    circleNode.fillColor = [SKColor whiteColor];
    circleNode.name = @"CircleNode";
    circleNode.position = CGPointMake(kGetRandomFloatWithLimit(0, kDeviceWidth), kGetRandomFloatWithLimit(0, kDeviceHeight));
    [self addChild:circleNode];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchPoint = [anyTouch locationInNode:self];
    
    [self enumerateChildNodesWithName:@"CircleNode" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        [node runAction:[SKAction moveTo:touchPoint duration:0.5] completion:^{
            [node removeFromParent];
        }];
    }];
}

@end




