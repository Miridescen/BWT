
//
//  BWTStoreVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/14.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTStoreVC.h"

#import "BWTStoreHeadView.h"
#import "BWTGoodsCV.h"

#import "BWTGoodDetailVC.h"
#import "BWTBrandGoodsVC.h"
#import "BWTSearchVC.h"

#import "GoodsCategoryModel.h"
#import "GoodsRecommendBrandModel.h"
#import "GoodsModel.h"

#import "BWTMyCollectVC.h"

#import "BWTLoginVC.h"
#import "BWTAppUpdateModel.h"

#import "BWTMyCouponVC.h"

//#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

@interface BWTStoreVC ()<UITextFieldDelegate, UICollectionViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UIView *couponBgView;
@property (nonatomic, strong) UIView *versionBgView;

@property (nonatomic, strong) WKWebView *versionWebView;

@property (nonatomic, assign) NSInteger categoryID;

@end

@implementation BWTStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupSubViews];
    
    [self showCoupon];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - private method
- (void)showCoupon{
    
    NSDictionary *param1 = [[NSMutableDictionary alloc] init];
    if (BWTIsLogin) {
        [param1 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    }

    @weakify(self);
    [AFNetworkTool postJSONWithUrl:Coupon_get_show_newpeople parameters:param1 success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        BOOL showCoupon = [responseObject boolValue];
        if (showCoupon) {
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            [window addSubview:self.couponBgView];
        }
        [self versionCheck];
    } fail:^(NSError *error) {
        [self versionCheck];
    }];
     
}
- (void)couponButtonClick:(UIButton *)btn{
    
    [self.couponBgView removeFromSuperview];
    if (BWTIsLogin) {
        BWTMyCouponVC *couponVC = [[BWTMyCouponVC alloc] init];
        [self.navigationController pushViewController:couponVC animated:YES];
    } else {
        BWTLoginVC *loginVC = [[BWTLoginVC alloc] init];
        @weakify(self);
        loginVC.loginSuccessBlock = ^{
            @strongify(self);
            if (!self) return;
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;

            [window addSubview:self.couponBgView];
        };
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (UIView *)couponBgView{
    if (!_couponBgView) {
        _couponBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _couponBgView.backgroundColor = RGBAColor(0, 0, 0, 0.6);
        
        UIButton *couponbtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-300)/2, (kScreenHeight-327)/2, 300, 327)];
        [couponbtn setBackgroundImage:[UIImage imageNamed:@"home_coupon.png"] forState:UIControlStateNormal];
        [couponbtn addTarget:self action:@selector(couponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_couponBgView addSubview:couponbtn];
        
        
        UIButton *popButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-48)/2, VIEW_BY(couponbtn)+25, 48, 48)];
        [popButton setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
        [popButton addTarget:self action:@selector(couponPopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_couponBgView addSubview:popButton];
    }
    return _couponBgView;
}

