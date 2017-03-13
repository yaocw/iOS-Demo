//
//  MainStoreHouseTransitionController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/3/9.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "MainStoreHouseTransitionController.h"
#import "CBStoreHouseTransition.h"
#import "OtherStoreHouseTransitionController.h"

@interface MainStoreHouseTransitionController () <UINavigationControllerDelegate>

@property (nonatomic, strong) CBStoreHouseTransitionAnimator *animator;
@property (nonatomic, strong) CBStoreHouseTransitionInteractiveTransition *interactiveTransition;

@end

@implementation MainStoreHouseTransitionController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    self.interactiveTransition = [CBStoreHouseTransitionInteractiveTransition new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.delegate == self)
    {
        self.navigationController.delegate = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [CBStoreHouseTransitionAnimator new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    OtherStoreHouseTransitionController *controller = kInstanceFromStoryboard(@"OtherStoreHouseTransitionController", @"OtherStoreHouseTransitionController");
    controller.superController = self;
    [self.interactiveTransition attachToViewController:controller];
    kPushViewControllerWithController(controller);
}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                 animationControllerForOperation:(UINavigationControllerOperation)operation
                                              fromViewController:(UIViewController *)fromVC
                                                toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        self.interactiveTransition = nil;
        self.animator.type = AnimationTypePush;
        return self.animator;
    }
    else
    {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

@end
