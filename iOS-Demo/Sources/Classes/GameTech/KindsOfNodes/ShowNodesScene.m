//
//  ShowNodesScene.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/19.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "ShowNodesScene.h"

#import <AVFoundation/AVFoundation.h>

@interface ShowNodesScene ()

@property(nonatomic, assign) BOOL contentCreated;

@end

@implementation ShowNodesScene
{
    CGMutablePathRef _pathRef;
    
    AVPlayer *_player;
    SKVideoNode *_videoNode;
    BOOL _isPlaying;
}

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
    //====================================== 标签node ======================================
    
    SKLabelNode *labelNode = [SKLabelNode labelNodeWithText:@"Hello SKLabelNode"];
    labelNode.fontSize = 26.0f;
    labelNode.position = CGPointMake(kDeviceWidth / 2.0f, 26.0f);
    [self addChild:labelNode];
    
    
    
    
    
    
    
    //====================================== 图形node ======================================
    
    CGAffineTransform scaleAffineTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
    _pathRef = CGPathCreateMutable();
    CGPathAddEllipseInRect(_pathRef, &scaleAffineTransform, CGRectMake(0, 0, 99.0f, 56.0f));
    
    SKShapeNode *shapeNode_1 = [SKShapeNode shapeNodeWithPath:_pathRef];
    shapeNode_1.position = CGPointMake((kDeviceWidth / 2.0f) - 49.5, 76.0f);
    [self addChild:shapeNode_1];
    

    SKShapeNode *shapeNode_2 = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, 99.0f, 56.0f)];
    shapeNode_2.position = CGPointMake((kDeviceWidth / 2.0f) - 49.5, 76.0f);
    [self addChild:shapeNode_2];
    
    
    SKShapeNode *shapeNode_3 = [SKShapeNode shapeNodeWithCircleOfRadius:56.0f];
    shapeNode_3.position = CGPointMake((kDeviceWidth / 2.0f), 108.0f);
    [self addChild:shapeNode_3];
    
    
    
    
    
    
    
    //====================================== 视频node ======================================
    
//    SKVideoNode *videoNode = [SKVideoNode videoNodeWithFileNamed:@"test_video.mp4"];
//    videoNode.size = CGSizeMake(160, 90);
//    videoNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//    [self addChild:videoNode];
//    [videoNode play];
    
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test_video" ofType:@"mp4"]];
    _player = [AVPlayer playerWithURL: fileURL];
    
    _videoNode = [[SKVideoNode alloc] initWithAVPlayer:_player];
    _videoNode.name = @"video_node";
    _videoNode.size = CGSizeMake(320.0f, 180.0f);
    _videoNode.position = CGPointMake(CGRectGetMidX(self.frame), kDeviceHeight - 200.0f);
    [self addChild:_videoNode];
    _player.volume = 0.0;
    _isPlaying = YES;
    [_videoNode play];
    


    
    
    
    
    //====================================== 发射器node ======================================
    
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"sks"] ];
    emitterNode.position = CGPointMake(CGRectGetMidX(self.frame), kDeviceHeight);
    [self addChild:emitterNode];

    
    
    
    SKSpriteNode *beCropedNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"beauty_girl.jpg"]]];
    SKCropNode *cropNode = [SKCropNode new];
    cropNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    SKSpriteNode *maskNode = [[SKSpriteNode alloc] initWithImageNamed:@"wings.png"];
    maskNode.size = CGSizeMake(66.0f, 99.0f);
    cropNode.maskNode = maskNode;
    [cropNode addChild:beCropedNode];
    [self addChild:cropNode];
    
    
    
    
//    SKEffectNode *lightEffectNode = [SKEffectNode new];
//    SKSpriteNode *lightNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"wings-1.png"]]];
//    lightNode.blendMode = SKBlendModeAdd;
//    [lightEffectNode addChild:lightNode];
//    lightEffectNode.filter = [self blurFilter];
//    lightEffectNode.blendMode = SKBlendModeMultiply;
//    [self addChild:lightEffectNode];
    
    
    
    
    
    
    
}

- (CIFilter *)blurFilter
{
    CIFilter *filter= [CIFilter filterWithName:@"CIBoxBlur"];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:0] forKey:@"inputRadius"];
    
    return filter;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchPoint = [anyTouch locationInNode:self];
    
    SKVideoNode *videoNode = (SKVideoNode *)[self nodeAtPoint:touchPoint];
    if ([videoNode isKindOfClass:[SKVideoNode class]] && [videoNode.name isEqualToString:@"video_node"])
    {
        if (_isPlaying)
        {
            _isPlaying = NO;
            [_videoNode pause];
        }
        else
        {
            _isPlaying = YES;
            [_videoNode play];
        }
    }
}



- (void)dealloc
{
    CGPathRelease(_pathRef);
    
    _isPlaying = NO;
    [_videoNode pause];
    [_videoNode removeFromParent];
    _videoNode = nil;
    
    [_player pause];
    _player = nil;
}

@end