- (void)setupSubViews{
    
    BWTStoreHeadView *headView = [[BWTStoreHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    
    [self.view addSubview:headView];

    BWTGoodsCV *goodcv = [[BWTGoodsCV alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight-40-kNavigationBarHeight-kTabBarHeight)];
    
    @weakify(self);
    goodcv.cellSelectBlock = ^(GoodsModel * _Nonnull goodModel) {
        @strongify(self);
        if (!self) return;
        BWTGoodDetailVC *goodDetail = [[BWTGoodDetailVC alloc] init];
        goodDetail.goodID = goodModel._id;
        [self.navigationController pushViewController:goodDetail animated:YES];
    };
    
    goodcv.brandSelectBlock = ^(GoodsRecommendBrandModel * _Nonnull brandModel, NSUInteger categoryID) {
        @strongify(self);
        if (!self) return;
        BWTBrandGoodsVC *brandGoodVC = [[BWTBrandGoodsVC alloc] init];
        brandGoodVC.brandID = brandModel._id;
        brandGoodVC.categoryID = self.categoryID;
        brandGoodVC.title = brandModel.value;
        [self.navigationController pushViewController:brandGoodVC animated:YES];
    };
    
    goodcv.brandOtherSelectBlock = ^{
        @strongify(self);
        if (!self) return;
        BWTSearchVC *searchVC = [[BWTSearchVC alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    };
    [self.view addSubview:goodcv];
    
    headView.btnClickBlock = ^(GoodsCategoryModel * _Nonnull categoryModel) {
        @strongify(self);
        if (!self) return;
        self.categoryID = categoryModel._id;
        goodcv.storeMenuCRVBgImageUrl = categoryModel.iconUrl;
        [goodcv loadDataWith:categoryModel];
    };
    
}
- (void)setupNav{

    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 34)];
    [rightBarButton setImage:[UIImage imageNamed:@"icon_collection"] forState:UIControlStateNormal];
    [rightBarButton setTitle:@"收藏夹" forState:UIControlStateNormal];
    [rightBarButton setTitleColor: [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = BWTBaseFont(9);
    [rightBarButton addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setImageEdgeInsets:UIEdgeInsetsMake(-rightBarButton.imageView.frame.size.height, rightBarButton.imageView.frame.size.width-8,-5, 0)];
     [rightBarButton setTitleEdgeInsets:UIEdgeInsetsMake(rightBarButton.imageView.frame.size.height,-rightBarButton.imageView.frame.size.width+5,-5,-6)];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 34)];
    [rightView addSubview:rightBarButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, kScreenWidth-80, 32)];
//    _searchView.backgroundColor = BWTBackgroundGrayColor;
//    _searchView.backgroundColor = [UIColor redColor];
    _searchView.clipsToBounds = NO;

    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(-8, 0, kScreenWidth-74, 32)];
    searchTF.backgroundColor = BWTBackgroundGrayColor;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
    leftImg.image = [UIImage imageNamed:@"icon_search"];
    [leftView addSubview:leftImg];
    
    
    searchTF.placeholder = @"Search";
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.delegate = self;
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [searchTF setLeftView:leftView];
    [_searchView addSubview:searchTF];
    
    self.navigationItem.titleView = _searchView;
    self.navigationItem.leftBarButtonItem = nil;
    
 
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
//        BWTLog(@"%@", responseObject);
        if (responseObject) {
            BWTAppUpdateModel *updateModel = [BWTAppUpdateModel yy_modelWithJSON:responseObject];
            if (updateModel.needUpgrade) {
                if (updateModel.forceUpgrade) {
                    
                    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                    
                    self.versionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    self.versionBgView.backgroundColor = RGBAColor(0, 0, 0, 0.6);
                    [window addSubview:self.versionBgView];
                    
                    UIView *view = [[UIView alloc] init];
                    view.frame = CGRectMake((kScreenWidth-300)/2, (kScreenHeight-327)/2, 300, 327);
                    view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1/1.0];
                    view.layer.cornerRadius = 12;
                    view.layer.masksToBounds = YES;
                    [self.versionBgView addSubview:view];
                    
                    UILabel *titlelabel = [[UILabel alloc] init];
                    titlelabel.frame = CGRectMake((300-72)/2, 21, 72, 25);
                    titlelabel.text = @"升级提示";
                    titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
                    titlelabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1/1.0];
                    [view addSubview:titlelabel];
                    
                    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width');var style = document.createElement('style');style.type = 'text/css';style.appendChild(document.createTextNode('img{max-width: 100%; width:auto; height:auto;}'));style.appendChild(document.createTextNode('table{max-width: 100%; width:auto; height:auto;}'));var head = document.getElementsByTagName('head')[0];head.appendChild(style); document.getElementsByTagName('head')[0].appendChild(meta);";
                    
                    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
                    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
                    [wkUController addUserScript:wkUScript];
                    
                    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
                    wkWebConfig.userContentController = wkUController;
                    self.versionWebView = [[WKWebView alloc] initWithFrame:CGRectMake(20, 66, 260, 327-145) configuration:wkWebConfig];
                    self.versionWebView.scrollView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1/1.0];
                    self.versionWebView.scrollView.bounces = NO;
                    self.versionWebView.navigationDelegate = self;
                    [self.versionWebView loadHTMLString:updateModel.upgradeDesc baseURL:nil];
                    [self.versionWebView evaluateJavaScript:@"document.body.style.backgroundColor=\"#EDEDED\"" completionHandler:nil];

                    [view addSubview:self.versionWebView];
                    
                    UIButton *updateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 282, 300, 45)];
                    [updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
                    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [updateButton setBackgroundColor:[UIColor colorWithHexString:@"#FF6600"]];
                    [updateButton addTarget:self action:@selector(updateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    updateButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
                    [view addSubview:updateButton];
                    
                    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-48)/2, VIEW_BY(view)+30, 48, 48)];
                    [closeButton setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
                    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [self.versionBgView addSubview:closeButton];

                } else {
                    
                    NSDate *saveDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:BWTpushVersionTip];
                    
                    NSDate *nowDate = [NSDate date];
                    long long sevenDay = 604800;
                    NSDate *expiresTime = [saveDate dateByAddingTimeInterval:sevenDay];
                    NSComparisonResult result = [expiresTime compare:nowDate];
                    if (result != NSOrderedDescending) {
                        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                        
                        self.versionBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                        self.versionBgView.backgroundColor = RGBAColor(0, 0, 0, 0.6);
                        [window addSubview:self.versionBgView];
                        
                        UIView *view = [[UIView alloc] init];
                        view.frame = CGRectMake((kScreenWidth-300)/2, (kScreenHeight-327)/2, 300, 327);
                        view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1/1.0];
                        view.layer.cornerRadius = 12;
                        view.layer.masksToBounds = YES;
                        [self.versionBgView addSubview:view];
                        
                        UILabel *titlelabel = [[UILabel alloc] init];
                        titlelabel.frame = CGRectMake((300-72)/2, 21, 72, 25);
                        titlelabel.text = @"升级提示";
                        titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
                        titlelabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1/1.0];
                        [view addSubview:titlelabel];
                        
                        
                        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width');var style = document.createElement('style');style.type = 'text/css';style.appendChild(document.createTextNode('img{max-width: 100%; width:auto; height:auto;}'));style.appendChild(document.createTextNode('table{max-width: 100%; width:auto; height:auto;}'));var head = document.getElementsByTagName('head')[0];head.appendChild(style); document.getElementsByTagName('head')[0].appendChild(meta);";
                        
                        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
                        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
                        [wkUController addUserScript:wkUScript];
                        
                        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
                        wkWebConfig.userContentController = wkUController;
                        self.versionWebView = [[WKWebView alloc] initWithFrame:CGRectMake(20, 66, 260, 327-145) configuration:wkWebConfig];
                        self.versionWebView.scrollView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1/1.0];
                        self.versionWebView.scrollView.bounces = NO;
                        [self.versionWebView loadHTMLString:updateModel.upgradeDesc baseURL:nil];
                        self.versionWebView.navigationDelegate = self;
                        [view addSubview:self.versionWebView];
                        
                        UIButton *updateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 282, 300, 45)];
                        [updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
                        [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [updateButton setBackgroundColor:[UIColor colorWithHexString:@"#FF6600"]];
                        [updateButton addTarget:self action:@selector(updateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                        updateButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
                        [view addSubview:updateButton];
                        
                        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-48)/2, VIEW_BY(view)+30, 48, 48)];
                        [closeButton setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
                        [closeButton addTarget:self action:@selector(versionPopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                        [self.versionBgView addSubview:closeButton];
                    }
                    
                    
                }
            }
             
        }
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)versionPopButtonClick:(UIButton *)btn{
    NSDate *nowDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setValue:nowDate forKey:BWTpushVersionTip];
    [self.versionBgView removeFromSuperview];
}
- (void)couponPopButtonClick:(UIButton *)btn{
    [self.couponBgView removeFromSuperview];
}
- (void)updateButtonClick:(UIButton *)btn{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1488071338?mt=8"] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @""} completionHandler:^(BOOL success) {
        
    }];

    
}
- (void)closeButtonClick:(UIButton *)btn{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(abcdefg)];
    abort();
    #pragma clang diagnostic pop
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    BWTSearchVC *searchVC = [[BWTSearchVC alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)selectBtnClick:(UIButton *)btn{
    if (BWTIsLogin) {
        BWTMyCollectVC *myCollection = [[BWTMyCollectVC alloc] init];
        [self.navigationController pushViewController:myCollection animated:YES];
    } else {
        [BWTUserTool presentLoginVC];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#EDEDED\"" completionHandler:nil];
}


@end
