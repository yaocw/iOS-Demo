//
//  CollisionEffectScene.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "CollisionEffectScene.h"


#define mGameLevel 0.5

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

#define mEndPointToStartPointDistance 1000.0f
#define mControlRunDirectionDistance 50.0f

typedef enum : NSUInteger {
    eOriginPointDirectionForUp = 0,
    eOriginPointDirectionForDown = 1,
    eOriginPointDirectionForLeft = 2,
    eOriginPointDirectionForRight = 3,
} OriginPointDirection;

@interface CollisionEffectScene ()

@property(nonatomic, assign) BOOL contentCreated;

@end

@implementation CollisionEffectScene
{
    NSArray *_circleTypes;
    NSArray *_circleColors;
}

- (void)didMoveToView:(SKView *)view
{
    if (!_contentCreated)
    {
        [self initializeBaseData];
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)initializeBaseData
{
    _circleTypes = @[@"CircleOne",
                     @"CircleTwo",
                     @"CircleThree"
                     ];
    
    _circleColors = @[[SKColor redColor],
                      [SKColor blueColor],
                      [SKColor greenColor]
                      ];
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor orangeColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKAction *generateCircleNodeAction = [SKAction sequence:@[
                                                              [SKAction performSelector:@selector(generateCircle) onTarget:self],
                                                              [SKAction waitForDuration:mGameLevel]
                                                              ]];
    [self runAction:[SKAction repeatActionForever:generateCircleNodeAction]];
}

- (void)generateCircle
{
    SKShapeNode *circleNode = [SKShapeNode shapeNodeWithCircleOfRadius:15.0];
    
    int circleTypeIndex = kGetRandomIntWithUpperLimit(_circleTypes.count);
    
    circleNode.fillColor = _circleColors[circleTypeIndex];
    circleNode.name = _circleTypes[circleTypeIndex];
    
    NSDictionary *runPoints = [self generateRunPoints];
    CGPoint startPoint = CGPointMake(((NSNumber *)runPoints[@"startPointX"]).floatValue, ((NSNumber *)runPoints[@"startPointY"]).floatValue);
    CGPoint endPoint = CGPointMake(((NSNumber *)runPoints[@"endPointX"]).floatValue, ((NSNumber *)runPoints[@"endPointY"]).floatValue);
    circleNode.position = startPoint;
    
    SKAction *moveAction = [SKAction moveTo:endPoint duration:9.9];
    [circleNode runAction:moveAction completion:^{
        [circleNode removeFromParent];
    }];
    
    [self addChild:circleNode];
}


- (NSDictionary *)generateRunPoints
{
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    OriginPointDirection originPointDirection = kGetRandomIntWithUpperLimit(4);
    originPointDirection = 0;
    switch (originPointDirection)
    {
        case eOriginPointDirectionForUp:
        {
            CGFloat startX = kGetRandomFloatWithLimit(mControlRunDirectionDistance, kDeviceWidth - mControlRunDirectionDistance);
            CGFloat startY = kDeviceHeight;
            startPoint = CGPointMake(startX, startY);
            
            CGPoint leftLimitPoint = CGPointMake(0, kDeviceHeight - mControlRunDirectionDistance);
            CGPoint rightLimitPoint = CGPointMake(kDeviceWidth, kDeviceHeight - mControlRunDirectionDistance);
            
            float leftLimitAngle = angleFromNorth(startPoint, leftLimitPoint, NO);
            float rightLimitAngle = angleFromNorth(startPoint, rightLimitPoint, NO);
            
            float randomAngle = 0;
            if ((leftLimitAngle - rightLimitAngle) > 0)
            {
                randomAngle = kGetRandomFloatWithLimit(leftLimitAngle, rightLimitAngle);
            }
            else
            {
                randomAngle = kGetRandomFloatWithLimit(rightLimitAngle, leftLimitAngle);
            }
            
            
            endPoint = [self pointFromAngle:randomAngle center:startPoint];
            
            break;
        }
            
        case eOriginPointDirectionForDown:
        {
            CGFloat startX = kGetRandomFloatWithLimit(mControlRunDirectionDistance, kDeviceWidth - mControlRunDirectionDistance);
            CGFloat startY = 0;
            startPoint = CGPointMake(startX, startY);
            
            
            CGPoint leftLimitPoint = CGPointMake(0, mControlRunDirectionDistance);
            CGPoint rightLimitPoint = CGPointMake(kDeviceWidth, mControlRunDirectionDistance);
            
            float leftLimitAngle = angleFromNorth(startPoint, leftLimitPoint, NO);
            float rightLimitAngle = angleFromNorth(startPoint, rightLimitPoint, NO);
            
            float randomAngle = 0;
            if ((leftLimitAngle - rightLimitAngle) > 0)
            {
                randomAngle = kGetRandomFloatWithLimit(leftLimitAngle, rightLimitAngle);
            }
            else
            {
                randomAngle = kGetRandomFloatWithLimit(rightLimitAngle, leftLimitAngle);
            }
            
            
            endPoint = [self pointFromAngle:randomAngle center:startPoint];
            
            break;
        }
            
        case eOriginPointDirectionForLeft:
        {
            CGFloat startX = 0;
            CGFloat startY = kGetRandomFloatWithLimit(mControlRunDirectionDistance ,kDeviceHeight - mControlRunDirectionDistance);
            startPoint = CGPointMake(startX, startY);
            
            CGPoint upLimitPoint = CGPointMake(mControlRunDirectionDistance, kDeviceHeight);
            CGPoint downLimitPoint = CGPointMake(mControlRunDirectionDistance, 0);
            
            float upLimitAngle = angleFromNorth(startPoint, upLimitPoint, NO);
            float downLimitAngle = angleFromNorth(startPoint, downLimitPoint, NO);
            
            float randomAngle = 0;
            if ((upLimitAngle - downLimitAngle) > 0)
            {
                randomAngle = kGetRandomFloatWithLimit(upLimitAngle, downLimitAngle);
            }
            else
            {
                randomAngle = kGetRandomFloatWithLimit(downLimitAngle, upLimitAngle);
            }
            
            
            endPoint = [self pointFromAngle:randomAngle center:startPoint];
            endPoint = CGPointMake(-endPoint.x, endPoint.y);
            
            break;
        }
            
        case eOriginPointDirectionForRight:
        {
            CGFloat startX = kDeviceHeight;
            CGFloat startY = kGetRandomFloatWithLimit(mControlRunDirectionDistance ,kDeviceHeight - mControlRunDirectionDistance);
            startPoint = CGPointMake(startX, startY);
            
            CGPoint upLimitPoint = CGPointMake(kDeviceWidth - mControlRunDirectionDistance, kDeviceHeight);
            CGPoint downLimitPoint = CGPointMake(kDeviceWidth - mControlRunDirectionDistance, 0);
            
            float upLimitAngle = angleFromNorth(startPoint, upLimitPoint, NO);
            float downLimitAngle = angleFromNorth(startPoint, downLimitPoint, NO);
            
            float randomAngle = 0;
            if ((upLimitAngle - downLimitAngle) > 0)
            {
                randomAngle = kGetRandomFloatWithLimit(upLimitAngle, downLimitAngle);
            }
            else
            {
                randomAngle = kGetRandomFloatWithLimit(downLimitAngle, upLimitAngle);
            }
            
            
            endPoint = [self pointFromAngle:randomAngle center:startPoint];
            
            break;
        }
            
        default:
            break;
    }
    
    return @{@"startPointX" : @(startPoint.x),
             @"startPointY" : @(startPoint.y),
             @"endPointX" : @(endPoint.x),
             @"endPointY" : @(endPoint.y),
             };
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *anyTouch = [touches anyObject];
    CGPoint touchPoint = [anyTouch locationInNode:self];
    SKShapeNode *touchNode = (SKShapeNode *)[self nodeAtPoint:touchPoint];
    
    if ([touchNode isKindOfClass:[SKShapeNode class]])
    {
        [self enumerateChildNodesWithName:touchNode.name usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
            
            [node runAction:[SKAction moveTo:touchPoint duration:0.5] completion:^{
                [node removeFromParent];
            }];
        }];
    }
}

- (void)didSimulatePhysics
{
    for (NSString *nodeName in _circleTypes)
    {
        [self enumerateChildNodesWithName:nodeName usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
           
            if (node.position.x < 0 || node.position.y < 0 || node.position.x > kDeviceWidth || node.position.y > kDeviceHeight)
            {
                [node removeFromParent];
            }
        }];
    }
}


/**
 * 根据角度得到圆圈轨迹上的坐标
 */
-(CGPoint)pointFromAngle:(int)angleInt center:(CGPoint)center
{
    CGPoint result;
    result.y = round(center.y + mEndPointToStartPointDistance * sin(ToRad(angleInt))) ;
    result.x = round(center.x + mEndPointToStartPointDistance * cos(ToRad(angleInt)));
    
    return result;
}

/**
 * 计算中心点到任意点的角度
 */
static inline float angleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped)
{
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

@end






