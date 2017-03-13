//
//  SJMainScene.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/11.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SJMainScene.h"

static const uint32_t edgeCategory          = 0x1 << 0;
static const uint32_t jumperCategory        = 0x1 << 1;
static const uint32_t groundCategory        = 0x1 << 2;
static const uint32_t wallCategory          = 0x1 << 3;
static const uint32_t springboardCategory   = 0x1 << 4;

#define mGroundColor kRandomColor
#define mGroundHeight 20.0f

#define mJumperName @"SuperJumper"
#define mJumperColor kRandomColor
#define mJumperSize CGSizeMake(30.0f, 30.0f)

#define mScoreLabelTextColor kRandomColor

#define mDustName @"dust"
#define mDustColor kRandomColor
#define mDustHeight 1.0f
#define mDustBaseWidth 20.0f

#define mWallName @"wall"
#define mWallColor kRandomColor
#define mWallWidth 99.0f
#define mWallHeight 33.0f
#define mTimeIntervalAddWall 2.0f
#define mTimeintervalMoveWall 4.0f

#define mSpringboardName @"springboard"
#define mSpringboardColor kRandomColor
#define mSpringboardWidth mWallWidth
#define mSpringboardHeight 1.0f

#define mActionKeyForJumperJump @"jumper_jump"
#define mActionKeyForAddDust @"add_dust"
//#define mActionKeyForTumbling @"jumper_tumbling"
#define mActionKeyForAddWall @"add_wall"
#define mActionKeyForMoveWall @"move_wall"

#define mJumpVelocity CGVectorMake(0.f, 568.0f)

@interface SJMainScene () <SKPhysicsContactDelegate>

@property(nonatomic, assign) BOOL contentCreated;

@end

@implementation SJMainScene
{
    SKAction *_moveWallAction;
//    SKAction *_tumblingAction;
    
    SKSpriteNode *_groundNode;
    SKSpriteNode *_jumperNode;
    SKLabelNode *_scoreLabelNode;
    
    BOOL _isGameStart;
    BOOL _isGameOver;
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
    self.backgroundColor = [SKColor whiteColor];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = edgeCategory;
    self.physicsWorld.contactDelegate = self;
    
    _moveWallAction = [SKAction moveToX:-mWallWidth duration:mTimeintervalMoveWall];
//    _tumblingAction = [SKAction rotateToAngle:-M_PI * 2.0f duration:0.2f];
    
    [self addGroundNode];
    [self addJumperNode];
    [self addScoreNode];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                       [SKAction performSelector:@selector(addDust) onTarget:self],
                                                                       [SKAction waitForDuration:0.3f],
                                                                       ]]] withKey:mActionKeyForAddDust];
}

- (void)addGroundNode
{
    _groundNode = [SKSpriteNode spriteNodeWithColor:mGroundColor size:CGSizeMake(self.frame.size.width, mGroundHeight)];
    _groundNode.anchorPoint = CGPointMake(0, 0);
    _groundNode.position = CGPointMake(0, 0);
    _groundNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_groundNode.size center:CGPointMake(_groundNode.size.width / 2.0f, _groundNode.size.height / 2.0f)];
    _groundNode.physicsBody.categoryBitMask = groundCategory;
    _groundNode.physicsBody.dynamic = NO;
    [self addChild:_groundNode];
}

- (void)addJumperNode
{
    _jumperNode = [SKSpriteNode spriteNodeWithColor:mJumperColor size:mJumperSize];
    _jumperNode.size = mJumperSize;
    _jumperNode.anchorPoint = CGPointMake(0.5f, 0.5f);
    _jumperNode.position = CGPointMake(self.frame.size.width / 3, CGRectGetMidY(self.frame));
    _jumperNode.name = mJumperName;
    _jumperNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_jumperNode.size center:CGPointMake(0, 0)];
    _jumperNode.physicsBody.categoryBitMask = jumperCategory;
    _jumperNode.physicsBody.collisionBitMask = groundCategory | wallCategory | springboardCategory;
    _jumperNode.physicsBody.contactTestBitMask = wallCategory;
    _jumperNode.physicsBody.dynamic = YES;
    _jumperNode.physicsBody.allowsRotation = YES;
    _jumperNode.physicsBody.restitution = 0;
    _jumperNode.physicsBody.usesPreciseCollisionDetection = YES;
    _jumperNode.physicsBody.affectedByGravity = YES;
    [self addChild:_jumperNode];
    
}


