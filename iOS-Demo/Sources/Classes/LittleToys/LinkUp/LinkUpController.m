//
//  LinkUpController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/22.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "LinkUpController.h"
#import "LUButton.h"

#define mLinkUpRow 8
#define mLinkUpColumn 5

typedef enum : NSInteger {
    eLUMoveDirectionForUnknow = -1,
    eLUMoveDirectionForUp = 0,
    eLUMoveDirectionForDown,
    eLUMoveDirectionForLeft,
    eLUMoveDirectionForRight,
} LUMoveDirection;

#define mIconButtonStateForAssistor @(-1)  //用于辅助作用
#define mIconButtonStateForDisappear @(0)  //已经消灭掉的状态
#define mIconButtonStateForAppear @(1)  //未被消灭掉的状态

@interface LinkUpController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@end

@implementation LinkUpController
{
    NSMutableArray *_iconButtons;
    NSMutableArray *_iconButtonStates;
    
    LUButton *_previousButton;
    LUButton *_currentButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}


- (void)initializeBaseData
{
    _iconButtons = [NSMutableArray new];
    _iconButtonStates = [NSMutableArray new];
    
    NSMutableArray *theMutArr;
    for (int i = 0; i < (mLinkUpRow + 2); i ++)
    {
        theMutArr = [NSMutableArray new];
        
        if (i == 0  || (i == (mLinkUpRow + 1))) // 第一行和最后一行的数组元素用作辅助
        {
            for (int j = 0; j < (mLinkUpColumn + 2); j ++)
            {
                [theMutArr addObject:mIconButtonStateForAssistor];
            }
            
            [_iconButtonStates addObject:theMutArr];
        }
        else
        {
            for (int j = 0; j < (mLinkUpColumn + 2); j ++)
            {
                if (j == 0  || (j == (mLinkUpColumn + 1))) // 第一列和最后一列的数组元素用作辅助
                {
                    [theMutArr addObject:mIconButtonStateForAssistor];
                }
                else
                {
                    [theMutArr addObject:mIconButtonStateForAppear];
                }
            }
            
            [_iconButtonStates addObject:theMutArr];
        }
    }
}

