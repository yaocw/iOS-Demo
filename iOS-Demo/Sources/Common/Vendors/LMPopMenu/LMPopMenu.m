//
//  LMPopMenu.m
//  MobileOfficing
//
//  Created by yaochaowen on 16/8/2.
//  Copyright © 2016年 SZHHXH. All rights reserved.
//

#import "LMPopMenu.h"
#import "NirKxMenu.h"

@implementation LMPopMenu
{
    BLKSelecetIndexBlock _clickItemBlock;
}

+ (instancetype)sharePopMenu
{
    static LMPopMenu *sharedInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (void)showPopMenuWithPoint:(CGPoint)point menuTitles:(NSArray *)titles menuIcons:(NSArray *)icons clickItemBlock:(BLKSelecetIndexBlock)aBlock
{
    if (titles.count == 0)
    {
        return ;
    }
    
    _clickItemBlock = aBlock;
    
    
    KxMenuItem *menuItem = nil;
    NSString *title;
    NSString *icon;
    NSMutableArray *menuItems = [NSMutableArray new];
    
    for (int i = 0; i < titles.count; i++)
    {
        title = titles[i];
        
        if (icons.count > i)
        {
            icon = icons[i];
            menuItem = [KxMenuItem menuItem:title image:[UIImage imageNamed:icon] target:self action:@selector(clickItem:)];
        }
        else
        {
            menuItem = [KxMenuItem menuItem:title image:nil target:self action:@selector(clickItem:)];
        }
        
        menuItem.tag = i;
        [menuItems addObject:menuItem];
    }
    
    OptionalConfiguration optional;
    optional.arrowSize = 9;  //指示箭头大小
    optional.marginXSpacing = 16;  //MenuItem左右边距
    optional.marginYSpacing = 9;  //MenuItem上下边距
    optional.intervalSpacing = 25;  //MenuItemImage与MenuItemTitle的间距
    optional.menuCornerRadius = 5;  //菜单圆角半径
    optional.maskToBackground = YES;  //是否添加覆盖在原View上的半透明遮罩
    optional.shadowOfMenu = YES;  //是否添加菜单阴影
    optional.hasSeperatorLine = YES;  //是否设置分割线
    optional.seperatorLineHasInsets = NO;  //是否在分割线两侧留下Insets
    
    Color textColor;
    textColor.R = 0.2;
    textColor.G = 0.2;
    textColor.B = 0.2;
    optional.textColor = textColor;  //menuItem字体颜色
    
    Color menuBackgroundColor;
    menuBackgroundColor.R = 1;
    menuBackgroundColor.G = 1;
    menuBackgroundColor.B = 1;
    optional.menuBackgroundColor = menuBackgroundColor;  //菜单的底色
    
    [KxMenu showMenuInView:kWindow fromRect:CGRectMake(point.x, point.y, 0, 0) menuItems:menuItems withOptions:optional];
    
}

- (void)clickItem:(KxMenuItem *)sender
{
    _clickItemBlock ? _clickItemBlock(sender.tag) : nil;
}


@end
