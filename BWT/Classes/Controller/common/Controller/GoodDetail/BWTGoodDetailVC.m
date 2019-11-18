
//
//  BWTGoodDetailVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/16.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTGoodDetailVC.h"

#import "GoodsModel.h"
#import "GoodDetailModel.h"
#import <WebKit/WebKit.h>

#import "BWTOrderVC.h"
#import "SKUView.h"
#import "BWTBuyNowOrderVC.h"
#import "OrderCellModel.h"

#import "MQChatViewManager.h"

#import "BWTUserModel.h"

#import "BWTStoreVC.h"

@interface BWTGoodDetailVC ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UIView *footTabBar;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) GoodDetailModel *goodDetailModel;

@property (nonatomic, assign) CGFloat detailWebViewHeight;
@property (nonatomic, strong) WKWebView *detailWebView;

@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong) UILabel *bagGoodsNum;

@property (nonatomic, strong) SKUView *addBagSKUView; // 添加购物车的view
@property (nonatomic, strong) SKUView *buyNowSKUView; // 立即购买的view

@property (nonatomic, assign) CGFloat goodTitleHeight; // 商品名称高度

@end

@implementation BWTGoodDetailVC

static NSString *const cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.detailWebViewHeight = 2000;
    self.goodTitleHeight = 0;
    [self setupTabView];
    [self setupScrollView];
    [self setupFootBar];
    [self loadData];
}

- (void)loadData{
    
    @weakify(self);

    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] initWithCapacity:1];
    [param1 setValue:[NSNumber numberWithInteger:self.goodID] forKey:@"goodsId"];

    [AFNetworkTool postJSONWithUrl:Good_detail parameters:param1 success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        GoodDetailModel *detailModel = [GoodDetailModel yy_modelWithJSON:responseObject];
        self.goodDetailModel = detailModel;
        
        //以下代码适配大小
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width');var style = document.createElement('style');style.type = 'text/css';style.appendChild(document.createTextNode('img{max-width: 100%; width:auto; height:auto;}'));style.appendChild(document.createTextNode('table{max-width: 100%; width:auto; height:auto;}'));var head = document.getElementsByTagName('head')[0];head.appendChild(style); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        self.detailWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, 100) configuration:wkWebConfig];
        [self.detailWebView loadHTMLString:[NSString stringWithFormat:@"%@", detailModel.detail] baseURL:NULL];
        self.detailWebView.navigationDelegate = self;
        BWTLog(@"2222");
        self.goodTitleHeight = [NSString sizeWithText:detailModel.title font:[UIFont fontWithName:@"PingFangSC-Regular" size:19] maxW:kScreenWidth-40].height;
        
        [self.detailTableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
    if (BWTIsLogin) {
        NSMutableDictionary *param2 = [[NSMutableDictionary alloc] init];
        [param2 setValue:BWTUsertoken forKey:@"token"];
        [param2 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param2 setValue:[NSNumber numberWithInteger:self.goodID] forKey:@"goodsId"];
        [AFNetworkTool postJSONWithUrl:Goods_is_collect parameters:param2 success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            NSInteger result = [responseObject integerValue];

            self.collectBtn.selected = result?YES:NO;
        } fail:^(NSError *error) {
            
        }];
        
        NSMutableDictionary *param3 = [[NSMutableDictionary alloc] init];
        [param3 setValue:BWTUsertoken forKey:@"token"];
        [param3 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [AFNetworkTool postJSONWithUrl:ShoppingCart_good_num parameters:param3 success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            NSInteger result = [responseObject integerValue];
            if (result > 0) {
                self.bagGoodsNum.text = [NSString stringWithFormat:@"%ld", (long)result];
                CGSize size = [NSString sizeWithText:self.bagGoodsNum.text font:BWTBaseFont(12)];
                self.bagGoodsNum.width = size.width > 18 ? size.width : 18;
                self.bagGoodsNum.hidden = NO;
            }
        } fail:^(NSError *error) {
            
        }];
    }
    
}

#pragma mark - btnClick

