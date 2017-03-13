//
//  PopMenuController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/5.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "PopMenuController.h"

#define kMenuItemWidth 42.0f
#define kMenuItemHeight 42.0f

static CGFloat kMenuRadius = 100.0f;

typedef NS_ENUM(NSUInteger, ViewTags) {
    eViewTagsForRed,
    eViewTagsForOrange,
    eViewTagsForYellow,
    eViewTagsForGreen,
    eViewTagsForBlue,
};

typedef NS_ENUM(NSUInteger, PopDirection) {
    ePopDirectionForVertical,
    ePopDirectionForHorizon,
};

@interface PopMenuController ()

@property (weak, nonatomic) IBOutlet UIButton *mainMenuButton;
@property (weak, nonatomic) IBOutlet UIView *arrowMenuView;
@property (weak, nonatomic) IBOutlet UISwitch *popDirectionSwitch;
@property (weak, nonatomic) IBOutlet UILabel *popDirectionLabel;

@end

@implementation PopMenuController
{
    NSMutableArray *_menuItemTitles;
    NSMutableArray *_menuItems;
    NSMutableArray *_menuItemColors;
    BOOL _isMenuExpanded;
    
    
    
    NSMutableArray *_arrowMenuItemTitles;
    NSMutableArray *_arrowMenuItems;
    NSMutableArray *_arrowMenuItemColors;
    PopDirection _popDirection;
    BOOL _isArrowMenuExpanded;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeData];
    [self initializeUIComponents];
}

- (void)initializeData
{
    if (_popDirectionSwitch.isOn)
    {
        _popDirection = ePopDirectionForHorizon;
    }
    else
    {
        _popDirection = ePopDirectionForVertical;
    }
    
    _menuItemTitles = [NSMutableArray new];
    [_menuItemTitles addObject:[NSString stringWithFormat:@"红"]];
    [_menuItemTitles addObject:[NSString stringWithFormat:@"橙"]];
    [_menuItemTitles addObject:[NSString stringWithFormat:@"黄"]];
    [_menuItemTitles addObject:[NSString stringWithFormat:@"绿"]];
    [_menuItemTitles addObject:[NSString stringWithFormat:@"蓝"]];
    
    _menuItemColors = [NSMutableArray new];
    [_menuItemColors addObject:[UIColor redColor]];
    [_menuItemColors addObject:[UIColor orangeColor]];
    [_menuItemColors addObject:[UIColor yellowColor]];
    [_menuItemColors addObject:[UIColor greenColor]];
    [_menuItemColors addObject:[UIColor blueColor]];
    
    _menuItems = [NSMutableArray new];
    
    
    
    
    _arrowMenuItemTitles = [NSMutableArray new];
    [_arrowMenuItemTitles addObject:[NSString stringWithFormat:@"红"]];
    [_arrowMenuItemTitles addObject:[NSString stringWithFormat:@"橙"]];
    [_arrowMenuItemTitles addObject:[NSString stringWithFormat:@"黄"]];
    [_arrowMenuItemTitles addObject:[NSString stringWithFormat:@"绿"]];
    [_arrowMenuItemTitles addObject:[NSString stringWithFormat:@"蓝"]];
    
    _arrowMenuItemColors = [NSMutableArray new];
    [_arrowMenuItemColors addObject:[UIColor redColor]];
    [_arrowMenuItemColors addObject:[UIColor orangeColor]];
    [_arrowMenuItemColors addObject:[UIColor yellowColor]];
    [_arrowMenuItemColors addObject:[UIColor greenColor]];
    [_arrowMenuItemColors addObject:[UIColor blueColor]];
    
    _arrowMenuItems = [NSMutableArray new];
}

