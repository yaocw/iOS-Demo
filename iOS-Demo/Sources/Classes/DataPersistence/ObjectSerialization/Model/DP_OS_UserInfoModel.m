//
//  DP_OS_UserInfoModel.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "DP_OS_UserInfoModel.h"

@implementation DP_OS_UserInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_realname forKey:@"realname"];
    [aCoder encodeObject:_telephone forKey:@"telephone"];
    [aCoder encodeInteger:_age forKey:@"age"];
    [aCoder encodeInteger:_sex forKey:@"sex"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _realname = [aDecoder decodeObjectForKey:@"realname"];
        _telephone = [aDecoder decodeObjectForKey:@"telephone"];
        _age = [aDecoder decodeIntegerForKey:@"age"];
        _sex = [aDecoder decodeIntegerForKey:@"sex"];
    }
    
    return  self;
}

@end