- (void)serviceBtnClick:(UIButton *)btn{

    BWTUserModel *userModel = [BWTUserTool userModel];
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    [chatViewManager setScheduledGroupId:BWTMeiyiGroupID];
    if (userModel.userId) {
        [chatViewManager setClientInfo:@{@"name":[NSString stringWithFormat:@"%@", userModel.nickName],@"avatar":[NSString stringWithFormat:@"%@", userModel.headPortrait],@"userId":[NSString stringWithFormat:@"%ld", (long)userModel.userId]} override:YES];
    
    }
    [chatViewManager pushMQChatViewControllerInViewController:self];
}
- (void)addBagBtnDidClick:(UIButton *)btn{
    if (!BWTIsLogin) {
        [BWTUserTool presentLoginVC];
    } else {
        if (!self.goodDetailModel) {
            return;
        }
        _addBagSKUView = [[SKUView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _addBagSKUView.goodModel = self.goodDetailModel;
        
        @weakify(self);
        _addBagSKUView.sureBtnClickBlock = ^(goodsSkuVOS * _Nonnull selectedSKU, NSDictionary * _Nonnull standard, NSInteger selectNum){
            
            @strongify(self);
            if (!self) return;
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setValue:BWTUsertoken forKey:@"token"];
            [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
            [param setValue:@"ALL" forKey:@"paymentCycle"];
            [param setValue:@"shoes" forKey:@"orderType"];
            [param setValue:[NSNumber numberWithInteger:selectedSKU._id] forKey:@"itemId"];
            [param setValue:[NSNumber numberWithInteger:selectNum] forKey:@"itemCount"];
            [param setValue:@"-1M" forKey:@"duration"];
            [param setValue:[NSNumber numberWithInteger:0] forKey:@"depositRate"];
            [param setValue:[NSNumber numberWithInteger:self.goodDetailModel.goodsCategoryId] forKey:@"categoryId"];
            [AFNetworkTool postJSONWithUrl:ShoppingCart_good_add parameters:param success:^(id responseObject) {
                @strongify(self);
                if (!self) return;
                [MSTipView showWithMessage:@"添加商品成功"];
                NSMutableDictionary *param3 = [[NSMutableDictionary alloc] init];
                [param3 setValue:BWTUsertoken forKey:@"token"];
                [param3 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
                [AFNetworkTool postJSONWithUrl:ShoppingCart_good_num parameters:param3 success:^(id responseObject) {
                    @strongify(self);
                    if (!self) return;
                    NSInteger result = [responseObject integerValue];
                    if (result > 0) {
                        self.bagGoodsNum.text = [NSString stringWithFormat:@"%ld", (long)result];
                        CGSize size = [NSString sizeWithText:self.bagGoodsNum.text font:BWTBaseFont(12)];
                        self.bagGoodsNum.width = size.width > 18 ? size.width : 18;
                        self.bagGoodsNum.hidden = NO;
                    }
                } fail:^(NSError *error) {
                    
                }];

            } fail:^(NSError *error) {
                
            }];
        };

        [self.view addSubview:self.addBagSKUView]; 
    }
}
- (void)buyNowBtnDidClick:(UIButton *)btn{
    if (!BWTIsLogin) {
        [BWTUserTool presentLoginVC];
    } else {
        if (!self.goodDetailModel) {
            return;
        }
        _buyNowSKUView = [[SKUView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _buyNowSKUView.goodModel = self.goodDetailModel;
        
        @weakify(self);
        _buyNowSKUView.sureBtnClickBlock = ^(goodsSkuVOS * _Nonnull selectedSKU, NSDictionary * _Nonnull standard, NSInteger selectNum) {
            @strongify(self);
            if (!self) return;
            NSArray *allValue = [standard allValues];
            OrderCellModel *model = [[OrderCellModel alloc] init];
            model.title = self.goodDetailModel.title;
            model.imgUrl = self.goodDetailModel.goodsMainPicture.annexUrl;
            model.goodNum = selectNum;
            model.price = selectedSKU.depositPrice;
            model.snapshotVersion = self.goodDetailModel.snapshotVersion;
            model.skuID = selectedSKU._id;
            NSString *standardStr = @" "; //必须有个空格
            for (NSString *value in allValue) {
                standardStr = [standardStr stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"%@  ", value]];
            }
            model.standard = [standardStr copy];
            
            BWTBuyNowOrderVC *buyNowOrderVC = [[BWTBuyNowOrderVC alloc] init];
            buyNowOrderVC.goodModel = self.goodDetailModel;
            buyNowOrderVC.cellModel = model;
            buyNowOrderVC.selectSku = selectedSKU;
            buyNowOrderVC.selectNum = selectNum;
            [self.navigationController pushViewController:buyNowOrderVC animated:YES];
            [self.buyNowSKUView removeFromSuperview];
        };

        [self.view addSubview:self.buyNowSKUView];
    }
}
- (void)collectBtnDidClick:(UIButton *)btn{
    
    if (!BWTIsLogin) {
        [BWTUserTool presentLoginVC];
    } else {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:[NSNumber numberWithInteger:self.goodID] forKey:@"goodsId"];
        if (btn.selected) {
            @weakify(self);
            [AFNetworkTool postJSONWithUrl:Good_remove_favor parameters:param success:^(id responseObject) {
                @strongify(self);
                if (!self) return;
                btn.selected = NO;
            } fail:^(NSError *error) {
                
            }];
        } else {
            @weakify(self);
            [AFNetworkTool postJSONWithUrl:Goods_add_favor parameters:param success:^(id responseObject) {
                @strongify(self);
                if (!self) return;
                btn.selected = YES;
            } fail:^(NSError *error) {
                
            }];
        }
    }
}

- (void)bagBtnDidClick:(UIButton *)btn{
    
    if (!BWTIsLogin) {
        [BWTUserTool presentLoginVC];
    } else {
        self.navigationController.tabBarController.selectedIndex = 1;
        [self.navigationController popViewControllerAnimated:NO];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell= [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    GoodDetailModel *model = self.goodDetailModel;
    
    if (indexPath.row == 0) {
        
        NSArray *picVosArr = model.goodsPictureVOS;
        NSMutableArray *imgArr = [@[] mutableCopy];
        for (goodsPictureVOS *picVos in picVosArr) {
            [imgArr addObject:picVos.goodsAnnexInfoVO.annexUrl];
        }
        if (imgArr.count == 1) {
            UIImageView *bannerImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
            bannerImg.backgroundColor = BWTBackgroundGrayColor;
            [bannerImg sd_setImageWithURL:[NSURL URLWithString:imgArr[0]]];
            [cell.contentView addSubview:bannerImg];
        } else {
            MSBannerView *bannerView = [[MSBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) imgURLArray:imgArr placeholderImage:[UIImage new]];
            [cell.contentView addSubview:bannerView];
        }
        
    }
    if (indexPath.row == 1) {
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 166-47+self.goodTitleHeight+25)];
        infoView.backgroundColor = BWTClearColor;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 166-47+self.goodTitleHeight-10+25)];
        bgView.backgroundColor = BWTWhiteColor;
        [infoView addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kScreenWidth-40, 47)];
        titleLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
        titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:19];;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 0;
        titleLabel.text = model.title;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.maximumLineHeight = 23;
        paragraphStyle.minimumLineHeight = 23;
        paragraphStyle.lineSpacing = 6;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        CGFloat baselineOffset = (23 - titleLabel.font.lineHeight) / 4;
        [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
        NSAttributedString *arrtStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", model.title]?[NSString stringWithFormat:@"%@", model.title]:@"" attributes:attributes];
        if (![arrtStr.string isEqualToString:@"(null)"]) {
            titleLabel.attributedText = arrtStr;
        }
        [titleLabel sizeToFit];
        
        CGSize titleLabelSize = [NSString sizeWithText:titleLabel.text font:titleLabel.font maxW:kScreenWidth-40];
        titleLabel.height = titleLabelSize.height;
        titleLabel.width = titleLabelSize.width;
//        titleLabel.backgroundColor = [UIColor redColor];
        [bgView addSubview:titleLabel];
        
        
        UIView *discountPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_BY(titleLabel)+30, kScreenWidth, 30)];
        [bgView addSubview:discountPriceView];
        
        UILabel *discountPriceLogo = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 54, 20)];
        discountPriceLogo.textColor = RGBColor(251, 93, 24);
        discountPriceLogo.font = [UIFont fontWithName:@"PingFang SC" size:14];
        discountPriceLogo.textAlignment = NSTextAlignmentCenter;
        discountPriceLogo.numberOfLines = 1;
        discountPriceLogo.text = @"折扣价";
        discountPriceLogo.layer.borderWidth = 1;
        discountPriceLogo.layer.borderColor = [RGBColor(251, 93, 24) CGColor];
        discountPriceLogo.layer.cornerRadius = 2;
        discountPriceLogo.layer.masksToBounds = YES;
        [discountPriceView addSubview:discountPriceLogo];
        
        UILabel *loglabel = [[UILabel alloc] init];
        loglabel.frame = CGRectMake(VIEW_BX(discountPriceLogo)+12, 7, 12, 20);
        if (model.displayDepositPrice) {
            loglabel.text = @"¥";
        }
        loglabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
        loglabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [discountPriceView addSubview:loglabel];
        
        UILabel *discountPrice = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(loglabel)+6, 0, VIEW_BX(loglabel)-6-20, 30)];
        discountPrice.textColor = BWTFontBlackColor;
        discountPrice.font =  [UIFont fontWithName:@"DINAlternate-Bold" size:26];
        discountPrice.textAlignment = NSTextAlignmentLeft;
        discountPrice.numberOfLines = 1;
        if (model.displayDepositPrice) {
            discountPrice.text = [NSString stringWithFormat:@"%@", @(model.displayDepositPrice)];
        }
        [discountPriceView addSubview:discountPrice];
        
        UIView *marketPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_BY(discountPriceView)+6, kScreenWidth, 30)];
        [bgView addSubview:marketPriceView];
        
        UILabel *marketPriceLogo = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 54, 20)];
        marketPriceLogo.textColor = [UIColor colorWithHexString:@"#4A4A4A "];
        marketPriceLogo.font = [UIFont fontWithName:@"PingFang SC" size:14];
        marketPriceLogo.textAlignment = NSTextAlignmentCenter;
        marketPriceLogo.numberOfLines = 1;
        marketPriceLogo.text = @"市场价";
        marketPriceLogo.layer.borderWidth = 1;
        marketPriceLogo.layer.borderColor = [[UIColor colorWithHexString:@"#4A4A4A "] CGColor];
        marketPriceLogo.layer.cornerRadius = 2;
        marketPriceLogo.layer.masksToBounds = YES;
        [marketPriceView addSubview:marketPriceLogo];
        
        UILabel *marketPrice = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(marketPriceLogo)+14, 6, kScreenWidth-VIEW_BX(marketPriceLogo)-14-20, 20)];
        marketPrice.textColor = BWTFontGrayColor;
        marketPrice.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];;
        marketPrice.textAlignment = NSTextAlignmentLeft;
        marketPrice.numberOfLines = 1;
        if (model.displayPrice) {
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", @(model.displayPrice)] attributes:attribtDic];
            marketPrice.attributedText = attribtStr;
        }
        [marketPriceView addSubview:marketPrice];
        
        cell.backgroundColor = BWTBackgroundGrayColor;
        [cell.contentView addSubview:infoView];
    }
    if (indexPath.row == 2) {
        UIView *stateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        stateBgView.backgroundColor = BWTWhiteColor;
        
        CGFloat stateWidth = kScreenWidth/5;
        NSArray *stateImgArr = @[@"icon_you", @"icon_zheng", @"icon_jia", @"icon_wuliu", @"icon_wuyou"];
        NSArray *stateTitleArr = @[@"全球优品", @"正品保障", @"假一罚三", @"极刻物流", @"欢购无忧"];
        for (NSInteger i = 0; i < 5; i++) {
            UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(i*stateWidth, 0, stateWidth, 90)];
            [stateBgView addSubview:stateView];
            
            UIImageView *stateImg = [[UIImageView alloc] initWithFrame:CGRectMake((stateWidth-36)/2, 17, 36, 36)];
            stateImg.image = [UIImage imageNamed:stateImgArr[i]];
            [stateView addSubview:stateImg];
            
            UILabel *stateTitle = [[UILabel alloc] initWithFrame:CGRectMake((stateWidth-50)/2, VIEW_BX(stateImg)+2, 50, 17)];
            stateTitle.textColor = [UIColor colorWithHexString:@"#010101 "];
            stateTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            stateTitle.textAlignment = NSTextAlignmentCenter;
            stateTitle.numberOfLines = 1;
            stateTitle.text = stateTitleArr[i];
            [stateView addSubview:stateTitle];
        
        }
        cell.backgroundColor = BWTBackgroundGrayColor;
        [cell.contentView addSubview:stateBgView];
        
    }
    if (indexPath.row == 3){
        
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.frame = CGRectMake((kScreenWidth-80)/2, 23, 80, 28);
        titlelabel.text = @"商品介绍";
        titlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        titlelabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [cell.contentView addSubview:titlelabel];
        
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 18, 80, 6)];
        colorView.backgroundColor =RGBAColor(254, 162, 108, 0.5);
        [titlelabel addSubview:colorView];
        
        
        UIScrollView *contentScrollView = self.detailWebView.scrollView;
        contentScrollView.bounces = NO;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.scrollEnabled = NO;
        CGFloat height = self.detailWebViewHeight>kScreenHeight-kScreenWidth-166-100-kTabBarHeight-kNavigationBarHeight?self.detailWebViewHeight:kScreenHeight-kScreenWidth-166-100-kTabBarHeight-kNavigationBarHeight;
        self.detailWebView.frame = CGRectMake(0, 70, kScreenWidth, height);
        [cell.contentView addSubview:self.detailWebView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return kScreenWidth;
    }
    if (indexPath.row == 1) {
        return 166-47+self.goodTitleHeight+25;
    }
    if (indexPath.row == 2) {
        return 100;
    }
    if (indexPath.row == 3) {
        return self.detailWebViewHeight+70>kScreenHeight-kScreenWidth-166-100-kTabBarHeight-kNavigationBarHeight?self.detailWebViewHeight+70:kScreenHeight-kScreenWidth-166-100-kTabBarHeight-kNavigationBarHeight;
    }
    
    return 0;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    @weakify(self);
    [webView evaluateJavaScript:@"Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        @strongify(self);
        if (!self) return;
        self.detailWebViewHeight = [result floatValue];
        BWTLog(@"%f", self.detailWebViewHeight);
        [self.detailTableView reloadData];
        
    }];
}

