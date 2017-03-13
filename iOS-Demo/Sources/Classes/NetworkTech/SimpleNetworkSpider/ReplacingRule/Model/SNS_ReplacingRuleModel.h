//
//  SNS_ReplacingRuleModel.h
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNS_ReplacingRuleModel : NSObject

@property (nonatomic, copy) NSString *beforeReplaceContent;
@property (nonatomic, copy) NSString *afterReplaceContent;

@property (nonatomic, assign) BOOL isLastModel;

@end
