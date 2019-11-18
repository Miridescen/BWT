
//
//  BWTOrderDetailVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/28.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTOrderDetailVC.h"

#import "OrderTVC.h"
#import "OrderCellModel.h"
#import "OrderDetailModel.h"
#import "BWTCheckoutVC.h"

@interface BWTOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OrderDetailModel *detailModel;
@property (nonatomic, assign) BOOL showFootBar;
@property (nonatomic, strong) UILabel *totalNumLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, assign) CGFloat heji;//合计
@property (nonatomic, assign) NSInteger totalItemCount; // 总商品数

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footTabBar;

@property (nonatomic, strong) UILabel *orderTypeLable;
@property (nonatomic, copy) NSString *orderTypeStr;

@property (nonatomic, strong) UIView *hasAddressBgView;  // 地址
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *detailAddressLabel;
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic, copy) NSString *addressPhone;
@property (nonatomic, copy) NSString *addressDetail;

@property (nonatomic, assign) CGFloat detailAddressLabelHeight;
@property (nonatomic, assign) CGFloat hasAddressBGviewHeight;

@property (nonatomic, strong) NSArray *cellModelArr;  // 商品

@property (nonatomic, strong) UILabel *xiaojiLabel; // 小计label
@property (nonatomic, assign) CGFloat xiaoji;  // 小计价格

@property (nonatomic, strong) UILabel *couponUseLabel; // 使用优惠劵后显示价钱的label
@property (nonatomic, assign) CGFloat showCouponAmount; // 显示的优惠劵面值

@property (nonatomic, strong) UILabel *orderIDLabel; // 订单号label
@property (nonatomic, copy) NSString *orderIDStr; // 订单号

@property (nonatomic, strong) UILabel *createTimeLabel; // 创建时间label
@property (nonatomic, copy) NSString *createTimeStr; // 创建时间

@end