- (void)addScoreNode
{
    _scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreLabelNode.text = @"0";
    _scoreLabelNode.fontSize = 30.0f;
    _scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _scoreLabelNode.position = CGPointMake(10.0f, self.frame.size.height - 20.0f);
    _scoreLabelNode.fontColor = mScoreLabelTextColor;
    [self addChild:_scoreLabelNode];
}


- (void)addDust
{
    CGFloat dustWidth = kGetRandomIntWithLimit(0, 6) * mDustBaseWidth;
    SKSpriteNode *dustNode = [SKSpriteNode spriteNodeWithColor:mDustColor size:CGSizeMake(dustWidth, mDustHeight)];
    dustNode.anchorPoint = CGPointMake(0.f, 0.f);
    dustNode.name = mDustName;
    dustNode.position = CGPointMake(self.frame.size.width, kGetRandomFloatWithLimit(0, self.frame.size.height));
    [dustNode runAction:[SKAction moveToX:-dustWidth duration:1.0f]];
    [self addChild:dustNode];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_isGameOver)
    {
        return;
    }
    
    if (!_isGameStart)
    {
        [self startGame];
    }
    
    _jumperNode.physicsBody.velocity = mJumpVelocity;
//    [_jumperNode runAction:_tumblingAction withKey:mActionKeyForTumbling];
    [self playSoundWithName:@"lp_wing.caf"];
}

- (void)startGame
{
    _isGameStart = YES;
    [self removeActionForKey:mDustName];
    
    
    SKAction *addWall = [SKAction sequence:@[
                                             [SKAction performSelector:@selector(addWall) onTarget:self],
                                             [SKAction waitForDuration:mTimeIntervalAddWall],
                                             ]];
    
    [self runAction:[SKAction repeatActionForever:addWall] withKey:mActionKeyForAddWall];
}

- (void)addWall
{
    CGFloat x = self.frame.size.width;
    
    SKSpriteNode *wallNode = [SKSpriteNode spriteNodeWithColor:mWallColor size:CGSizeMake(mWallWidth, mWallHeight)];
    wallNode.anchorPoint = CGPointMake(0, 0);
    wallNode.position = CGPointMake(x, mGroundHeight);
    wallNode.name = mWallName;
    wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:wallNode.size center:CGPointMake(wallNode.size.width / 2.0f, wallNode.size.height / 2.0f)];
    wallNode.physicsBody.categoryBitMask = wallCategory;
    wallNode.physicsBody.dynamic = NO;
    wallNode.physicsBody.friction = 0;
    [wallNode runAction:_moveWallAction withKey:mActionKeyForMoveWall];
    [self addChild:wallNode];
    
    
    
    SKSpriteNode *springboardNode = [SKSpriteNode spriteNodeWithColor:mSpringboardColor size:CGSizeMake(mSpringboardWidth, 1.0f)];
    springboardNode.anchorPoint = CGPointMake(0, 0);
    springboardNode.position = CGPointMake(x, mGroundHeight + mWallHeight);
    springboardNode.name = mSpringboardName;
    springboardNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:springboardNode.size center:CGPointMake(springboardNode.size.width / 2.0f, springboardNode.size.height / 2.0f)];
    springboardNode.physicsBody.categoryBitMask = springboardCategory;
    springboardNode.physicsBody.dynamic = NO;
    springboardNode.physicsBody.friction = 0;
    [springboardNode runAction:_moveWallAction withKey:mActionKeyForMoveWall];
    [self addChild:springboardNode];
}


- (void)update:(NSTimeInterval)currentTime
{
    __block int wallCount = 0;
    [self enumerateChildNodesWithName:mWallName usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (wallCount >= 2)
        {
            *stop = YES;
            return;
        }
        
        if (node.position.x <= -mWallWidth)
        {
            wallCount++;
            [node removeFromParent];
        }
    }];
    
    [self enumerateChildNodesWithName:mDustName usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.x <= -node.frame.size.width)
        {
            [node removeFromParent];
        }
    }];
}

- (void)playSoundWithName:(NSString *)fileName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self runAction:[SKAction playSoundFileNamed:fileName waitForCompletion:YES]];
    });
}

@end








