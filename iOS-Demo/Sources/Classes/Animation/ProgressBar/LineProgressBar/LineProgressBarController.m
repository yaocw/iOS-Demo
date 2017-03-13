//
//  LineProgressBarController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/13.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LineProgressBarController.h"
#import "LPBar_1Controller.h"
#import "LPBar_2Controller.h"
#import "LPBar_3Controller.h"

#define kButtonWidth 66.0f
#define kButtonHeight 36.0f
#define kButtonRadius 5.0f
#define kButtonHorizonSpace 16.0f
#define kButtonVerticalSpace 16.0f

@interface LineProgressBarController ()

@end

@implementation LineProgressBarController
{
    NSArray *_buttonTitles;
    NSMutableArray *_buttons;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    _buttonTitles = @[@"效果一", @"效果二", @"效果三", @"效果四", @"效果五", @"效果六", @"效果7七", @"效果八", @"效果九"];
}

- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
    
    int numberOfButtonsInRow = (kDeviceWidth - kButtonHorizonSpace) / (kButtonHorizonSpace + kButtonWidth);
    float adjustSpaceForCenter = ((kDeviceWidth - kButtonHorizonSpace) - (numberOfButtonsInRow * (kButtonHorizonSpace + kButtonWidth))) / 2.0f;
    
    UIButton *theButton;
    for (int i = 0; i < _buttonTitles.count; i++)
    {
        theButton = [UIButton new];
        theButton.tag = i + 1;

        theButton.backgroundColor = kRandomColor;
        [theButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [theButton setTitle:_buttonTitles[i] forState:UIControlStateNormal];
        [theButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
        [theButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        theButton.layer.cornerRadius = kButtonRadius;
        theButton.layer.masksToBounds = YES;
        
        if (_buttonTitles.count < numberOfButtonsInRow)
        {
            theButton.frame = CGRectMake(kButtonHorizonSpace + (i * (kButtonWidth + kButtonHorizonSpace)), kButtonVerticalSpace, kButtonWidth, kButtonHeight);
        }
        else
        {
            theButton.frame = CGRectMake((kButtonHorizonSpace + adjustSpaceForCenter)  + ((i % numberOfButtonsInRow) * (kButtonWidth + kButtonHorizonSpace)), kButtonVerticalSpace + ((i / numberOfButtonsInRow) * (kButtonHeight + kButtonVerticalSpace)), kButtonWidth, kButtonHeight);
        }
        
        [_buttons addObject:theButton];
        [self.view addSubview:theButton];
    }
}


#pragma mark -- TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)buttonClickedAction:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
        {
            kPushViewControllerWithStoryboard(@"LPBar_1Controller", @"LPBar_1Controller");
            
            break;
        }
            
        case 2:
        {
            kPushViewControllerWithStoryboard(@"LPBar_2Controller", @"LPBar_2Controller");
            
            break;
        }
            
        case 3:
        {
            kPushViewControllerWithStoryboard(@"LPBar_3Controller", @"LPBar_3Controller");
            
            break;
        }
            
        case 4:
        {
            kPushViewControllerWithStoryboard(@"LPBar_4Controller", @"LPBar_4Controller");
            
            break;
        }
            
        default:
            break;
    }
}




@end



