//
//  DP_USWF_UserInfoModel.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DP_USWF_UserInfoModel : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, strong) NSString *realnameFirstPinYin;

@end
