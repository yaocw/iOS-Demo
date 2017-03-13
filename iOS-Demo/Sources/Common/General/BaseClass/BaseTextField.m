//
//  BaseTextField.m
//  hxj
//
//  Created by szhhxh on 16/1/3.
//  Copyright © 2016年 szhhxh. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField
{
    NSString *_oldValue;
    
    BLKBlock _textChangeBlock;
}

- (void)setTextChangeBlock:(BLKBlock)aBlock
{
    _textChangeBlock = aBlock;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //监听输入框内容发生变化的事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textValueChange:) name:@"UITextFieldTextDidChangeNotification" object:self];
    
    //设置可输入最大字符数量默认值，默认为999
    if (_maxLengthOfText == 0)
    {
        _maxLengthOfText = 999;
    }
}

/**
 *  响应输入框内容发生变化时的事件
 */
- (void)textValueChange:(NSNotification *)sender
{
    if (self.text.length > _maxLengthOfText)
    {
        self.text = [self.text substringToIndex:_maxLengthOfText];
        return ;
    }
    
    
    if (_onlyAllowInputNumber && ![self.text isEqualToString:@""])
    {
        if (![self.text isEqualToString:@"0"] && ![self.text isEqualToString:@"0."])
        {
            if (_maxPrecisionOfDecimal > 0)
            {
                NSString * regex = [NSString stringWithFormat:@"^[1-9]\\d*$|^[0-9]\\d*\\.\\d{0,%lu}|0\\.\\d{0,%lu}$", (unsigned long)_maxPrecisionOfDecimal, (unsigned long)_maxPrecisionOfDecimal];
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                
                if (![pred evaluateWithObject:self.text])
                {
                    self.text = _oldValue;
                    
                    if (_textChangeBlock)
                    {
                        _textChangeBlock();
                    }
                    
                    return ;
                }
            }
            else
            {
                NSString * regex = @"^[1-9]\\d*$|^[0-9]\\d*\\.\\d*|0\\.\\d*[0-9]\\d*$";
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                
                if (![pred evaluateWithObject:self.text])
                {
                    self.text = _oldValue;
                    
                    if (_textChangeBlock)
                    {
                        _textChangeBlock();
                    }
                    
                    return ;
                }
            }
        }
    }
    
    if (_textChangeBlock)
    {
        _textChangeBlock();
    }
    
    _oldValue = self.text;
}


#pragma mark - Dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self];
}

@end
