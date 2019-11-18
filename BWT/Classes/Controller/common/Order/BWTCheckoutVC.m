

//
//  BWTCheckoutVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/27.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTCheckoutVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import "BWTMineTVC.h"
#import "BWTOrderVC.h"
#import "BWTMyOrderVC.h"

#import "BWTStoreVC.h"

#import "BWTBagVC.h"

#import "BWTGoodDetailVC.h"

#import "BWTMyOrderVC.h"

@interface BWTCheckoutVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *createBtn;

@property (nonatomic, strong) UIButton *weixinBtn;
@property (nonatomic, strong) UIButton *zhifubaoBtn;

@property (nonatomic, assign)BOOL isCanUseSideBack;
@end

@implementation BWTCheckoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收银台";
    
    [self setupSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:BWTWeixinPaySuccessNotifiction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:BWTWeixinPayFailNotifiction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:BWTAliPaySuccessNotifiction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail) name:BWTAliPayFailNotifiction object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)payFail{
    [MSTipView showWithMessage:@"支付失败"];
    [self backItemClick];
}

- (void)paySuccess {
    
    [MSTipView showWithMessage:@"支付成功"];
    [self backItemClick];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        [self backItemClick];
    }
}

- (void)loadData{

}
- (void)backItemClick{
    NSArray *viewControllers = self.navigationController.viewControllers;
    BWTLog(@"%@", viewControllers);
    UIViewController *rootVC = (UIViewController *)viewControllers[0];
    
    if ([rootVC isKindOfClass:[BWTBagVC class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tabBarController.selectedIndex = 2;
        
        UINavigationController *baseNav = (UINavigationController *)self.tabBarController.viewControllers[2];
        BWTMyOrderVC *myOrderVC = [[BWTMyOrderVC alloc] init];
        [baseNav pushViewController:myOrderVC animated:NO];
        
    }
    if ([rootVC isKindOfClass:[BWTStoreVC class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tabBarController.selectedIndex = 2;
        
        UINavigationController *baseNav = (UINavigationController *)self.tabBarController.viewControllers[2];
        BWTMyOrderVC *myOrderVC = [[BWTMyOrderVC alloc] init];
        [baseNav pushViewController:myOrderVC animated:NO];
        
    }
    if ([rootVC isKindOfClass:[BWTMineTVC class]]) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        self.tabBarController.selectedIndex = 2;
        
        UINavigationController *baseNav = (UINavigationController *)self.tabBarController.viewControllers[2];
        BWTMyOrderVC *myOrderVC = [[BWTMyOrderVC alloc] init];
        [baseNav pushViewController:myOrderVC animated:NO];
        
        /*
        if (viewControllers.count >= 2) {
            UIViewController *oneVC = (UIViewController *)viewControllers[1];
            if ([oneVC isKindOfClass:[BWTMyOrderVC class]]) {
                
                
                BWTMyOrderVC *orderVC = (BWTMyOrderVC *)oneVC;
                [orderVC loadData];
                [self.navigationController popToViewController:oneVC animated:NO];
            } else {
                [self.navigationController popToViewController:rootVC animated:NO];
            }
        } else {
            [self.navigationController popToViewController:rootVC animated:NO];
        }
         */
        
    }
    /*
    if ([rootVC isKindOfClass:[BWTBagVC class]]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    if ([rootVC isKindOfClass:[BWTStoreVC class]]) {
        if (viewControllers.count >= 2) {
            UIViewController *oneVC = (UIViewController *)viewControllers[1];
            if ([oneVC isKindOfClass:[BWTGoodDetailVC class]]) {
                [self.navigationController popToViewController:oneVC animated:NO];
            } else {
                [self.navigationController popToViewController:rootVC animated:NO];
            }
        } else {
            [self.navigationController popToViewController:rootVC animated:NO];
        }
        
    }
    if ([rootVC isKindOfClass:[BWTMineTVC class]]) {
        
        if (viewControllers.count >= 2) {
            UIViewController *oneVC = (UIViewController *)viewControllers[1];
            if ([oneVC isKindOfClass:[BWTMyOrderVC class]]) {
                [self.navigationController popToViewController:oneVC animated:NO];
            } else {
                [self.navigationController popToViewController:rootVC animated:NO];
            }
        } else {
            [self.navigationController popToViewController:rootVC animated:NO];
        }
        
    }
     */

}

- (void)setupSubView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-10)];
    _tableView.backgroundColor = BWTBackgroundGrayColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    UIView *footBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight-kNavigationBarHeight-10, kScreenWidth, kTabBarHeight+10)];
    footBar.backgroundColor = BWTWhiteColor;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.1];
    [footBar addSubview:lineView];
    [self.view addSubview:footBar];
    
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, kScreenWidth-40, 45)];
    [_createBtn setTitle:[NSString stringWithFormat:@"微信支付¥%@", @(self.amount)] forState:UIControlStateNormal];
    _createBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    [_createBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_createBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    _createBtn.layer.cornerRadius = 5;
    _createBtn.layer.masksToBounds = YES;
    [footBar addSubview:_createBtn];
    
    
    
}