@implementation BWTOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    self.xiaoji = 0;
    self.heji = 0;
    self.totalItemCount = 0;
    
    self.detailAddressLabelHeight = 16;
    self.hasAddressBGviewHeight = 73+16;
    
    switch (self.orderDetailVCType) {
            
        case OrderDetailVCTypeWaitPay:
            self.orderTypeStr = @"待付款";
            self.showFootBar = YES;
            break;
        case OrderDetailVCTypeWaitReceive:
            self.orderTypeStr = @"待收货";
            self.showFootBar = YES;
            break;
        case OrderDetailVCTypeWaitDeliver:
            self.orderTypeStr = @"待发货";
            self.showFootBar = NO;
            break;
        case OrderDetailVCTypeCanceled:
            self.orderTypeStr = @"已取消";
            self.showFootBar = NO;
            break;
        case OrderDetailVCTypeFinished:
            self.orderTypeStr = @"订单已关闭";
            self.showFootBar = NO;
            break;
        default:
            break;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
    _tableView.backgroundColor = BWTBackgroundGrayColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;

    [self.view addSubview:_tableView];

    [self loadData];
}
- (void)loadData{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:BWTUsertoken forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    [param setValue:self.orderID forKey:@"orderId"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:Order_detail parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        if (responseObject) {
            self.detailModel = [OrderDetailModel yy_modelWithJSON:responseObject];
            
            self.addressName = [NSString stringWithFormat:@"收货人：%@", self.detailModel.orderAddress.receiver];
            self.addressPhone = self.detailModel.orderAddress.mobile;
            self.addressDetail = self.detailModel.orderAddress.address;
            
            CGSize addressDetailSize = [NSString sizeWithText:self.addressDetail font:self.detailAddressLabel.font maxW:kScreenWidth-70];
            self.detailAddressLabelHeight = addressDetailSize.height + 16;
            self.hasAddressBGviewHeight = 73 + self.detailAddressLabelHeight;
            
            self.xiaoji = self.detailModel.orderApply.totalRent;
            self.showCouponAmount = self.detailModel.orderApply.couponAmount;
            self.orderIDStr = self.detailModel.orderApply.orderId;
            self.createTimeStr = self.detailModel.orderApply.applyDate;
            
            self.heji = self.detailModel.orderApply.totalAmount;
            self.totalItemCount = self.detailModel.orderApply.itemCount;
            
            self.cellModelArr = self.detailModel.subOrderList;
            
            if ([self.detailModel.orderApply.orderState isEqualToString:@"finish"]) {
                self.orderDetailVCType = OrderDetailVCTypeFinished;
                self.orderTypeStr = @"订单已关闭";
                self.showFootBar = NO;
            } else if ([self.detailModel.orderApply.orderState isEqualToString:@"canceled"]) {
                self.orderDetailVCType = OrderDetailVCTypeCanceled;
                self.orderTypeStr = @"已取消";
                self.showFootBar = NO;
                
            } else if ([self.detailModel.orderApply.orderState isEqualToString:@"wait_pay"]) {
                self.orderDetailVCType = OrderDetailVCTypeWaitPay;
                self.orderTypeStr = @"待付款";
                self.showFootBar = YES;
                self.tableView.height = kScreenHeight-kNavigationBarHeight-kTabBarHeight;
                self.couponUseLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
                [self addfootBar];
            } else if ([self.detailModel.orderApply.orderState isEqualToString:@"wait_deliver"]) {
                self.orderDetailVCType = OrderDetailVCTypeWaitDeliver;
                self.orderTypeStr = @"待发货";
                self.showFootBar = NO;
            } else if ([self.detailModel.orderApply.orderState isEqualToString:@"wait_receive"]) {
                self.orderDetailVCType = OrderDetailVCTypeWaitReceive;
                self.orderTypeStr = @"待收货";
                self.showFootBar = YES;
                self.tableView.height = kScreenHeight-kNavigationBarHeight-kTabBarHeight;
                [self addfootBar];
            }

            [self.tableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)clearBtnClick:(UIButton *)btn{
    BWTCheckoutVC *checkoutVC = [[BWTCheckoutVC alloc] init];
    checkoutVC.amount = self.heji;
    [self.navigationController pushViewController:checkoutVC animated:YES];
}
- (void)sureReceiveBtnClick:(UIButton *)btn{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定收货？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:self.orderIDStr forKey:@"orderId"];
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:Order_sure parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            BWTLog(@"%@", responseObject);
            [self loadData];
            
        } fail:^(NSError *error) {
            
        }];
        
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)addfootBar{
    
    self.footTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavigationBarHeight-kTabBarHeight, kScreenWidth, kTabBarHeight)];
    _footTabBar.backgroundColor = [UIColor whiteColor];
    _footTabBar.hidden = !self.showFootBar;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.1];
    [_footTabBar addSubview:lineView];
    [self.view addSubview:_footTabBar];
    
    UIView *payBgView = [[UIView alloc] initWithFrame:self.footTabBar.bounds];
    
    NSString *totalNumStr = [NSString stringWithFormat:@"共%ld件", (long)self.totalItemCount];
    NSAttributedString *totalNumAttrStr = [[NSAttributedString alloc] initWithString:totalNumStr];
    NSMutableAttributedString *metableAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:totalNumAttrStr];
    [metableAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#E33B30"] range:NSMakeRange(1, metableAttrStr.length-2)];
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 42, 22)];
    _totalNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _totalNumLabel.text = [NSString stringWithFormat:@"共%ld件", (long)self.totalItemCount];
    _totalNumLabel.textColor = BWTFontBlackColor;
    _totalNumLabel.width = [NSString sizeWithText:_totalNumLabel.text font:_totalNumLabel.font].width;
    _totalNumLabel.attributedText = [[NSAttributedString alloc] initWithString:totalNumStr];
    _totalNumLabel.attributedText = metableAttrStr;
    
    [payBgView addSubview:_totalNumLabel];
    
    UILabel *hejilabel = [[UILabel alloc] init];
    hejilabel.frame = CGRectMake(VIEW_BX(_totalNumLabel)+20, (49-22)/2, 48, 22);
    hejilabel.text = @"合计：";
    hejilabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    hejilabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [payBgView addSubview:hejilabel];
    
    _totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.frame = CGRectMake(VIEW_BX(hejilabel), (49-25)/2, 81, 25);
    _totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", @(self.heji)];
    _totalPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _totalPriceLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];

    _totalPriceLabel.width = [NSString sizeWithText:_totalPriceLabel.text font:_totalPriceLabel.font].width;
