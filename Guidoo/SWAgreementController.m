//
//  SWAgreementController.m
//  Guidoo
//
//  Created by Sergiy Bekker on 12.05.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#import "SWAgreementController.h"

@interface SWAgreementController ()

@property (nonatomic, strong) IBOutlet UIWebView* webview;
@end

@implementation SWAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"]];
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
  
    [self setupNavBtn:BACKTYPE];
    [self simpleTitle:@"Agreement & Policy"];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        [[UIApplication sharedApplication] openURL:request.URL];
    }
    
    return YES;
    
}
@end
