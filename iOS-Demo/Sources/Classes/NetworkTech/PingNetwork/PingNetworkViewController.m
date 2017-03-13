//
//  PingNetworkViewController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "PingNetworkViewController.h"
#import "STDPingServices.h"

@interface PingNetworkViewController ()

@end

@implementation PingNetworkViewController
{
    __weak IBOutlet UITextField *_networkAddressTextField;
    __weak IBOutlet UITextView *_pingMessageTextView;
    
    STDPingServices *_pingServices;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (IBAction)clearAction:(id)sender
{
    _pingMessageTextView.text = @"";
}

- (IBAction)pingAction:(UIButton *)sender
{
    if (kIsNullOrEmptyWithString(_networkAddressTextField.text))
    {
        [_networkAddressTextField becomeFirstResponder];
    }
    else
    {
        [_networkAddressTextField resignFirstResponder];
        
        if ([sender.titleLabel.text isEqualToString:@"Ping"])
        {
            [sender setTitle:@"Stop" forState:UIControlStateNormal];
            
            _pingServices = [STDPingServices startPingAddress:_networkAddressTextField.text callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
                
                if (pingItem.status != STDPingStatusFinished)
                {
                    _pingMessageTextView.text = [NSString stringWithFormat:@"%@\n%@", _pingMessageTextView.text, pingItem.description];
                }
                else
                {
                    _pingMessageTextView.text = [NSString stringWithFormat:@"%@\n%@", _pingMessageTextView.text, [STDPingItem statisticsWithPingItems:pingItems]];
                    _pingServices = nil;
                }
                
                _pingMessageTextView.layoutManager.allowsNonContiguousLayout = NO;
                [_pingMessageTextView scrollRangeToVisible:NSMakeRange(_pingMessageTextView.text.length, 1)];
            }];
        }
        else
        {
            [sender setTitle:@"Ping" forState:UIControlStateNormal];
            
            [_pingServices cancel];
        }
    }
}

@end
