//
//  DP_OS_UserInfoModel.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DP_OS_UserInfoModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger sex;


@end