- (void)initializeUIComponents
{
    {  //半圆菜单
        NSMutableArray *tapGestures = [NSMutableArray new];
        [tapGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemClickAction:)]];
        [tapGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemClickAction:)]];
        [tapGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemClickAction:)]];
        [tapGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemClickAction:)]];
        [tapGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemClickAction:)]];
        
        UIView *tempView;
        UILabel *titleLabel;
        for (int i = 0; i < 5; i ++)
        {
            tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
            [self.view addSubview:tempView];
            tempView.hidden = YES;
            tempView.backgroundColor = _menuItemColors[i];
            tempView.alpha = 0.0;
            tempView.layer.cornerRadius = kMenuItemWidth / 2.0;
            tempView.layer.masksToBounds = YES;
            tempView.tag = i;
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
            titleLabel.text = _menuItemTitles[i];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [tempView addSubview:titleLabel];
            
            tempView.userInteractionEnabled = YES;
            [tempView addGestureRecognizer:tapGestures[i]];
            
            
            [_menuItems addObject:tempView];
        }
    }
    
    
    
    {  //直条菜单
        UITapGestureRecognizer *tapArrowMenuGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowMenuClickAction:)];
        _arrowMenuView.userInteractionEnabled = YES;
        [_arrowMenuView addGestureRecognizer:tapArrowMenuGesture];
        
        NSMutableArray *tapArrowMenuGestures = [NSMutableArray new];
        [tapArrowMenuGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowMenuItemClickAction:)]];
        [tapArrowMenuGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowMenuItemClickAction:)]];
        [tapArrowMenuGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowMenuItemClickAction:)]];
        [tapArrowMenuGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowMenuItemClickAction:)]];
        [tapArrowMenuGestures addObject:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowMenuItemClickAction:)]];
        
        UIView *tempView;
        UILabel *titleLabel;
        for (int i = 0; i < 5; i ++)
        {
            tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
            [self.view addSubview:tempView];
            tempView.hidden = YES;
            tempView.backgroundColor = _arrowMenuItemColors[i];
            tempView.alpha = 0.0;
            tempView.tag = i;
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMenuItemWidth, kMenuItemHeight)];
            titleLabel.text = _arrowMenuItemTitles[i];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [tempView addSubview:titleLabel];
            
            tempView.userInteractionEnabled = YES;
            [tempView addGestureRecognizer:tapArrowMenuGestures[i]];
            
            
            [_arrowMenuItems addObject:tempView];
        }
    }
}

- (void)menuItemClickAction:(UITapGestureRecognizer *)sender
{
    UIView *tempView = sender.view;
    
    switch (tempView.tag)
    {
        case eViewTagsForRed:
        {
            NSLog(@"Red");
            break;
        }
            
        case eViewTagsForOrange:
        {
            NSLog(@"Orange");
            break;
        }
            
        case eViewTagsForYellow:
        {
            NSLog(@"Yellow");
            break;
        }
            
        case eViewTagsForGreen:
        {
            NSLog(@"Green");
            break;
        }
            
        case eViewTagsForBlue:
        {
            NSLog(@"Blue");
            break;
        }
            
        default:
            break;
    }
    
    _isMenuExpanded = NO;
    for (UIView *tempView in _menuItems)
    {
        [UIView animateWithDuration:0.37 animations:^{
            
            tempView.center = _mainMenuButton.center;
            tempView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            tempView.hidden = YES;
        }];
    }
}

- (void)arrowMenuItemClickAction:(UITapGestureRecognizer *)sender
{
    UIView *tempView = sender.view;
    
    switch (tempView.tag)
    {
        case eViewTagsForRed:
        {
            NSLog(@"Red");
            break;
        }
            
        case eViewTagsForOrange:
        {
            NSLog(@"Orange");
            break;
        }
            
        case eViewTagsForYellow:
        {
            NSLog(@"Yellow");
            break;
        }
            
        case eViewTagsForGreen:
        {
            NSLog(@"Green");
            break;
        }
            
        case eViewTagsForBlue:
        {
            NSLog(@"Blue");
            break;
        }
            
        default:
            break;
    }
    
    _isArrowMenuExpanded = NO;
    for (UIView *tempView in _arrowMenuItems)
    {
        [UIView animateWithDuration:0.37 animations:^{
            
            tempView.center = _mainMenuButton.center;
            tempView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            tempView.hidden = YES;
        }];
    }
}

