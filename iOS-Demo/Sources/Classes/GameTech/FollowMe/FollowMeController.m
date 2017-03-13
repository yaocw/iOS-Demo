//
//  FollowMeController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "FollowMeController.h"

#import <SpriteKit/SpriteKit.h>

#import "FollowMeScene.h"

@interface FollowMeController ()

@end

@implementation FollowMeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeSpriteView];
}

- (void)initializeSpriteView
{
    SKView *spriteView = (SKView *)self.view;
    spriteView.showsFPS = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsDrawCount = YES;
    
    FollowMeScene *followMeScene = [[FollowMeScene alloc] initWithSize:CGSizeMake(kDeviceWidth, kDeviceHeight)];
    [spriteView presentScene:followMeScene];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
