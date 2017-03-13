//
//  LPMainScene.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/10.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LPMainScene.h"

#import "LPFinalScoreNode.h"

static const uint32_t heroCategory   = 0x1 << 0;
static const uint32_t wallCategory   = 0x1 << 1;
static const uint32_t holeCategory   = 0x1 << 2;
static const uint32_t groundCategory = 0x1 << 3;
static const uint32_t edgeCategory   = 0x1 << 4;

#define mGroundColor kRandomColor
#define mGroundHeight 20.0f

#define mHeroName @"SuperMan"
#define mHeroColor kRandomColor
#define mHeroSize CGSizeMake(30.0f, 30.0f)

#define mScoreLabelTextColor kRandomColor

#define mDustName @"dust"
#define mDustColor kRandomColor
#define mDustHeight 1.0f
#define mDustBaseWidth 20.0f

#define mWallName @"wall"
#define mWallColor kRandomColor
#define mWallWidth 40.0f
#define mTimeIntervalAddWall 2.0f
#define mTimeintervalMoveWall 4.0f

#define mHoleName @"hole"

#define mActionKeyForHeroFly @"hero_fly"
#define mActionKeyForAddDust @"add_dust"
#define mActionKeyForAddWall @"add_wall"
#define mActionKeyForMoveWall @"move_wall"


@interface LPMainScene () <SKPhysicsContactDelegate>

@property(nonatomic, assign) BOOL contentCreated;

@end

@implementation LPMainScene
{
    NSInteger _currentScore;
    
    SKAction *_moveWallAction;
    SKAction *_moveHeroHeadAction;
    
    SKSpriteNode *_groundNode;
    SKSpriteNode *_heroNode;
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
    
    
    SKAction *upHeroHeadAction = [SKAction rotateToAngle:M_PI / 4.0f duration:0.2f];
    SKAction *downHeroHeadAction = [SKAction rotateToAngle:-(M_PI / 3.0f) duration:0.8f];
    _moveHeroHeadAction = [SKAction sequence:@[upHeroHeadAction, downHeroHeadAction]];
    
    
    
    [self addGroundNode];
    [self addHeroNode];
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

- (void)addHeroNode
{
    SKTexture *heroTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"little_plane.png"]];
    
    _heroNode = [SKSpriteNode spriteNodeWithTexture:heroTexture];
    _heroNode.size = mHeroSize;
    _heroNode.anchorPoint = CGPointMake(0.5f, 0.5f);
    _heroNode.position = CGPointMake(self.frame.size.width / 3, CGRectGetMidY(self.frame));
    _heroNode.name = mHeroName;
    _heroNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_heroNode.size center:CGPointMake(0, 0)];
    _heroNode.physicsBody.categoryBitMask = heroCategory;
    _heroNode.physicsBody.collisionBitMask = wallCategory | groundCategory;
    _heroNode.physicsBody.contactTestBitMask = holeCategory | wallCategory | groundCategory;
    _heroNode.physicsBody.dynamic = YES;
    _heroNode.physicsBody.affectedByGravity = NO;
    _heroNode.physicsBody.allowsRotation = YES;
    _heroNode.physicsBody.restitution = 0;
    _heroNode.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:_heroNode];
    
    [_heroNode runAction:[SKAction repeatActionForever:[self flyAction]] withKey:mActionKeyForHeroFly];
}

- (SKAction *)flyAction
{
    SKAction *flyUp = [SKAction moveToY:_heroNode.position.y + 10 duration:0.3f];
    flyUp.timingMode = SKActionTimingEaseOut;
    SKAction *flyDown = [SKAction moveToY:_heroNode.position.y - 10 duration:0.3f];
    flyDown.timingMode = SKActionTimingEaseOut;
    SKAction *fly = [SKAction sequence:@[flyUp, flyDown]];
    
    return fly;
}


- (void)addScoreNode
{
    _scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _scoreLabelNode.text = @"0";
    _scoreLabelNode.fontSize = 30.0f;
    _scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _scoreLabelNode.position = CGPointMake(10, self.frame.size.height - 20.0f);
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
    
    _heroNode.physicsBody.velocity = CGVectorMake(0.f, 368.0f);
    [_heroNode runAction:_moveHeroHeadAction];
    [self playSoundWithName:@"lp_wing.caf"];
}

- (void)startGame
{
    _isGameStart = YES;
    
    _heroNode.physicsBody.affectedByGravity = YES;
    [_heroNode removeActionForKey:mActionKeyForHeroFly];
    

    SKAction *addWall = [SKAction sequence:@[
                                             [SKAction performSelector:@selector(addWall) onTarget:self],
                                             [SKAction waitForDuration:mTimeIntervalAddWall],
                                             ]];
    
    [self runAction:[SKAction repeatActionForever:addWall] withKey:mActionKeyForAddWall];
}