- (void)weixinBtnClick:(UIButton *)btn{
    if (!btn.selected) {
        btn.selected = YES;
        [_createBtn setTitle:[NSString stringWithFormat:@"微信支付¥%@", @(self.amount)] forState:UIControlStateNormal];
        _zhifubaoBtn.selected = NO;
    }
}
- (void)zhifubaoBtnClick:(UIButton *)btn{
    if (!btn.selected) {
        btn.selected = YES;
        [_createBtn setTitle:[NSString stringWithFormat:@"支付宝支付¥%@", @(self.amount)] forState:UIControlStateNormal];
        _weixinBtn.selected = NO;
    }
}

- (void)payClick:(UIButton *)btn{
    if (_weixinBtn.selected) {
        BWTLog(@"微信");
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:self.orderIDs forKey:@"orderId"];
        BWTLog(@"%@", param);
        @weakify(self);
        [AFNetworkTool getJSONWithUrl:Pay_weixin parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            if (responseObject) {
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = [NSString stringWithFormat:@"%@", responseObject[@"partnerid"]];
                request.prepayId= [NSString stringWithFormat:@"%@", responseObject[@"prepayid"]];
                request.package = [NSString stringWithFormat:@"%@", responseObject[@"pkg"]];
                request.nonceStr= [NSString stringWithFormat:@"%@", responseObject[@"noncestr"]];
                request.timeStamp= [responseObject[@"timestamp"] intValue];
                request.sign= [NSString stringWithFormat:@"%@", responseObject[@"sign"]];
                [WXApi sendReq:request completion:^(BOOL success) {
                    
                }];
            }
        } fail:^(NSError *error) {
            
        }];

    }
    if (_zhifubaoBtn.selected) {
        BWTLog(@"支付宝");
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:self.orderIDs forKey:@"orderId"];
        
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:Pay_ali parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            if (responseObject) {
                
                NSString *appScheme = @"aliuniquestore";
                AlipaySDK *payManager = [AlipaySDK defaultService];
                [payManager payOrder:[NSString stringWithFormat:@"%@", responseObject] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    NSString *resultStatus = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"resultStatus"]];
                        NSInteger statusCode = [resultStatus integerValue];

                        switch (statusCode) {
                            case 9000:{
                                [MSTipView showWithMessage:@"支付成功"];
                                [self backItemClick];
                            }
                                break;
                            case 4000:{
                                [MSTipView showWithMessage:@"支付失败"];
                                [self backItemClick];
                            }
                                break;
                            default:{
                                [MSTipView showWithMessage:@"支付失败"];
                                [self backItemClick];
                            }
                                break;
                        }
                }];

            }
        } fail:^(NSError *error) {
            
        }];
    }
    
}


