//
//  BaseTextView.m
//  YouJia
//
//  Created by user on 15/9/1.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import "BaseTextView.h"
#import "KeyboardToolBar.h"

@implementation BaseTextView
{
    BTVTextDidChangedBlock _didChangedBlock;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if (_maxLengthOfText <= 0)
    {
        _maxLengthOfText = 9999;
    }
    
    _placeHolderLab = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width, [self heightOfLabelRow])];
    _placeHolderLab.font = self.font;
    _placeHolderLab.textColor = [UIColor grayColor];
    [self addSubview:_placeHolderLab];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textValueChange:) name:@"UITextViewTextDidChangeNotification" object:self];
}

- (void)setTextDidChangedBlock:(BTVTextDidChangedBlock)aBlcok
{
    _didChangedBlock = aBlcok;
}

- (void)textValueChange:(NSNotification *)sender
{
    if (self.text.length > _maxLengthOfText)
    {
        self.text = [self.text substringToIndex:_maxLengthOfText];
        return ;
    }
    
    if (self.text.length == 0)
    {
        _placeHolderLab.hidden = NO;
    }
    else
    {
        _placeHolderLab.hidden = YES;
    }
    
    if (_didChangedBlock)
    {
        _didChangedBlock();
    }
}

- (CGFloat)heightOfLabelRow
{
    UILabel *theLabel = [UILabel new];
    theLabel.numberOfLines = 1;
    theLabel.text = @"Return The RowHeight.";
    
    
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize labelSize = CGSizeZero;
    labelSize = [theLabel.text boundingRectWithSize:CGSizeMake(9999, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    return labelSize.height;
}

- (void)refreshPlaceHolder
{
    if (self.text.length > 0)
    {
        _placeHolderLab.hidden = YES;
    }
    else
    {
        _placeHolderLab.hidden = NO;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextViewTextDidChangeNotification1" object:self];
}


@end
