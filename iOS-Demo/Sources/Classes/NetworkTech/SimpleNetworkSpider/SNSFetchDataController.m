//
//  SNSFetchDataController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/2/17.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "SNSFetchDataController.h"
#import "SNSHtmlHelper.h"
#import "NSString+StringRegular.h"
#import "SNS_MatchingRuleModel.h"
#import "SNS_ReplacingRuleModel.h"
#import "LMPopMenu.h"
#import "SNSNetworkAddressListController.h"

@interface SNSFetchDataController ()

@end

@implementation SNSFetchDataController
{
    __weak IBOutlet UITextView *_fetchedDataTextView;
    __weak IBOutlet UIActivityIndicatorView *_activityIndicatorView;
    
    NSString *_htmlContent;
    NSMutableArray<NSString *> *_fetchedResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIComponents];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self startFetchData];
    });
}

- (void)initializeUIComponents
{
    [_activityIndicatorView startAnimating];
}


- (void)startFetchData
{
    _htmlContent = [SNSHtmlHelper htmlFromUrl:_networkAddress];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.title = @"正在解析...";
    });
    
    [self applyMatchingRules];
    [self applyReplacingRules];
}

- (void)applyMatchingRules
{
    if (_matchingRules.count > 0)
    {
        NSMutableString *regstr = [NSMutableString new];
        
        SNS_MatchingRuleModel *theModel;
        for (int i = 0; i < _matchingRules.count; i++)
        {
            theModel = _matchingRules[i];
            
            if (i == 0)
            {
                [regstr appendString:theModel.matchingRuleContent];
            }
            else
            {
                [regstr appendFormat:@"|%@", theModel.matchingRuleContent];
            }
        }
        
        _fetchedResults = [_htmlContent substringByRegular:regstr];
        
        NSSet *theSet = [NSSet setWithArray:_fetchedResults];
        [_fetchedResults removeAllObjects];
        for (NSString *theStr in theSet)
        {
            [_fetchedResults addObject:theStr];
        }
    }
}

- (void)applyReplacingRules
{
    if (_replacingRules.count > 0)
    {
        if (_fetchedResults.count > 0)
        {
            NSString *tempStr = nil;
            NSMutableArray *tempMutArr = [NSMutableArray new];;
            for (NSString *theStr in _fetchedResults)
            {
                for (SNS_ReplacingRuleModel *theModel in _replacingRules)
                {
                    @autoreleasepool
                    {
                        tempStr = [theStr stringByReplacingOccurrencesOfString:theModel.beforeReplaceContent withString:theModel.afterReplaceContent];
                    }
                }
                [tempMutArr addObject:tempStr];
            }
            
            _fetchedResults = tempMutArr;
        }
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_fetchedResults.count > 0)
        {
            NSMutableString *finishedText = [NSMutableString new];
            for (NSString *theStr in _fetchedResults)
            {
                [finishedText appendFormat:@"%@\n", theStr];
            }
            
            _fetchedDataTextView.text = finishedText;
        }
        else
        {
            _fetchedDataTextView.text = @"### 没有抓取到符合条件的数据 ###";
        }
        
        self.title = @"抓取完成";
        [_activityIndicatorView stopAnimating];
    });
}


#pragma mark -- Actions

- (IBAction)moreAction:(id)sender
{
    [[LMPopMenu sharePopMenu] showPopMenuWithPoint:CGPointMake(kDeviceWidth - 24.0f, 64.0f) menuTitles:@[@"复制", @"浏览器打开"] menuIcons:nil clickItemBlock:^(NSInteger index) {
       
        switch (index)
        {
            case 0:
            {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = _fetchedDataTextView.text;
                
                break;
            }
                
            case 1:
            {
                SNSNetworkAddressListController *controller = kInstanceFromStoryboard(@"SNSNetworkAddressListController", @"SNSNetworkAddressListController");
                controller.fetchedResults = _fetchedResults;
                kPushViewControllerWithController(controller);
                
                break;
            }
                
            default:
                break;
        }
    }];
}



@end
