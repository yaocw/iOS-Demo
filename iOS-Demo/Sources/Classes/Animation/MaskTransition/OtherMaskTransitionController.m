//
//  OtherMaskTransitionController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "OtherMaskTransitionController.h"
#import "MTPopTransition.h"

@interface OtherMaskTransitionController () <UINavigationControllerDelegate>

@end

@implementation OtherMaskTransitionController

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop)
    {
        MTPopTransition *transiation = [MTPopTransition new];
        return transiation;
    }
    else
    {
        return nil;
    }
}

@end