- (void)setupScrollView{
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight)];
    _mainScrollView.backgroundColor = BWTBackgroundGrayColor;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat detailWebVIewHtight = self.detailWebViewHeight+70>kScreenHeight-kScreenWidth-166-100-kTabBarHeight-kNavigationBarHeight?self.detailWebViewHeight+70:kScreenHeight-kScreenWidth-166-100-kTabBarHeight-kNavigationBarHeight;
    CGFloat index0Height = kScreenWidth;
    CGFloat index1Height = 166-47+self.goodTitleHeight+25;
    CGFloat index2Height = 100;
    CGFloat index3Height = detailWebVIewHtight;
    _mainScrollView.contentSize = CGSizeMake(0, index0Height+index1Height+index2Height+index3Height);
//    [self.view addSubview:_mainScrollView];
    
}

- (void)setupTabView{
    
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight)];
    _detailTableView.backgroundColor = BWTBackgroundGrayColor;
    _detailTableView.delegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTableView.bounces = NO;
    _detailTableView.showsVerticalScrollIndicator = NO;
    _detailTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_detailTableView];
}

- (void)setupFootBar{
    _footTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight-kNavigationBarHeight, kScreenWidth, kTabBarHeight)];
    _footTabBar.backgroundColor = BWTWhiteColor;
    _footTabBar.layer.masksToBounds = NO;
    
    _footTabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    _footTabBar.layer.shadowOpacity = 0.8f;
    _footTabBar.layer.shadowRadius = 4.f;
    _footTabBar.layer.shadowOffset = CGSizeMake(4,4);
    
    CGFloat buttonMarggingWidth = (kScreenWidth-220)/3;
    UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceBtn.frame = CGRectMake((buttonMarggingWidth-45)/2, 3, 45, 45);
    [serviceBtn setImage:[UIImage imageNamed:@"icon_kefu"]  forState:UIControlStateNormal];
    [serviceBtn setTitle:@"客服" forState:UIControlStateNormal];
    [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    serviceBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    CGFloat spacing = 1.0;
    CGSize imageSize = serviceBtn.imageView.image.size;
    serviceBtn.titleEdgeInsets = UIEdgeInsetsMake(
      0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    CGSize titleSize = [serviceBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: serviceBtn.titleLabel.font}];
    serviceBtn.imageEdgeInsets = UIEdgeInsetsMake(
      - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    CGFloat edgeOffset = (float)fabs(titleSize.height - imageSize.height) / 2.0;
    serviceBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:serviceBtn];
    

    
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake((buttonMarggingWidth-45)/2+buttonMarggingWidth, 3, 45, 45);
    [_collectBtn setImage:[UIImage imageNamed:@"icon_shoucang"]  forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"icon_shoucang_02"]  forState:UIControlStateSelected];
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _collectBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:10];

    CGFloat spacing1 = 1.0;
    CGSize imageSize1 = _collectBtn.imageView.image.size;
    _collectBtn.titleEdgeInsets = UIEdgeInsetsMake(
      0.0, - imageSize1.width, - (imageSize1.height + spacing1), 0.0);
    CGSize titleSize1 = [_collectBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _collectBtn.titleLabel.font}];
    _collectBtn.imageEdgeInsets = UIEdgeInsetsMake(
      - (titleSize1.height + spacing1), 0.0, 0.0, - titleSize1.width);
    CGFloat edgeOffset1 = (float)fabs(titleSize1.height - imageSize1.height) / 2.0;
    _collectBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset1, 0.0, edgeOffset1, 0.0);
    [_collectBtn addTarget:self action:@selector(collectBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:_collectBtn];
    
    
    
    UIButton *bagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bagBtn.frame = CGRectMake((buttonMarggingWidth-45)/2+buttonMarggingWidth*2, 3, 45, 45);
    [bagBtn setImage:[UIImage imageNamed:@"icon_gouwu"]  forState:UIControlStateNormal];
    [bagBtn setTitle:@"购物袋" forState:UIControlStateNormal];
    [bagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bagBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:10];

    CGFloat spacing2 = 1.0;
    CGSize imageSize2 = bagBtn.imageView.image.size;
    bagBtn.titleEdgeInsets = UIEdgeInsetsMake(
      0.0, - imageSize2.width, - (imageSize2.height + spacing2), 0.0);
    CGSize titleSize2 = [bagBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: bagBtn.titleLabel.font}];
    bagBtn.imageEdgeInsets = UIEdgeInsetsMake(
      - (titleSize2.height + spacing2), 0.0, 0.0, - titleSize2.width);
    CGFloat edgeOffset2 = (float)fabs(titleSize2.height - imageSize2.height) / 2.0;
    bagBtn.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset2, 0.0, edgeOffset2, 0.0);
    [bagBtn addTarget:self action:@selector(bagBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:bagBtn];
    
    _bagGoodsNum = [[UILabel alloc] initWithFrame:CGRectMake(45-22, 0, 18, 18)];
    _bagGoodsNum.backgroundColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
    _bagGoodsNum.layer.cornerRadius = 9;
    _bagGoodsNum.layer.masksToBounds = YES;
    _bagGoodsNum.textColor = BWTWhiteColor;
    _bagGoodsNum.textAlignment = NSTextAlignmentCenter;
    _bagGoodsNum.font = BWTBaseFont(12);
    _bagGoodsNum.text = @"0";
    _bagGoodsNum.hidden = YES;
    [bagBtn addSubview:_bagGoodsNum];
    
    UIButton *addBagBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-220, 0, 110, 50)];
    addBagBtn.backgroundColor =  [UIColor colorWithRed:255/255.0 green:163/255.0 blue:100/255.0 alpha:1/1.0];
    [addBagBtn setTitle:@"加入购物袋" forState:UIControlStateNormal];
    [addBagBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    addBagBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];;
    [addBagBtn addTarget:self action:@selector(addBagBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:addBagBtn];
    
    UIButton *buyNowBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-110, 0, 110, 50)];
    buyNowBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    [buyNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyNowBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    buyNowBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [buyNowBtn addTarget:self action:@selector(buyNowBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:buyNowBtn];
    
    
    [self.view addSubview:_footTabBar];
    
}
@end
