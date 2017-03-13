//
//  CompassController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/20.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "CompassController.h"
#import "SPCompassView.h"


@interface CompassController ()

@end

@implementation CompassController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    SPCompassView *compassView = [SPCompassView sharedWithRect:self.view.bounds radius:(self.view.bounds.size.width-20)/2];
    compassView.backgroundColor = [UIColor blackColor];
    compassView.textColor = [UIColor whiteColor];
    compassView.calibrationColor = [UIColor whiteColor];
    compassView.horizontalColor = [UIColor purpleColor];
    [self.view addSubview:compassView];
}


@end
