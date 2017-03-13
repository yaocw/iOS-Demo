//
//  CollisionEffectController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/15.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "CollisionEffectController.h"

#import <SpriteKit/SpriteKit.h>

#import "CollisionEffectScene.h"


@interface CollisionEffectController ()

@end

@implementation CollisionEffectController

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
    
    CollisionEffectScene *collisionEffectScene = [[CollisionEffectScene alloc] initWithSize:CGSizeMake(kDeviceWidth, kDeviceHeight)];
    [spriteView presentScene:collisionEffectScene];
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
