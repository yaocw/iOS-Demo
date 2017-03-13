//
//  SimpleNetworkSpiderController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/16.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SimpleNetworkSpiderController.h"
#import "SNS_MatchingRuleView.h"
#import "SNS_ReplacingRuleView.h"
#import "SNSFetchDataController.h"

@interface SimpleNetworkSpiderController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SimpleNetworkSpiderController
{
    __weak IBOutlet UITextField *_networkAddressTextField;
    __weak IBOutlet SNS_MatchingRuleView *_matchingRuleView;
    __weak IBOutlet SNS_ReplacingRuleView *_replacingRuleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initializeUIComponents];
}



- (void)initializeUIComponents
{
    kRemoveBottomLinesForTableView(self.tableView);
    
    [_matchingRuleView setDidChangedHeightBlock:^{
       
        [self.tableView reloadData];
    }];
    
    [_replacingRuleView setDidChangedHeightBlock:^{
        
        [self.tableView reloadData];
    }];
}


#pragma mark -- UITableView Database

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            return 56.0f;
        }
            
        case 1:
        {
            return _matchingRuleView.bounds.size.height + 40.0f;
        }
            
        case 2:
        {
            return _replacingRuleView.bounds.size.height + 40.0f;
        }
            
        default:
            break;
    }
    
    return 0;
}


#pragma mark -- UITableView ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}


#pragma mark -- Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [_networkAddressTextField resignFirstResponder];
    
    if ([segue.identifier isEqualToString:@"SNSFetchDataController"])
    {
        SNSFetchDataController *controller = segue.destinationViewController;
        
        controller.networkAddress = _networkAddressTextField.text;
        controller.matchingRules = _matchingRuleView.matchingRules;
        controller.replacingRules = _replacingRuleView.replacingRules;
    }
}

#pragma mark -- Actions

- (IBAction)fetchAction:(id)sender
{
    NSLog(@"%@", _matchingRuleView.matchingRules);
    NSLog(@"%@", _replacingRuleView.replacingRules);
}

@end
