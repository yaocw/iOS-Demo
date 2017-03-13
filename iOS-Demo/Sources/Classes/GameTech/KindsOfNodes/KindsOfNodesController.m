//
//  KindsOfNodesController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/19.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "KindsOfNodesController.h"

#import <SpriteKit/SpriteKit.h>

#import "ShowNodesScene.h"

@interface KindsOfNodesController ()

@end

@implementation KindsOfNodesController

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
    
    ShowNodesScene *showNodesScene = [[ShowNodesScene alloc] initWithSize:CGSizeMake(kDeviceWidth, kDeviceHeight)];
    [spriteView presentScene:showNodesScene];
}


@end