- (void)onResp:(BaseResp*)resp{
    BWTLog(@"22222 == %@", resp);
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                {
                    [MSTipView showWithMessage:@"支付成功"];
                    [self backItemClick];
                }
                
                break;
                
            default:
                {
                    [MSTipView showWithMessage:@"支付失败"];
                    [self backItemClick];
                }
                break;
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView.backgroundColor = BWTBackgroundGrayColor;
        [bgView addSubview:lineView];
        
        UILabel *namelabel = [[UILabel alloc] init];
        namelabel.frame = CGRectMake((kScreenWidth-64)/2, 32, 64, 22);
        namelabel.text = @"实付金额";
        namelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        namelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [bgView addSubview:namelabel];
        
        UIView *moneyBGView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_BY(namelabel)+5, 0, 47)];

        UILabel *loglabel = [[UILabel alloc] init];
        loglabel.frame = CGRectMake(0, 126, 18, 42);
        loglabel.text = @"¥";
        loglabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:30];
        loglabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [moneyBGView addSubview:loglabel];
        
        UILabel *moneylabel = [[UILabel alloc] init];
        moneylabel.frame = CGRectMake(142, VIEW_BX(loglabel)+5, 125, 47);
        moneylabel.text = [NSString stringWithFormat:@"%@", @(self.amount)];
        moneylabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:40];
        moneylabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [moneyBGView addSubview:moneylabel];
        
        CGFloat moneyBGViewWidth = [NSString sizeWithText:loglabel.text font:loglabel.font].width + [NSString sizeWithText:moneylabel.text font:moneylabel.font].width+5;
        moneyBGView.frame = CGRectMake((kScreenWidth-moneyBGViewWidth)/2, VIEW_BY(namelabel)+8, moneyBGViewWidth, 40);
        loglabel.frame = CGRectMake(0, 7, [NSString sizeWithText:loglabel.text font:loglabel.font].width, 30);
        moneylabel.frame = CGRectMake(VIEW_BX(loglabel)+5, 0, [NSString sizeWithText:moneylabel.text font:moneylabel.font].width, 40);
        
        [bgView addSubview: moneyBGView];
        
        [cell.contentView addSubview:bgView];
        
    }
    if (indexPath.row == 1) {
        
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgview.backgroundColor = BWTWhiteColor;
        
        UILabel *selectlabel = [[UILabel alloc] init];
        selectlabel.frame = CGRectMake(20, 17, 96, 22);
        selectlabel.text = @"选择支付方式";
        selectlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        selectlabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [bgview addSubview:selectlabel];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgview.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgview];

        
    }
    if (indexPath.row == 2) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgView.layer addSublayer:lineLayer];
        
        UIImageView *logimageView = [[UIImageView alloc] init];
        logimageView.frame = CGRectMake(20, 15, 24, 24);
        logimageView.image = [UIImage imageNamed:@"img_weixinzhifu"];
        [bgView addSubview:logimageView];
        
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.frame = CGRectMake(VIEW_BX(logimageView)+13, 16, 80, 22);
        titlelabel.text = @"微信支付";
        titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        titlelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [bgView addSubview:titlelabel];
        
        _weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-20, 17, 20, 20)];
        [_weixinBtn setImage:[UIImage imageNamed:@"img_select_off"] forState:UIControlStateNormal];
        [_weixinBtn setImage:[UIImage imageNamed:@"img_select_on"] forState:UIControlStateSelected];
        _weixinBtn.selected = YES;
        [_weixinBtn addTarget:self action:@selector(weixinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_weixinBtn];
        
        [cell.contentView addSubview:bgView];
    }
    if (indexPath.row == 3) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgView.layer addSublayer:lineLayer];
        
        UIImageView *logimageView = [[UIImageView alloc] init];
        logimageView.frame = CGRectMake(20, 15, 24, 24);
        logimageView.image = [UIImage imageNamed:@"img_zhifubao"];
        [bgView addSubview:logimageView];
        
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.frame = CGRectMake(VIEW_BX(logimageView)+13, 16, 80, 22);
        titlelabel.text = @"支付宝支付";
        titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        titlelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [bgView addSubview:titlelabel];
        
        _zhifubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-20, 17, 20, 20)];
        [_zhifubaoBtn setImage:[UIImage imageNamed:@"img_select_off"] forState:UIControlStateNormal];
        [_zhifubaoBtn setImage:[UIImage imageNamed:@"img_select_on"] forState:UIControlStateSelected];
        [_zhifubaoBtn addTarget:self action:@selector(zhifubaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:_zhifubaoBtn];
        
        [cell.contentView addSubview:bgView];   
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }
    if (indexPath.row == 1) {
        return 65;
    }
    if (indexPath.row == 2) {
        return 55;
    }
    if (indexPath.row == 3) {
        return 55;
    }
    return 0;
}

@end
