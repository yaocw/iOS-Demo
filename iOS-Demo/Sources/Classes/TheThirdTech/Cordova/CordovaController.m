//
//  CordovaController.m
//  MyAllDemos
//
//  Created by yaochaowen on 2017/1/18.
//  Copyright © 2017年 yaochaowen. All rights reserved.
//

#import "CordovaController.h"

@interface CordovaController ()

@end

@implementation CordovaController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) { }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) { }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}



#pragma mark UIWebDelegate implementation

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    theWebView.backgroundColor = [UIColor blackColor];
    
    return [super webViewDidFinishLoad:theWebView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"myapp"] && [url.host isEqualToString:@"com.lee"] && [url.path isEqualToString:@"/back"])
    {
        [self back];
        return NO;
    }
    return YES;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end






@implementation CordovaCommandDelegate

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end






@implementation CordovaCommandQueue

- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
