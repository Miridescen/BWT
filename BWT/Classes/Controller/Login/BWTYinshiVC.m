

//
//  BWTYinshiVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/28.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTYinshiVC.h"
#import <WebKit/WebKit.h>
@interface BWTYinshiVC ()

@end

@implementation BWTYinshiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私政策";
    self.view.backgroundColor = BWTWhiteColor;
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, kScreenHeight-kNavigationBarHeight-20) configuration:wkWebConfig];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Host_url_Product, User_yinsi]]]];
    webView.scrollView.bounces = NO;
    
    [self.view addSubview:webView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
