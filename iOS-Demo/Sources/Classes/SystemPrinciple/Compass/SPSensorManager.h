//
//  SPSensorManager.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/20.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLHeading.h>
#import <CoreMotion/CoreMotion.h>

@interface SPSensorManager : NSObject

+ (instancetype)shared;
- (void)startSensor;
- (void)startGyroscope;
- (void)stopSensor;

@property (nonatomic, copy) void (^didUpdateHeadingBlock)(CLLocationDirection theHeading);
@property (nonatomic, copy) void (^updateDeviceMotionBlock)(CMDeviceMotion *data);

@end
