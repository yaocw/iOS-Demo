//
//  SuperJumperController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/11.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SuperJumperController.h"

#import <SpriteKit/SpriteKit.h>

#import "SJMainScene.h"

@interface SuperJumperController ()

@end

@implementation SuperJumperController

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
    
    SJMainScene *mainScene = [[SJMainScene alloc] initWithSize:CGSizeMake(kDeviceWidth, kDeviceHeight)];
    [spriteView presentScene:mainScene];
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
