

//
//  BWTVersionVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/28.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTVersionVC.h"
#import "BWTAppUpdateModel.h"
#import <WebKit/WebKit.h>
//#import <WebKit/WKWebView.h>


@interface BWTVersionVC ()<WKNavigationDelegate>

@property (nonatomic, strong) UIView *needUpdatebgView;

@property (nonatomic, strong) WKWebView *infoWV;
@property (nonatomic, strong) UIButton *updateBtn;

@end

@implementation BWTVersionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    self.view.backgroundColor = BWTWhiteColor;
    [self versionCheck];
}
- (void)updateBtnClick:(UIButton *)btn{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1488071338?mt=8"] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @""} completionHandler:^(BOOL success) {
        
    }];
    
}
- (void)needUpdateView{
    
    _needUpdatebgView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width');var style = document.createElement('style');style.type = 'text/css';style.appendChild(document.createTextNode('img{max-width: 100%; width:auto; height:auto;}'));style.appendChild(document.createTextNode('table{max-width: 100%; width:auto; height:auto;}'));var head = document.getElementsByTagName('head')[0];head.appendChild(style); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    _infoWV = [[WKWebView alloc] initWithFrame:CGRectMake(20, 30, kScreenWidth-40, kScreenHeight-kTabBarHeight-kNavigationBarHeight-40) configuration:wkWebConfig];
    _infoWV.navigationDelegate = self;
    _infoWV.scrollView.bounces = NO;
    
    [_needUpdatebgView addSubview:_infoWV];
    
    
    _updateBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, kScreenHeight-kTabBarHeight-kNavigationBarHeight, kScreenWidth-40, 45)];
    [_updateBtn setTitle:@"立即升级" forState:UIControlStateNormal];
    _updateBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    [_updateBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _updateBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_updateBtn addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _updateBtn.layer.cornerRadius = 5;
    _updateBtn.layer.masksToBounds = YES;
    [_needUpdatebgView addSubview:_updateBtn];
    
    [self.view addSubview:_needUpdatebgView];
}
- (void)addsubView{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((kScreenWidth-210)/2, 32, 210, 21);
    label.text = @"最新版本提示：已经是最新版本";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    
    [self.view addSubview:label];
}
// 版本升级检测
- (void)versionCheck{
    @weakify(self);
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"Ios" forKey:@"appPlatform"];
    [param setValue:appVersion forKey:@"currentVersion"];
    [AFNetworkTool postJSONWithUrl:Version_info parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        
        if (responseObject) {
            BWTAppUpdateModel *updateModel = [BWTAppUpdateModel yy_modelWithJSON:responseObject];
            if (updateModel.needUpgrade) {
                
                [self needUpdateView];
                [self.infoWV loadHTMLString:updateModel.upgradeDesc baseURL:nil];
            } else {
                [self addsubView];
            }
             
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        
//        BWTLog(@"123");
//        BWTLog(@"%f", [result floatValue]);
//        self.infoWV.height = [result floatValue];
//
//        self.updateBtn.top = VIEW_BY(self.infoWV) + 40;
        
    }];
}



@end
