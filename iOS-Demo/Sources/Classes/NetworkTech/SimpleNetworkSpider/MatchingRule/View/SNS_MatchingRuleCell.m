//
//  SNS_MatchingRuleCell.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNS_MatchingRuleCell.h"
#import "SNS_MatchingRuleModel.h"

@implementation SNS_MatchingRuleCell
{
    __weak IBOutlet UILabel *_matchingRuleNameLabel;
    __weak IBOutlet UIImageView *_addImageView;
    __weak IBOutlet NSLayoutConstraint *_textLeftConstraint;
    
    SNS_MatchingRuleModel *_model;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setModel:(id)model
{
    _model = model;
    
    _matchingRuleNameLabel.text = _model.matchingRuleName;
    
    if (_model.isLastModel)
    {
        _addImageView.hidden = NO;
        _textLeftConstraint.constant = 50.0f;
    }
    else
    {
        _addImageView.hidden = YES;
        _textLeftConstraint.constant = 12.0f;
    }
}

@end
