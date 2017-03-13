//
//  SNS_ReplacingRuleCell.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNS_ReplacingRuleCell.h"
#import "SNS_ReplacingRuleModel.h"

@implementation SNS_ReplacingRuleCell
{
    __weak IBOutlet UILabel *_beforeReplaceContentLabel;
    __weak IBOutlet UILabel *_tipTextLabel;
    __weak IBOutlet UILabel *_afterReplaceContentLabel;
    __weak IBOutlet UIImageView *_addImageView;
    __weak IBOutlet NSLayoutConstraint *_textLeftConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_separatorSpace1Constraint;
        __weak IBOutlet NSLayoutConstraint *_separatorSpace2Constraint;
    SNS_ReplacingRuleModel *_model;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setModel:(id)model
{
    _model = model;
    
    _beforeReplaceContentLabel.text = _model.beforeReplaceContent;
    _afterReplaceContentLabel.text = _model.afterReplaceContent;
    
    if (_model.isLastModel)
    {
        _addImageView.hidden = NO;
        _tipTextLabel.text = @"";
        _separatorSpace1Constraint.constant = 0;
        _textLeftConstraint.constant = 50.0f;
    }
    else
    {
        _addImageView.hidden = YES;
        _tipTextLabel.text = @"替换为";
        _separatorSpace1Constraint.constant = 8.0f;
        _textLeftConstraint.constant = 12.0f;
    }
}

@end