- (void)addWall
{
    CGFloat spaceHeigh = self.frame.size.height - mGroundHeight;
    
    CGFloat holeLength = mHeroSize.height * 5.0f;
    int holePosition = arc4random() % (int)((spaceHeigh - holeLength) / mHeroSize.height);
    
    CGFloat x = self.frame.size.width;
    

    CGFloat upHeight = holePosition * mHeroSize.height;
    if (upHeight > 0)
    {
        SKSpriteNode *upWall = [SKSpriteNode spriteNodeWithColor:mWallColor size:CGSizeMake(mWallWidth, upHeight)];
        upWall.anchorPoint = CGPointMake(0, 0);
        upWall.position = CGPointMake(x, self.frame.size.height - upHeight);
        upWall.name = mWallName;
        
        upWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:upWall.size center:CGPointMake(upWall.size.width / 2.0f, upWall.size.height / 2.0f)];
        upWall.physicsBody.categoryBitMask = wallCategory;
        upWall.physicsBody.dynamic = NO;
        upWall.physicsBody.friction = 0;
        
        [upWall runAction:_moveWallAction withKey:mActionKeyForMoveWall];
        
        [self addChild:upWall];
    }
    
    
    CGFloat downHeight = spaceHeigh - upHeight - holeLength;
    if (downHeight > 0)
    {
        SKSpriteNode *downWall = [SKSpriteNode spriteNodeWithColor:mWallColor size:CGSizeMake(mWallWidth, downHeight)];
        downWall.anchorPoint = CGPointMake(0, 0);
        downWall.position = CGPointMake(x, mGroundHeight);
        downWall.name = mWallName;
        
        downWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:downWall.size center:CGPointMake(downWall.size.width / 2.0f, downWall.size.height / 2.0f)];
        downWall.physicsBody.categoryBitMask = wallCategory;
        downWall.physicsBody.dynamic = NO;
        downWall.physicsBody.friction = 0;
        
        [downWall runAction:_moveWallAction withKey:mActionKeyForMoveWall];
        
        [self addChild:downWall];
    }
    
    //中空部分
    SKSpriteNode *hole = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(mWallWidth, holeLength)];
    hole.anchorPoint = CGPointMake(0, 0);
    hole.position = CGPointMake(x, self.frame.size.height - upHeight - holeLength);
    hole.name = mHoleName;
    
    hole.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hole.size center:CGPointMake(hole.size.width / 2.0f, hole.size.height / 2.0f)];
    hole.physicsBody.categoryBitMask = holeCategory;
    hole.physicsBody.dynamic = NO;
    
    [hole runAction:_moveWallAction withKey:mActionKeyForMoveWall];
    
    [self addChild:hole];
}

- (void)playSoundWithName:(NSString *)fileName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self runAction:[SKAction playSoundFileNamed:fileName waitForCompletion:YES]];
    });
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
    
    [self enumerateChildNodesWithName:mHoleName usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.x <= -mWallWidth)
        {
            [node removeFromParent];
            *stop = YES;
        }
    }];
    
    [self enumerateChildNodesWithName:mDustName usingBlock:^(SKNode *node, BOOL *stop) {
        
        if (node.position.x <= -node.frame.size.width)
        {
            [node removeFromParent];
        }
    }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (_isGameOver)
    {
        return;
    }
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & heroCategory) && (secondBody.categoryBitMask & wallCategory))
    {
        [self playSoundWithName:@"lp_hit.caf"];
        [self gameOver];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    if (_isGameOver)
    {
        return;
    }
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & heroCategory) && (secondBody.categoryBitMask & holeCategory))
    {
        _currentScore ++;
        _scoreLabelNode.text = [NSString stringWithFormat:@"%ld", (long)_currentScore];
        [self playSoundWithName:@"lp_point.caf"];
    }
}

- (void)gameOver
{
    _isGameOver = YES;
    
    [self removeActionForKey:mActionKeyForAddWall];
    
    [self enumerateChildNodesWithName:mWallName usingBlock:^(SKNode *node, BOOL *stop) {
        
        [node removeActionForKey:mActionKeyForMoveWall];
    }];
    
    [self enumerateChildNodesWithName:mHoleName usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeActionForKey:mActionKeyForMoveWall];
    }];
    
    
    LPFinalScoreNode *finalScoreNode = [LPFinalScoreNode finalScoreNodeWithSize:self.size];
    finalScoreNode.finalScore = _currentScore;
    [finalScoreNode setDidClickRestartButtonBlock:^(LPFinalScoreNode *obj) {
        
        [obj dismiss];
        [self restart];
    }];
    
    [finalScoreNode showInScene:self];
}

- (void)restart
{
    _scoreLabelNode.text = @"0";
    _currentScore = 0;
    
    
    [self enumerateChildNodesWithName:mHoleName usingBlock:^(SKNode *node, BOOL *stop) {
        
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:mWallName usingBlock:^(SKNode *node, BOOL *stop) {
        
        [node removeFromParent];
    }];
    
    
    [_heroNode removeFromParent];
    _heroNode = nil;
    
    [self addHeroNode];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[
                                                                       [SKAction performSelector:@selector(addDust) onTarget:self],
                                                                       [SKAction waitForDuration:0.3f],
                                                                       ]]] withKey:mActionKeyForAddDust];

    _isGameStart = NO;
    _isGameOver = NO;
}

@end









