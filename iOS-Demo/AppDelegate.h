//
//  AppDelegate.h
//  iOS-Demo
//
//  Created by yaochaowen on 2017/3/13.
//  Copyright © 2017年 yaocw. All rights reserved.
//

//github: https://github.com/yaocw/iOS-Demo

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