//    _totalPriceLabel.left = 20 + _totalNumLabel.width + 20;
    [payBgView addSubview:_totalPriceLabel];
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100.0/375*kScreenWidth, 0, 100.0/375*kScreenWidth, 50)];
    _clearBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    [_clearBtn setTitle:[NSString stringWithFormat:@"支付"] forState:UIControlStateNormal];
    [_clearBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _clearBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [payBgView addSubview:_clearBtn];
    
    if (self.orderDetailVCType == OrderDetailVCTypeWaitPay) {
        [_footTabBar addSubview:payBgView];
        _tableView.height = kScreenHeight-kNavigationBarHeight-kTabBarHeight;
    }
    
    UIView *sureReceiveBgView = [[UIView alloc] initWithFrame:self.footTabBar.bounds];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, kScreenWidth-40, 40)];
    payBtn.backgroundColor = BWTMainColor;
    [payBtn setTitle:[NSString stringWithFormat:@"确认收货"] forState:UIControlStateNormal];
    [payBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [payBtn addTarget:self action:@selector(sureReceiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureReceiveBgView addSubview:payBtn];
    
    if (self.orderDetailVCType == OrderDetailVCTypeWaitReceive) {
        _footTabBar.frame = CGRectMake(0, kScreenHeight-kNavigationBarHeight-kTabBarHeight-10, kScreenWidth, kTabBarHeight+10);
        [_footTabBar addSubview:payBgView];
        _tableView.height = kScreenHeight-kNavigationBarHeight-kTabBarHeight-10;
    }

    [self.view addSubview:_footTabBar];

  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8 + self.cellModelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#FF6600"];
        
        _orderTypeLable = [[UILabel alloc] init];
        _orderTypeLable.frame = CGRectMake(20, 21, kScreenWidth-40, 30);
        _orderTypeLable.text = self.orderTypeStr;
        _orderTypeLable.textAlignment = NSTextAlignmentLeft;
        _orderTypeLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
        _orderTypeLable.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        [bgView addSubview:_orderTypeLable];
        
        [cell addSubview:bgView];
        
        return cell;

    }
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _hasAddressBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, self.hasAddressBGviewHeight)];
        _hasAddressBgView.backgroundColor = BWTWhiteColor;
        
        UIImageView *log = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 18, 22)];
        log.image = [UIImage imageNamed:@"img_map"];
        [_hasAddressBgView addSubview:log];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(52, 21, 112, 22);
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _nameLabel.text = self.addressName;
        self.nameLabel.width = [NSString sizeWithText:self.nameLabel.text font:self.nameLabel.font].width;
        [_hasAddressBgView addSubview:_nameLabel];
        
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.frame = CGRectMake(236, 21, 102, 22);
        _phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _phoneLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _phoneLabel.text = self.addressPhone;
        self.phoneLabel.width = [NSString sizeWithText:self.phoneLabel.text font:self.phoneLabel.font].width;
        self.phoneLabel.left = kScreenWidth-20-self.phoneLabel.width;
        [_hasAddressBgView addSubview:_phoneLabel];
        
        _detailAddressLabel = [[UILabel alloc] init];
        _detailAddressLabel.frame = CGRectMake(51, VIEW_BY(_phoneLabel)+16, kScreenWidth-70, self.detailAddressLabelHeight);
        _detailAddressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _detailAddressLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        _detailAddressLabel.numberOfLines = 0;
        _detailAddressLabel.text = self.addressDetail;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.maximumLineHeight = 20;
        paragraphStyle.minimumLineHeight = 20;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        CGFloat baselineOffset = (20 - _detailAddressLabel.font.lineHeight) / 4;
        [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.addressDetail]?[NSString stringWithFormat:@"%@", self.addressDetail]:@"" attributes:attributes];
        if (![attrStr.string isEqualToString:@"(null)"]) {
            _detailAddressLabel.attributedText = attrStr;
        }
        [_detailAddressLabel sizeToFit];
        
        [_hasAddressBgView addSubview:_detailAddressLabel];
        
        UIImageView *bottomLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.hasAddressBGviewHeight-3, kScreenWidth, 3)];
        bottomLine1.image = [UIImage imageNamed:@"img_adress"];
        [_hasAddressBgView addSubview:bottomLine1];
        
        [cell.contentView addSubview:_hasAddressBgView];
        
        return cell;
    }
    if (indexPath.row > 1 && indexPath.row <= self.cellModelArr.count + 1) {
        subOrderTVC *cell = [[subOrderTVC alloc] init];
        cell.detailSubOrder = self.cellModelArr[indexPath.row - 2];
        
        return cell;
    }
    if (self.cellModelArr.count+1 < indexPath.row && indexPath.row <=2 + self.cellModelArr.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"小计";
        [bgView addSubview:nameLabel];
        
        _xiaojiLabel = [[UILabel alloc] init];
        _xiaojiLabel.frame = CGRectMake(297, 17, 63, 20);
        _xiaojiLabel.text = [NSString stringWithFormat:@"¥%@", @(self.xiaoji)];
        _xiaojiLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _xiaojiLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _xiaojiLabel.textAlignment = NSTextAlignmentRight;
        _xiaojiLabel.width = [NSString sizeWithText:_xiaojiLabel.text font:_xiaojiLabel.font].width;
        _xiaojiLabel.left = kScreenWidth - _xiaojiLabel.width - 20;
        
        [bgView addSubview:_xiaojiLabel];

        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
        return cell;
    }
    if (self.cellModelArr.count + 2 < indexPath.row && indexPath.row <=3 + self.cellModelArr.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"运费";
        [bgView addSubview:nameLabel];
        
        UILabel *infolabel = [[UILabel alloc] init];
        infolabel.frame = CGRectMake(kScreenWidth-20-63, 17, 63, 20);
        infolabel.text = @"商家包邮";
        infolabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        infolabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        infolabel.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:infolabel];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
        return cell;
    }
    
    if (self.cellModelArr.count + 3 < indexPath.row && indexPath.row <=4 + self.cellModelArr.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"优惠劵";
        [bgView addSubview:nameLabel];

        _couponUseLabel = [[UILabel alloc] init];
        _couponUseLabel.frame = CGRectMake(kScreenWidth-20-6-7-50, 17, 63, 20);
//        _couponUseLabel.text = [NSString stringWithFormat:@"-¥%.2f", self.showCouponAmount];
        _couponUseLabel.text = self.showCouponAmount>0?[NSString stringWithFormat:@"-¥%@", @(self.showCouponAmount)]:@"无";
        _couponUseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _couponUseLabel.textColor = BWTFontBlackColor;
        _couponUseLabel.textAlignment = NSTextAlignmentRight;
        self.couponUseLabel.width = [NSString sizeWithText:self.couponUseLabel.text font:self.couponUseLabel.font].width;
        self.couponUseLabel.left = kScreenWidth - self.couponUseLabel.width -20;
        [bgView addSubview:_couponUseLabel];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
        return cell;
    }
    
    if (self.cellModelArr.count + 4 < indexPath.row && indexPath.row <=5 + self.cellModelArr.count) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = BWTBackgroundGrayColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
            bgView.backgroundColor = BWTWhiteColor;
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
            nameLabel.textColor = BWTFontBlackColor;
            nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.text = @"合计";
            [bgView addSubview:nameLabel];
        
            UILabel *hejiLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-20-6-7-50, 17, 63, 20)];
            hejiLabel.text = [NSString stringWithFormat:@"¥%@", @(self.heji)];
            hejiLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            hejiLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
            hejiLabel.textAlignment = NSTextAlignmentRight;
            hejiLabel.width = [NSString sizeWithText:hejiLabel.text font:hejiLabel.font].width;
            hejiLabel.left = kScreenWidth - hejiLabel.width -20;
            [bgView addSubview:hejiLabel];
            
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
            lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
            [cell.contentView.layer addSublayer:lineLayer];
            
            [cell.contentView addSubview:bgView];
            
            return cell;
        }
    
    if (self.cellModelArr.count + 5 < indexPath.row && indexPath.row <=6 + self.cellModelArr.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"订单编号";
        [bgView addSubview:nameLabel];
        
        _orderIDLabel = [[UILabel alloc] init];
        _orderIDLabel.frame = CGRectMake(297, 17, 63, 20);
        _orderIDLabel.text = self.orderID;
        _orderIDLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _orderIDLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _orderIDLabel.textAlignment = NSTextAlignmentRight;
        _orderIDLabel.width = [NSString sizeWithText:_orderIDLabel.text font:_orderIDLabel.font].width;
        _orderIDLabel.left = kScreenWidth - _orderIDLabel.width - 20;
        
        [bgView addSubview:_orderIDLabel];

        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
        return cell;
    }
    
    if (self.cellModelArr.count + 6 < indexPath.row && indexPath.row <=7 + self.cellModelArr.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"创建时间";
        [bgView addSubview:nameLabel];
        
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.frame = CGRectMake(297, 17, 63, 20);
        _createTimeLabel.text = self.createTimeStr;
        _createTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _createTimeLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _createTimeLabel.textAlignment = NSTextAlignmentRight;
        _createTimeLabel.width = [NSString sizeWithText:_createTimeLabel.text font:_createTimeLabel.font].width;
        _createTimeLabel.left = kScreenWidth - _createTimeLabel.width - 20;
        
        [bgView addSubview:_createTimeLabel];

        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell addSubview:bgView];
        return cell;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }
    if (indexPath.row == 1) {
        return self.hasAddressBGviewHeight + 20;
    }
    if (indexPath.row > 1 && indexPath.row <= self.cellModelArr.count + 1){
        return 120;
    }
    if (self.cellModelArr.count + 1 < indexPath.row && indexPath.row <=2 + self.cellModelArr.count) {
        return 65;
    }
    if (self.cellModelArr.count + 2 < indexPath.row && indexPath.row <=5 + self.cellModelArr.count) {
        return 55;
    }
    if (self.cellModelArr.count + 5 < indexPath.row && indexPath.row <=6 + self.cellModelArr.count) {
        return 65;
    }
    if (self.cellModelArr.count + 6 < indexPath.row && indexPath.row <=7 + self.cellModelArr.count) {
        return 55;
    }

    return 0;
}


@end
