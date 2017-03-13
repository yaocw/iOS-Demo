//
//  NetworkStateMonitorController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "NetworkStateMonitorController.h"
#import "Reachability.h"

@interface NetworkStateMonitorController ()

@end

@implementation NetworkStateMonitorController
{
    __weak IBOutlet UILabel *_networkAvailableStateLabel;
    
    
    Reachability *_hostReach;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    _hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [_hostReach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    switch (status)
    {
        case NotReachable:
        {
            _networkAvailableStateLabel.text = @"网络状态：不可用";
            break;
        }
            
        case ReachableViaWiFi:
        {
            _networkAvailableStateLabel.text = @"网络状态：WiFi可用";
            break;
        }
            
        case ReachableViaWWAN:
        {
            NSString *networkState = [self getNetWorkStates];
            if (kIsNotNullOrEmptyWithString(networkState))
            {
                _networkAvailableStateLabel.text = [NSString stringWithFormat:@"网络状态：WWAN-%@ 可用", networkState];
            }
            else
            {
                _networkAvailableStateLabel.text = @"网络状态：WWAN可用";
            }
            break;
        }
            
        default:
            break;
    }
}

- (NSString *)getNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    
    int netType = 0;
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
        {
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state =  @"2G";
                    break;
                case 2:
                    state =  @"3G";
                    break;
                case 3:
                    state =   @"4G";
                    break;
                case 5:
                {
                    state =  @"wifi";
                    break;
                default:
                    break;
                }
            }
        }
    }
    
    return state;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
