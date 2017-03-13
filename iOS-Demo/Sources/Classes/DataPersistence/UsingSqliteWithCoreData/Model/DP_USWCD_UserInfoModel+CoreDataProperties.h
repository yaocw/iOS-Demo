//
//  DP_USWCD_UserInfoModel+CoreDataProperties.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "DP_USWCD_UserInfoModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DP_USWCD_UserInfoModel (CoreDataProperties)

+ (NSFetchRequest<DP_USWCD_UserInfoModel *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *realnameFirstPinYin;
@property (nullable, nonatomic, copy) NSString *nickname;
@property (nullable, nonatomic, copy) NSString *realname;
@property (nonatomic) int16_t sex;
@property (nullable, nonatomic, copy) NSString *telephone;

@end

NS_ASSUME_NONNULL_END
