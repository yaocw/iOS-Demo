//
//  SpaceshipScene.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SpaceshipScene.h"


static inline CGFloat skRandf()
{
    return rand() / (CGFloat)RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf()*(high - low) + low;
}

@interface SpaceshipScene ()

@property(nonatomic, assign) BOOL contentCreated;

@end

@implementation SpaceshipScene
{
    SKSpriteNode *_spaceship;
    
    BOOL _isTouchedkSpaceship;
}

- (void)didMoveToView:(SKView *)view
{
    if (!_contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
        self.userInteractionEnabled = YES;
    }
}
- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    _spaceship = [self newSpaceship];
    _spaceship.name = @"spaceship";
    _spaceship.position = CGPointMake(50.0, CGRectGetMidY(self.frame));
    
    [self addChild:_spaceship];
    
    
    SKAction * makeRocks = [SKAction sequence:@ [
                                                 [SKAction performSelector:@selector(addRock) onTarget:self],
                                                 [SKAction waitForDuration:0.10 withRange:0.15]
                                                 ]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
}

- (SKSpriteNode *)newSpaceship
{
    SKSpriteNode *hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(100.0, 100.0)];
//    SKAction *hover = [SKAction sequence:@[
//                                           [SKAction waitForDuration:1.0],
//                                           [SKAction moveByX:kDeviceWidth - 100.0 y:0 duration:1.0],
//                                           [SKAction waitForDuration:1.0],
//                                           [SKAction moveByX:-(kDeviceWidth - 100.0) y:0 duration:1.0]
//                                           ]];
//    
//    [hull runAction:[SKAction repeatActionForever:hover]];
    
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    hull.physicsBody.dynamic = NO;
    
    
    SKSpriteNode *light1= [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    SKSpriteNode *light2= [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    
    return hull;
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(10, 10)];
    SKAction *blink= [SKAction sequence:@[
                                          [SKAction fadeOutWithDuration:0.25],
                                          [SKAction fadeInWithDuration:0.25]
                                          ]];
    
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction:blinkForever];
    
    return light;
}

- (void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(30, 30)];
    rock.position = CGPointMake(skRand(0, self.size.width),self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:rock];
}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop){
        if (node.position.y < 0 || node.position.y > kDeviceHeight)
            [node removeFromParent];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isTouchedkSpaceship = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:positionInScene];
    
    if ([touchedNode.name isEqualToString:@"spaceship"])
    {
        _isTouchedkSpaceship = YES;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_isTouchedkSpaceship)
    {
        UITouch *touch = [touches anyObject];
        CGPoint positionInScene = [touch locationInNode:self];
        _spaceship.position = positionInScene;
    }
}

@end
