//
//  PaintbrushSettingController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/1.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "PaintbrushSettingController.h"

@interface PaintbrushSettingController ()

@property (weak, nonatomic) IBOutlet UISlider *paintbrushSizeSlider;
@property (weak, nonatomic) IBOutlet UIView *currentPaintbrushColorview;

@property (weak, nonatomic) IBOutlet UIView *paintbrushSizeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paintbrushSizeViewHeightConstraint;

@end

@implementation PaintbrushSettingController
{
    UIButton *_currentChoosedColorButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    CGFloat paintbrushSize = ((NSNumber *)kFetchFromUserDefaults(@"MT_SS_PaintBrushSize")).floatValue;
    if (paintbrushSize <= 0.0f)
    {
        paintbrushSize = 1.0f;
    }
    else
    {
        _paintbrushSizeSlider.value = paintbrushSize;
    }
    
    UIColor *currentPaintbrushColor;
    NSString *colorHexString = kFetchFromUserDefaults(@"MT_SS_PaintBrushColor");
    if (kIsNotNullOrEmptyWithString(colorHexString))
    {
        currentPaintbrushColor = [UIColor colorWithHexColorString:colorHexString];
    }
    else
    {
        currentPaintbrushColor = [UIColor whiteColor];
    }
    
    
    _currentPaintbrushColorview.backgroundColor = currentPaintbrushColor;
    
    _paintbrushSizeViewHeightConstraint.constant = paintbrushSize;
    _paintbrushSizeView.backgroundColor = currentPaintbrushColor;
    _paintbrushSizeView.layer.cornerRadius = paintbrushSize / 2.0f;
    _paintbrushSizeView.layer.masksToBounds = YES;
}


#pragma mark -- Actions

- (IBAction)paintbrushSizeDidChangAction:(UISlider *)sender
{
    _paintbrushSizeViewHeightConstraint.constant = sender.value;
    _paintbrushSizeView.layer.cornerRadius = sender.value / 2.0f;
}

- (IBAction)chooseColorAction:(UIButton *)sender
{
    _currentChoosedColorButton.layer.borderWidth = 0.0f;
    
    sender.layer.borderColor = kRandomColor.CGColor;
    sender.layer.borderWidth = 3.0f;
    
    _currentChoosedColorButton = sender;
    
    
    _currentPaintbrushColorview.backgroundColor = _currentChoosedColorButton.backgroundColor;
    _paintbrushSizeView.backgroundColor = _currentChoosedColorButton.backgroundColor;
}

- (IBAction)ensureAction:(id)sender
{
    kSaveToUserDefaults(@"MT_SS_PaintBrushSize", @(_paintbrushSizeSlider.value));
    
    if (_currentChoosedColorButton != nil)
    {
        kSaveToUserDefaults(@"MT_SS_PaintBrushColor", [UIColor getHexStringByColor:_currentChoosedColorButton.backgroundColor]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