- (IBAction)popMenuClickAction:(UIButton *)sender
{
    if (!_isMenuExpanded)
    {
        _isMenuExpanded = YES;
        
        UIView *tempView;
        CGFloat x = 0.0;
        CGFloat y = 0.0;
        CGPoint center = sender.center;
        for (int i = 0; i < _menuItems.count; i++)
        {
            tempView = _menuItems[i];
            tempView.hidden = NO;
            tempView.center = _mainMenuButton.center;
            
            switch (i)
            {
                case 0:
                {
                    x = center.x - kMenuRadius;
                    y = center.y;
                    
                    break;
                }
                    
                case 1:
                {
                    x = center.x - sqrt((kMenuRadius * kMenuRadius) / 2.0);
                    y = center.y - sqrt((kMenuRadius * kMenuRadius) / 2.0);
                    
                    break;
                }
                    
                case 2:
                {
                    x = center.x;
                    y = center.y - kMenuRadius;
                    
                    break;
                }
                    
                case 3:
                {
                    x = center.x + sqrt((kMenuRadius * kMenuRadius) / 2.0);
                    y = center.y - sqrt((kMenuRadius * kMenuRadius) / 2.0);
                    
                    break;
                }
                    
                case 4:
                {
                    x = center.x + kMenuRadius;
                    y = center.y;
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            [UIView animateWithDuration:0.63 delay:0.0 usingSpringWithDamping:0.37 initialSpringVelocity:0.63 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                tempView.alpha = 1.0;
                tempView.center = CGPointMake(x, y);
                
            } completion:nil];
            
        }
    }
    else
    {
        _isMenuExpanded = NO;
        
        for (UIView *tempView in _menuItems)
        {
            [UIView animateWithDuration:0.37 animations:^{
                
                tempView.center = sender.center;
                tempView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                tempView.hidden = YES;
            }];
        }
        
    }
}
- (IBAction)popDirectionChangeAction:(id)sender
{
    
    if (_isArrowMenuExpanded)
    {
        [self resetArrowMenuItems];
    }
    
    if (_popDirectionSwitch.isOn)
    {
        _popDirection = ePopDirectionForHorizon;
        _popDirectionLabel.text = @"水平向右";
    }
    else
    {
        _popDirection = ePopDirectionForVertical;
        _popDirectionLabel.text = @"垂直向下";
    }
}

- (void)arrowMenuClickAction:(id)sender
{
    if (!_isArrowMenuExpanded)
    {
        _isArrowMenuExpanded = YES;
        
        if (_popDirection == ePopDirectionForHorizon)
        {
            UIView *tempView;
            CGFloat x = 0.0;
            CGFloat y = _arrowMenuView.center.y;
            for (int i = 0; i < _arrowMenuItems.count; i++)
            {
                tempView = _arrowMenuItems[i];
                tempView.hidden = NO;
                tempView.center = _arrowMenuView.center;
                
                x = _arrowMenuView.frame.origin.x + (kMenuItemWidth * i) + (kMenuItemWidth / 2.0);
                
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.63];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tempView cache:YES];
                
                tempView.alpha = 1.0;
                tempView.center = CGPointMake(x, y);
                
                [UIView commitAnimations];
            }
            
            x = _arrowMenuView.frame.origin.x + (kMenuItemWidth * _arrowMenuItems.count) + (kMenuItemWidth / 2.0);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.63];
            
            _arrowMenuView.center = CGPointMake(x, y);
            
            [UIView commitAnimations];
        }
        else
        {
            UIView *tempView;
            CGFloat x = _arrowMenuView.center.x;
            CGFloat y = 0.0f;
            for (int i = 0; i < _arrowMenuItems.count; i++)
            {
                tempView = _arrowMenuItems[i];
                tempView.hidden = NO;
                tempView.center = _arrowMenuView.center;
                
                y = _arrowMenuView.frame.origin.y + (kMenuItemHeight * i) + (kMenuItemHeight / 2.0);
                
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.63];
                
                tempView.alpha = 1.0;
                tempView.center = CGPointMake(x, y);
                
                [UIView commitAnimations];
            }
            
            y = _arrowMenuView.frame.origin.y + (kMenuItemHeight * _arrowMenuItems.count) + (kMenuItemHeight / 2.0);
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.63];
            
            _arrowMenuView.center = CGPointMake(x, y);
            
            [UIView commitAnimations];
        }
        
        
    }
    else
    {
        [self resetArrowMenuItems];
    }
    
}

- (void)resetArrowMenuItems
{
    _isArrowMenuExpanded = NO;
    
    
    CGFloat x;
    CGFloat y;
    
    if (_popDirection == ePopDirectionForHorizon)
    {
        x = _arrowMenuView.frame.origin.x - (kMenuItemWidth * _arrowMenuItems.count) + (kMenuItemWidth / 2.0);
        y = _arrowMenuView.center.y;
    }
    else
    {
        x = _arrowMenuView.center.x;
        y = _arrowMenuView.frame.origin.y - (kMenuItemHeight * _arrowMenuItems.count) + (kMenuItemHeight / 2.0);
    }

    for (UIView *tempView in _arrowMenuItems)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.63];
        
        if (_popDirection == ePopDirectionForHorizon)
        {
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:tempView cache:YES];
        }
        
        tempView.center = CGPointMake(x, y);
        tempView.alpha = 0.0;
        
        [UIView commitAnimations];
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.63];
    
    _arrowMenuView.center = CGPointMake(x, y);
    
    [UIView commitAnimations];
}


@end
