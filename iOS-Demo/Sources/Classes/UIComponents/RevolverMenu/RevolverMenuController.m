//
//  RevolverMenuController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/7.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "RevolverMenuController.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

#define kMenusToCenterDistance 136.0f
#define RMMenuItemSize CGSizeMake(66.0f, 66.0f)

@interface RevolverMenuController ()

@end

@implementation RevolverMenuController
{
    CGPoint _mainViewCenter;
    
    UIImageView *_beautyGirlImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainViewCenter = CGPointMake(kDeviceWidth / 2.0, kDeviceHeight / 2.0);
    _beautyGirlImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, RMMenuItemSize.width, RMMenuItemSize.height)];
    _beautyGirlImageView.image = [UIImage imageNamed:@"beauty_girl.jpg"];
    _beautyGirlImageView.contentMode = UIViewContentModeScaleAspectFill;
    _beautyGirlImageView.center = CGPointMake((kDeviceWidth / 2.0) + kMenusToCenterDistance, kDeviceHeight / 2.0);
    _beautyGirlImageView.layer.cornerRadius = RMMenuItemSize.width / 2.0f;
    _beautyGirlImageView.layer.masksToBounds = YES;
    [self.view addSubview:_beautyGirlImageView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    
    float angle = AngleFromNorth(_mainViewCenter, touchPoint, NO);
    CGPoint willMovePoint = [self pointFromAngle:angle];
    _beautyGirlImageView.center = willMovePoint;
    
}

/**
 * 根据角度得到圆圈轨迹上的坐标
 */
-(CGPoint)pointFromAngle:(int)angleInt
{
    CGPoint result;
    result.y = round(_mainViewCenter.y + kMenusToCenterDistance * sin(ToRad(angleInt))) ;
    result.x = round(_mainViewCenter.x + kMenusToCenterDistance * cos(ToRad(angleInt)));
    
    return result;
}

/**
 * 计算中心点到任意点的角度
 */
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped)
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
