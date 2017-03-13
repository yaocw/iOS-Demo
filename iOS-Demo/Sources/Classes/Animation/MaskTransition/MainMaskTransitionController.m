//
//  MainMaskTransitionController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MainMaskTransitionController.h"
#import "OtherMaskTransitionController.h"
#import "MTPushTransition.h"

@interface MainMaskTransitionController () <UINavigationControllerDelegate>

@end

@implementation MainMaskTransitionController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBaseData];
    [self initializeUIComponents];
}

- (void)initializeBaseData
{
    
}

- (void)initializeUIComponents
{
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    OtherMaskTransitionController *controller = kInstanceFromStoryboard(@"OtherMaskTransitionController", @"OtherMaskTransitionController");
    kPushViewControllerWithController(controller);
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        MTPushTransition *transition = [MTPushTransition new];
        return transition;
    }
    else
    {
        return nil;
    }
}

@end