- (void)initializeUIComponents
{
    _backgroundImageView.alpha = 0;
    
    NSMutableArray *iconButtonColors = [NSMutableArray new];
    UIColor *randomColor;
    for (int i = 0; i < ((mLinkUpRow * mLinkUpColumn) / 4); i ++)
    {
        randomColor = kRandomColor;
        [iconButtonColors addObject:randomColor];
        [iconButtonColors addObject:randomColor];
        [iconButtonColors addObject:randomColor];
        [iconButtonColors addObject:randomColor];
    }
    
    
    
    
    CGSize mLinkUpIconSize = CGSizeMake(kDeviceWidth/mLinkUpColumn, (kDeviceHeight - 64.0f)/mLinkUpRow);
    int randomColorIndex;
    for (int i = 0; i < mLinkUpRow; i ++)
    {
        for (int j = 0; j < mLinkUpColumn; j ++)
        {
            LUButton *btn = [[LUButton alloc] initWithFrame:CGRectMake(j * mLinkUpIconSize.width, 64.0f + i * mLinkUpIconSize.height, mLinkUpIconSize.width, mLinkUpIconSize.height)];
            [btn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
            
            btn.row = i + 1;
            btn.column = j + 1;
            
            randomColorIndex = kGetRandomIntWithUpperLimit(iconButtonColors.count);
            btn.backgroundColor = iconButtonColors[randomColorIndex];
            [iconButtonColors removeObjectAtIndex:randomColorIndex];
            
            [self.view addSubview:btn];
            [_iconButtons addObject:btn];
        }
    }
}

- (void)touchDown:(LUButton *)sender
{
    if (sender.isSelected)
    {
        [sender setSelected:NO];
        _previousButton = nil;
        _currentButton = nil;
    }
    else
    {
        _previousButton = [self getPreviousButton];
        _currentButton = sender;
        [sender setSelected:YES];
    }
}

- (LUButton *)getPreviousButton
{
    LUButton *selectedButton = nil;
    for (LUButton *btn in _iconButtons)
    {
        if (btn.isSelected)
        {
            selectedButton = btn;
        }
    }
    
    return selectedButton;
}

- (void)touchUpOutside:(LUButton *)sender
{
    [sender setSelected:NO];
}

- (void)touchUpInside:(LUButton *)sender
{
    if ([self hasSelectedTwoButton])
    {
        if ([self hasTheReachableRouteForSelectedButtons])
        {
            _iconButtonStates[_previousButton.row][_previousButton.column] = mIconButtonStateForDisappear;
            _iconButtonStates[_currentButton.row][_currentButton.column] = mIconButtonStateForDisappear;
            
            [_previousButton removeFromSuperview];
            [_currentButton removeFromSuperview];
            [_iconButtons removeObject:_previousButton];
            [_iconButtons removeObject:_currentButton];
            
            _previousButton = nil;
            _currentButton = nil;
            
            _backgroundImageView.alpha = _backgroundImageView.alpha + 0.05f;
        }
        else
        {
            [_previousButton setSelected:NO];
            [_currentButton setSelected:NO];
            
            _previousButton = nil;
            _currentButton = nil;
        }
    }
}

- (BOOL)hasSelectedTwoButton
{
    int selectedButtonCounter = 0;
    for (LUButton *btn in _iconButtons)
    {
        if (btn.isSelected)
        {
            selectedButtonCounter ++;
        }
    }
    
    return (selectedButtonCounter >= 2);
}

- (BOOL)hasTheReachableRouteForSelectedButtons
{
    if (!CGColorEqualToColor(_previousButton.backgroundColor.CGColor, _currentButton.backgroundColor.CGColor))
    {
        return NO;
    }
    
    if ((_previousButton.row == _currentButton.row) || (_previousButton.column == _currentButton.column))
    {
        if ([self hasReachableRouteWithOneStep:_previousButton and:_currentButton])
        {
            return YES;
        }
        else
        {
            return [self hasReachableRouteWithThreeStep:_previousButton and:_currentButton];
        }
    }
    else
    {
        if ([self hasReachableRouteWithTwoStep:_previousButton and:_currentButton])
        {
            return YES;
        }
        else
        {
            return [self hasReachableRouteWithThreeStep:_previousButton and:_currentButton];
        }
    }
}


/**
 *  处理直连的情况
 **/
- (BOOL)hasReachableRouteWithOneStep:(LUButton *)previousButton and:(LUButton *)currentButton
{
    //选中的两个图标在同一行
    if (previousButton.row == currentButton.row)
    {
        if ((previousButton.column - currentButton.column) == 1) //如果是相邻的图标，则可以到达
        {
            return YES;
        }
        else  //如果不是相邻的图标，则要判断它们之间有没有障碍
        {
            BOOL hasObstacle = NO;
            if (previousButton.column > currentButton.column)
            {
                for (int i = currentButton.column + 1; i < previousButton.column; i ++)
                {
                    if (((NSNumber *)_iconButtonStates[currentButton.row][i]).integerValue > 0)
                    {
                        hasObstacle = YES;
                        break;
                    }
                }
            }
            else
            {
                for (int i = previousButton.column + 1; i < currentButton.column; i ++)
                {
                    if (((NSNumber *)_iconButtonStates[currentButton.row][i]).integerValue > 0)
                    {
                        hasObstacle = YES;
                        break;
                    }
                }
            }
            
            if (hasObstacle)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    
    
    //先跟的图标在同一列
    if (previousButton.column == currentButton.column)
    {
        if ((previousButton.row - currentButton.row) == 1) //如果是相邻的图标，则可以到达
        {
            return YES;
        }
        else  //如果不是相邻的图标，则要判断它们之间有没有障碍
        {
            BOOL hasObstacle = NO;
            if (previousButton.row > currentButton.row)
            {
                for (int i = currentButton.row + 1; i < previousButton.row; i ++)
                {
                    if (((NSNumber *)_iconButtonStates[i][currentButton.column]).integerValue > 0)
                    {
                        hasObstacle = YES;
                        break;
                    }
                }
            }
            else
            {
                for (int i = previousButton.row + 1; i < currentButton.row; i ++)
                {
                    if (((NSNumber *)_iconButtonStates[i][currentButton.column]).integerValue > 0)
                    {
                        hasObstacle = YES;
                        break;
                    }
                }
            }
            
            if (hasObstacle)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    
    
    return NO;
}


/**
 *  处理需要两次连接的情况
 **/
- (BOOL)hasReachableRouteWithTwoStep:(LUButton *)previousButton and:(LUButton *)currentButton
{
    if ((previousButton.row == currentButton.row) || (previousButton.column == currentButton.column))
    {
        return NO;
    }
    
    if ((abs(previousButton.row - currentButton.row) == 1) && (abs(previousButton.column - currentButton.column) == 1)) //处理相邻的情况
    {
        BOOL hasObstacle = NO;
        if ((previousButton.row < currentButton.row) && (previousButton.column < currentButton.column))
        {
            if ((((NSNumber *)_iconButtonStates[previousButton.row][currentButton.column]).integerValue > 0)
                && (((NSNumber *)_iconButtonStates[currentButton.row][previousButton.column]).integerValue > 0))
            {
                hasObstacle = YES;
            }
        }
        else if ((previousButton.row < currentButton.row) && (previousButton.column > currentButton.column))
        {
            if ((((NSNumber *)_iconButtonStates[previousButton.row][currentButton.column]).integerValue > 0)
                && (((NSNumber *)_iconButtonStates[currentButton.row][previousButton.column]).integerValue > 0))
            {
                hasObstacle = YES;
            }
        }
        else if ((previousButton.row > currentButton.row) && (previousButton.column < currentButton.column))
        {
            if ((((NSNumber *)_iconButtonStates[currentButton.row][previousButton.column]).integerValue > 0)
                && (((NSNumber *)_iconButtonStates[previousButton.row][currentButton.column]).integerValue > 0))
            {
                hasObstacle = YES;
            }
        }
        else
        {
            if ((((NSNumber *)_iconButtonStates[currentButton.row][previousButton.column]).integerValue > 0)
                && (((NSNumber *)_iconButtonStates[previousButton.row][currentButton.column]).integerValue > 0))
            {
                hasObstacle = YES;
            }
        }
        
        if (hasObstacle)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else  //处理不相邻的情况
    {
        if ((previousButton.row < currentButton.row) && (previousButton.column < currentButton.column))
        {
            BOOL hasObstacleWithFirstRoute = NO;
            BOOL hasObstacleWithSecondRoute = NO;
            for (int i = (previousButton.column + 1); i <= currentButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[previousButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            for (int i = previousButton.row; i < currentButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][currentButton.column]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            
            
            for (int i = (previousButton.row + 1); i <= currentButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][previousButton.column]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            for (int i = previousButton.column; i < currentButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[currentButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            if (hasObstacleWithFirstRoute && hasObstacleWithSecondRoute)
            {
                return NO;
            }
            else
            {
                return YES;
            }
            
        }
        else if ((previousButton.row < currentButton.row) && (previousButton.column > currentButton.column))
        {
            BOOL hasObstacleWithFirstRoute = NO;
            BOOL hasObstacleWithSecondRoute = NO;
            for (int i = currentButton.column; i < previousButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[previousButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            for (int i = previousButton.row; i < currentButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][currentButton.column]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            
            for (int i = (previousButton.row + 1); i <= currentButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][previousButton.column]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            for (int i = (currentButton.column + 1); i <= previousButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[currentButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            if (hasObstacleWithFirstRoute && hasObstacleWithSecondRoute)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
        else if ((previousButton.row > currentButton.row) && (previousButton.column < currentButton.column))
        {
            BOOL hasObstacleWithFirstRoute = NO;
            BOOL hasObstacleWithSecondRoute = NO;
            for (int i = currentButton.row; i < previousButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][previousButton.column]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            for (int i = previousButton.column; i < currentButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[currentButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            
            for (int i = (previousButton.column + 1); i <= currentButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[previousButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            for (int i = (currentButton.row + 1); i <= previousButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][currentButton.column]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            
            if (hasObstacleWithFirstRoute && hasObstacleWithSecondRoute)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
        else
        {
            BOOL hasObstacleWithFirstRoute = NO;
            BOOL hasObstacleWithSecondRoute = NO;
            for (int i = (currentButton.row + 1); i < previousButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][previousButton.column]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            for (int i = (currentButton.column + 1); i <= previousButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[currentButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithFirstRoute = YES;
                }
            }
            
            
            for (int i = currentButton.column; i < previousButton.column; i++)
            {
                if (((NSNumber *)_iconButtonStates[previousButton.row][i]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            for (int i = (currentButton.row + 1); i < previousButton.row; i ++)
            {
                if (((NSNumber *)_iconButtonStates[i][currentButton.column]).integerValue > 0)
                {
                    hasObstacleWithSecondRoute = YES;
                }
            }
            
            
            if (hasObstacleWithFirstRoute && hasObstacleWithSecondRoute)
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
}


/**
 *  处理需要三次连接的情况
 **/
- (BOOL)hasReachableRouteWithThreeStep:(LUButton *)previousButton and:(LUButton *)currentButton
{
    BOOL isReachable = NO;
    
    NSMutableArray *theMutArr = [NSMutableArray new];
    for (int i = 0; i < (mLinkUpRow + 2); i ++)
    {
        if (i != previousButton.row)
        {
            if (((NSNumber *)_iconButtonStates[i][previousButton.column]).intValue <= 0)
            {
                [theMutArr addObject:[NSIndexPath indexPathForRow:i inSection:previousButton.column]];
            }
        }
    }
    
    
    for (int i = 0; i < (mLinkUpColumn + 2); i++)
    {
        if (i != previousButton.column)
        {
            if (((NSNumber *)_iconButtonStates[previousButton.row][i]).intValue <= 0)
            {
                [theMutArr addObject:[NSIndexPath indexPathForRow:previousButton.row inSection:i]];
            }
        }
    }
    
    
    NSMutableArray *oneStepIcons = [NSMutableArray new];
    
    LUButton *tempCurrentButton = [LUButton new];
    for (NSIndexPath *indexPath in theMutArr)
    {
        tempCurrentButton.row = (int)indexPath.row;
        tempCurrentButton.column = (int)indexPath.section;
        if ([self hasReachableRouteWithOneStep:_previousButton and:tempCurrentButton])
        {
            [oneStepIcons addObject:indexPath];
        }
    }
    
    LUButton *tempPreviousButton = [LUButton new];
    for (NSIndexPath *indexPath in oneStepIcons)
    {
        tempPreviousButton.row = (int)indexPath.row;
        tempPreviousButton.column = (int)indexPath.section;
        if ([self hasReachableRouteWithTwoStep:tempPreviousButton and:_currentButton])
        {
            isReachable = YES;
        }
    }
    
    if (isReachable)
    {
        return YES;
    }

    
    [theMutArr removeAllObjects];
    for (int i = 0; i < (mLinkUpRow + 2); i ++)
    {
        if (i != currentButton.row)
        {
            if (((NSNumber *)_iconButtonStates[i][currentButton.column]).intValue <= 0)
            {
                [theMutArr addObject:[NSIndexPath indexPathForRow:i inSection:currentButton.column]];
            }
        }
    }
    
    
    for (int i = 0; i < (mLinkUpColumn + 2); i++)
    {
        if (i != currentButton.column)
        {
            if (((NSNumber *)_iconButtonStates[currentButton.row][i]).intValue <= 0)
            {
                [theMutArr addObject:[NSIndexPath indexPathForRow:currentButton.row inSection:i]];
            }
        }
    }
    
    [oneStepIcons removeAllObjects];
    for (NSIndexPath *indexPath in theMutArr)
    {
        tempPreviousButton.row = (int)indexPath.row;
        tempPreviousButton.column = (int)indexPath.section;
        if ([self hasReachableRouteWithOneStep:tempPreviousButton and:currentButton])
        {
            [oneStepIcons addObject:indexPath];
        }
    }
    
    for (NSIndexPath *indexPath in oneStepIcons)
    {
        tempCurrentButton.row = (int)indexPath.row;
        tempCurrentButton.column = (int)indexPath.section;
        if ([self hasReachableRouteWithTwoStep:_previousButton and:tempCurrentButton])
        {
            isReachable = YES;
        }
    }
    
    if (isReachable)
    {
        return YES;
    }
    
    
    return NO;
}


#pragma mark -- Actions

- (IBAction)resetAction:(id)sender
{
    for (LUButton *btn in _iconButtons)
    {
        [btn removeFromSuperview];
    }
    
    _previousButton = nil;
    _currentButton = nil;
    
    [self initializeBaseData];
    [self initializeUIComponents];
}


@end



