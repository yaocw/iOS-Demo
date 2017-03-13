//
//  SpriteWalkThroughController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/14.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SpriteWalkThroughController.h"

#import <SpriteKit/SpriteKit.h>

#import "HelloScene.h"

@interface SpriteWalkThroughController ()

@end

@implementation SpriteWalkThroughController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *spriteView = (SKView *)self.view;
    spriteView.showsDrawCount = YES;
    spriteView.showsNodeCount = YES;
    spriteView.showsFPS = YES;
    
    HelloScene *helloScene = [[HelloScene alloc] initWithSize:CGSizeMake(kDeviceWidth, kDeviceHeight)];
    [spriteView presentScene:helloScene];
    
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
