//
//  DP_USWCD_UserInfoModel+CoreDataProperties.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "DP_USWCD_UserInfoModel+CoreDataProperties.h"

@implementation DP_USWCD_UserInfoModel (CoreDataProperties)

+ (NSFetchRequest<DP_USWCD_UserInfoModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DP_USWCD_UserInfoModel"];
}

@dynamic age;
@dynamic realnameFirstPinYin;
@dynamic nickname;
@dynamic realname;
@dynamic sex;
@dynamic telephone;

@end
