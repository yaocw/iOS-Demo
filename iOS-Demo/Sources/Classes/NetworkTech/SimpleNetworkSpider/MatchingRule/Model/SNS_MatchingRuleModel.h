//
//  SNS_MatchingRuleModel.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNS_MatchingRuleModel : NSObject

@property (nonatomic, copy) NSString *matchingRuleName;
@property (nonatomic, copy) NSString *matchingRuleContent;

@property (nonatomic, assign) BOOL isLastModel;

@end
