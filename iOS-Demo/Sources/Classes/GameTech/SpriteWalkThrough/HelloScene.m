//
//  HelloScene.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "HelloScene.h"

#import "SpaceshipScene.h"

@interface HelloScene ()

@property(nonatomic, assign) BOOL contentCreated;

@end

@implementation HelloScene

- (void)didMoveToView:(SKView *)view
{
    if (!_contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild:[self newHelloNode]];
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Hello World!";
    helloNode.fontSize = 42.0;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    helloNode.name = @"helloNode";
    
    return helloNode;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    
    if (helloNode)
    {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX:0 y:100.0 duration:0.5];
        SKAction *zoom = [SKAction scaleTo:2.0 duration:0.25];
        SKAction *pause = [SKAction waitForDuration:0.5];
        SKAction *fadeWay = [SKAction fadeOutWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSquene = [SKAction sequence:@[moveUp, zoom, pause, fadeWay, remove]];
        
        [helloNode runAction:moveSquene completion:^{
            SKScene *spaceshipScene = [[SpaceshipScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            
            [self.view presentScene:spaceshipScene transition:doors];
        }];
    }
}

@end




