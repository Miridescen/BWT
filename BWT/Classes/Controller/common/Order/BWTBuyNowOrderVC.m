

//
//  BWTBuyNowOrderVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/26.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBuyNowOrderVC.h"
#import "BWTTextView.h"
#import "OrderGoodTVC.h"
#import "OrderCellModel.h"
#import "GoodDetailModel.h"
#import "BWTCanUseCouponVC.h"
#import "CouponModel.h"
#import "addressModel.h"
#import "BWTCheckoutVC.h"
#import "BWTAddressVC.h"
@interface BWTBuyNowOrderVC ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *detailAddressLabel;

@property (nonatomic, assign) CGFloat detailAddressLabelHeight;
@property (nonatomic, assign) CGFloat hasAddressBGviewHeight;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footTabBar;

@property (nonatomic, strong) UILabel *totalNumLabel;
@property (nonatomic, strong) UILabel *zongjiaLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UIView *hasAddressBgView;
@property (nonatomic, strong) UIView *noAddressBgView;
@property (nonatomic, assign) BOOL showNoAddressBgView;

@property (nonatomic, copy) NSString *addressName;
@property (nonatomic, copy) NSString *addressPhone;
@property (nonatomic, copy) NSString *addressDetail;

@property (nonatomic, strong) UILabel *xiaojiLabel; // 小计label
@property (nonatomic, assign) CGFloat xiaoji;  // 小计价格

@property (nonatomic, strong) UILabel *hejiLabel; // 合计label
@property (nonatomic, assign) CGFloat heji;  // 合计价格

@property (nonatomic, strong) UIImageView *couponArrowImg; // 优惠劵箭头
@property (nonatomic, strong) UILabel *couponNumLabel; // 可用优惠劵数量label
@property (nonatomic, assign) NSInteger canUseCouponNum; // 可用优惠劵数量

@property (nonatomic, strong) UILabel *couponUseLabel; // 使用优惠劵后显示价钱的label
@property (nonatomic, assign) BOOL isShowCouponUseLabel; // 是否显示couponUseLabel
@property (nonatomic, assign) CGFloat showCouponAmount; // 显示的优惠劵面值

@property (nonatomic, strong) BWTTextView *message;
@property (nonatomic, copy) NSString *remark; // 买家留言
@property (nonatomic, assign) NSInteger addressID;  // 地址ID

@property (nonatomic, strong) CouponModel *selectCoupon; // 选中的优惠劵
@end

@implementation BWTBuyNowOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";

    self.xiaoji = (CGFloat)(self.cellModel.goodNum * self.cellModel.price);

    self.heji = self.xiaoji;
    
    self.showNoAddressBgView = NO;
    self.addressName = @"收货人：";
    
    self.isShowCouponUseLabel = NO;
    self.canUseCouponNum = 0;
    self.showCouponAmount = 0.0;
    
    self.detailAddressLabelHeight = 16;
    self.hasAddressBGviewHeight = 73+16;
    
    [self setupTabView];
    [self setupFootBar];
    
    
    [self loadCouponData];
    [self loadAddressData];
}
- (void)loadAddressData{
    @weakify(self);
    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] init];
    [param1 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    [param1 setValue:BWTUsertoken forKey:@"token"];
    [AFNetworkTool postJSONWithUrl:Address_default parameters:param1 success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        addressModel *addressModel1 = [addressModel yy_modelWithJSON:responseObject];
        if (addressModel1) {
            
            self.addressID = addressModel1._id;
            
            self.showNoAddressBgView = NO;
            
            self.addressName = [NSString stringWithFormat:@"收货人：%@", addressModel1.name];
            self.addressPhone = addressModel1.telephone;
            self.addressDetail = [NSString stringWithFormat:@"%@%@", addressModel1.street, addressModel1.hourseNumber];
            
            CGSize addressDetailSize = [NSString sizeWithText:self.addressDetail font:self.detailAddressLabel.font maxW:kScreenWidth-70];
            self.detailAddressLabelHeight = addressDetailSize.height + 16;
            self.hasAddressBGviewHeight = 73 + self.detailAddressLabelHeight;
            BWTLog(@"detailAddressLabelHeight == %f", self.detailAddressLabelHeight);
            
        } else {
            self.showNoAddressBgView = YES;
        }
        [self.tableView reloadData];
        
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)loadCouponData{
    @weakify(self);

    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] initWithCapacity:1];
    [param1 setValue:[NSNumber numberWithInteger:self.goodModel.goodsCategoryId] forKey:@"category"];
    [param1 setValue:[NSNumber numberWithFloat:self.xiaoji] forKey:@"price"];
    [param1 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    [param1 setValue:BWTUsertoken forKey:@"token"];
    [AFNetworkTool postJSONWithUrl:Coupon_canuse_num parameters:param1 success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
//        BWTLog(@"%@", responseObject);
        NSInteger couponNum = [responseObject[@"existsCoupon"] integerValue];
        self.canUseCouponNum = couponNum;
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];

        
}

- (void)clearBtnClick:(UIButton *)btn{
    
    if (!self.addressID) {
        [MSTipView showWithMessage:@"请填写收货地址"];
        return;
    }

    @weakify(self);
    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] init];
    [param1 setValue:[NSNumber numberWithInteger:self.addressID] forKey:@"addressId"];
    [param1 setValue:[NSNumber numberWithInteger:self.goodModel.goodsCategoryId] forKey:@"category"];
    if (self.selectCoupon.couponAmount) {
        [param1 setValue:[NSNumber numberWithFloat:self.selectCoupon.couponAmount] forKey:@"couponAmount"];
    }
    if (self.selectCoupon._id) {
        [param1 setValue:[NSNumber numberWithInteger:self.selectCoupon._id] forKey:@"couponId"];
    }
    [param1 setValue:[NSNumber numberWithInteger:self.cellModel.goodNum] forKey:@"itemCount"];
    [param1 setValue:[NSNumber numberWithInteger:self.cellModel.skuID] forKey:@"itemId"];
    [param1 setValue:self.remark forKey:@"remark"];
    [param1 setValue:self.cellModel.snapshotVersion forKey:@"snapshotVersion"];
    [param1 setValue:self.cellModel.title forKey:@"title"];
    [param1 setValue:BWTUsertoken forKey:@"token"];
    [param1 setValue:[NSNumber numberWithFloat:self.heji] forKey:@"totalAmount"];
    [param1 setValue:[NSNumber numberWithFloat:self.xiaoji] forKey:@"totalRent"];
    [param1 setValue:[NSNumber numberWithFloat:self.cellModel.price] forKey:@"unitRent"];
    [param1 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    
    [AFNetworkTool postJSONWithUrl:Order_create parameters:param1 success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        if (responseObject) {
            BWTLog(@"%@", responseObject);
            if (self.heji == 0) {
                [MSTipView showWithMessage:@"下单成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                BWTCheckoutVC *checkoutVC = [[BWTCheckoutVC alloc] init];
                checkoutVC.amount = self.heji;
                checkoutVC.orderIDs = [NSString stringWithFormat:@"%@", responseObject];
                [self.navigationController pushViewController:checkoutVC animated:YES];
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
     
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
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
        self.phoneLabel.left = kScreenWidth-20-6-15-self.phoneLabel.width;
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
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 26, 10, 14)];
        arrowImg.image = [UIImage imageNamed:@"img_rightjiantou"];
        [_hasAddressBgView addSubview:arrowImg];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.hasAddressBGviewHeight-3, kScreenWidth, 3)];
        bottomLine.image = [UIImage imageNamed:@"img_adress"];
        [_hasAddressBgView addSubview:bottomLine];
        
        [cell.contentView addSubview:_hasAddressBgView];
        
        _noAddressBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 70)];
        _noAddressBgView.backgroundColor = BWTWhiteColor;
        
        UIImageView *log1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 24, 18, 22)];
        log1.image = [UIImage imageNamed:@"img_map"];
        [_noAddressBgView addSubview:log1];
        
        UILabel *addAddresslabel = [[UILabel alloc] init];
        addAddresslabel.frame = CGRectMake(52, 24, 112, 22);
        addAddresslabel.text = @"请添加收货地址";
        addAddresslabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        addAddresslabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [_noAddressBgView addSubview:addAddresslabel];
        
        UIImageView *arrowImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 28, 10, 14)];
        arrowImg1.image = [UIImage imageNamed:@"img_rightjiantou"];
        [_noAddressBgView addSubview:arrowImg1];
        
        UIImageView *bottomLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70-3, kScreenWidth, 3)];
        bottomLine1.image = [UIImage imageNamed:@"img_adress"];
        [_noAddressBgView addSubview:bottomLine1];
        
        [cell.contentView addSubview:_hasAddressBgView];
        [cell.contentView addSubview:_noAddressBgView];
        _hasAddressBgView.hidden = self.showNoAddressBgView;
        _noAddressBgView.hidden = !self.showNoAddressBgView;
        
        return cell;
    }
    if (indexPath.row == 1) {
        OrderGoodTVC *cell = [[OrderGoodTVC alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderCellModel = self.cellModel;
        
        return cell;
    }
    if (indexPath.row ==2) {
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
    if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    if (indexPath.row == 4) {
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
        
        _couponNumLabel = [[UILabel alloc] init];
        _couponNumLabel.frame = CGRectMake(kScreenWidth-20-6-7-50, 17, 63, 20);
        _couponNumLabel.text = [NSString stringWithFormat:@"%ld张可用", (long)self.canUseCouponNum];
        _couponNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _couponNumLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        self.couponNumLabel.width = [NSString sizeWithText:self.couponNumLabel.text font:self.couponNumLabel.font].width;
        self.couponNumLabel.left = kScreenWidth - self.couponNumLabel.width -20-6-7;
        _couponNumLabel.hidden = self.isShowCouponUseLabel;
        if (self.canUseCouponNum > 0) {
            self.couponNumLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
        } else {
            self.couponNumLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        }
        [bgView addSubview:_couponNumLabel];
        
        _couponArrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 20, 10, 14)];
        _couponArrowImg.image = [UIImage imageNamed:@"img_rightjiantou"];
//        _couponArrowImg.hidden = self.isShowCouponUseLabel;
        _couponArrowImg.hidden = NO;
        [bgView addSubview:_couponArrowImg];
        
        _couponUseLabel = [[UILabel alloc] init];
        _couponUseLabel.frame = CGRectMake(kScreenWidth-20-6-7-50, 17, 63, 20);
        _couponUseLabel.text = [NSString stringWithFormat:@"-¥%@", @(self.showCouponAmount)];
        _couponUseLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _couponUseLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
        self.couponUseLabel.width = [NSString sizeWithText:self.couponUseLabel.text font:self.couponUseLabel.font].width;
        self.couponUseLabel.left = kScreenWidth - self.couponUseLabel.width -20-6-7;
        _couponUseLabel.hidden = !self.isShowCouponUseLabel;
        [bgView addSubview:_couponUseLabel];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
        return cell;
    }
    
    if (indexPath.row == 5) {
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
        
        _hejiLabel = [[UILabel alloc] init];
        _hejiLabel.frame = CGRectMake(297, 17, 63, 20);
        _hejiLabel.text = [NSString stringWithFormat:@"¥%@", @(self.heji)];
        _hejiLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _hejiLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _hejiLabel.textAlignment = NSTextAlignmentRight;
        _hejiLabel.width = [NSString sizeWithText:_hejiLabel.text font:_hejiLabel.font].width;
        _hejiLabel.left = kScreenWidth - _hejiLabel.width - 20;
        [bgView addSubview:_hejiLabel];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
        return cell;
    }
    
    if (indexPath.row == 6) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = BWTBackgroundGrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgview = [[UIView alloc] init];
        bgview.frame = CGRectMake(0, 10, kScreenWidth, 80);
        bgview.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        [cell addSubview:bgview];
        
        _message = [[BWTTextView alloc] initWithFrame:CGRectMake(16, 10, kScreenWidth-32, 60)];
        _message.placeholder = @"请输入买家留言";
        _message.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _message.delegate = self;
        _message.returnKeyType = UIReturnKeyDone;
        [bgview addSubview:_message];
        return cell;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (_showNoAddressBgView) {
            return 80;
        } else {
            return self.hasAddressBGviewHeight+10;
        }
    }
    if (indexPath.row == 1){
        return 130;
    }
    if (indexPath.row == 2) {
        return 65;
    }
    if (indexPath.row > 2 && indexPath.row < 6) {
        return 55;
    }
    if (indexPath.row == 6) {
        return 100;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        BWTAddressVC *addressVC = [[BWTAddressVC alloc] init];
        @weakify(self);
        addressVC.selectRowBlock = ^(addressModel * _Nonnull address) {
            @strongify(self);
            if (!self) return;
            if (address) {
                self.addressID = address._id;
                self.addressName = [NSString stringWithFormat:@"收货人：%@", address.name];
                self.addressPhone = address.telephone;
                self.addressDetail = [NSString stringWithFormat:@"%@%@", address.street, address.hourseNumber];
                
                CGSize addressDetailSize = [NSString sizeWithText:self.addressDetail font:self.detailAddressLabel.font maxW:kScreenWidth-70];
                self.detailAddressLabelHeight = addressDetailSize.height + 16;
                self.hasAddressBGviewHeight = 73 + self.detailAddressLabelHeight;
                
                self.showNoAddressBgView = NO;
                
                [self.tableView reloadData];
            }
            
        };
        [self.navigationController pushViewController:addressVC animated:YES];
   
    }
    if (indexPath.row == 4) {
        BWTCanUseCouponVC *couponVC = [[BWTCanUseCouponVC alloc] init];
        couponVC.category = self.goodModel.goodsCategoryId;
        couponVC.price = self.xiaoji;
        @weakify(self);
        couponVC.couponUseBlock = ^(CouponModel * _Nonnull couponModel) {
            @strongify(self);
            if (!self) return;
            if (couponModel) {
                self.selectCoupon = couponModel;
                
                self.showCouponAmount = couponModel.couponAmount;
                
                self.isShowCouponUseLabel = YES;
                self.heji = self.xiaoji-couponModel.couponAmount;
                if (self.heji <= 0) {
                    self.heji = 0;
                }
                [self.tableView reloadData];
                
                self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", @(self.heji)];
                self.totalPriceLabel.width = [NSString sizeWithText:self.totalPriceLabel.text font:self.totalPriceLabel.font].width;
//                self.totalPriceLabel.left = 20 + self.totalNumLabel.width + 20;
            }
            BWTLog(@"%.2f", couponModel.couponAmount);
        };
        [self.navigationController pushViewController:couponVC animated:YES];
    }
}

- (void)setupFootBar{
    self.footTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavigationBarHeight-kTabBarHeight, kScreenWidth, kTabBarHeight)];
//    _footTabBar.layer.masksToBounds = NO;
    _footTabBar.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.1];
    [_footTabBar addSubview:lineView];
    [self.view addSubview:_footTabBar];
    
    NSString *totalNumStr = [NSString stringWithFormat:@"共%ld件", (long)self.cellModel.goodNum];
    NSAttributedString *totalNumAttrStr = [[NSAttributedString alloc] initWithString:totalNumStr];
    NSMutableAttributedString *metableAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:totalNumAttrStr];
    [metableAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#E33B30"] range:NSMakeRange(1, metableAttrStr.length-2)];
    _totalNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 42, 22)];
    _totalNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _totalNumLabel.text = [NSString stringWithFormat:@"共%ld件", (long)self.cellModel.goodNum];
    _totalNumLabel.textColor = BWTFontBlackColor;
    _totalNumLabel.width = [NSString sizeWithText:_totalNumLabel.text font:_totalNumLabel.font].width;
    _totalNumLabel.attributedText = [[NSAttributedString alloc] initWithString:totalNumStr];
    _totalNumLabel.attributedText = metableAttrStr;
    
    [_footTabBar addSubview:_totalNumLabel];
    
    UILabel *hejilabel = [[UILabel alloc] init];
    hejilabel.frame = CGRectMake(VIEW_BX(_totalNumLabel)+20, (49-22)/2, 48, 22);
    hejilabel.text = @"合计：";
    hejilabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    hejilabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [_footTabBar addSubview:hejilabel];
    
    _totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.frame = CGRectMake(VIEW_BX(hejilabel), (49-25)/2, 81, 25);
    _totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", @(self.heji)];
    _totalPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _totalPriceLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];

    _totalPriceLabel.width = [NSString sizeWithText:_totalPriceLabel.text font:_totalPriceLabel.font].width;
    
    [_footTabBar addSubview:_totalPriceLabel];
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100.0/375*kScreenWidth, 0, 100.0/375*kScreenWidth, 50)];
    _clearBtn.backgroundColor = BWTMainColor;
    [_clearBtn setTitle:[NSString stringWithFormat:@"提交订单"] forState:UIControlStateNormal];
    [_clearBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _clearBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:_clearBtn];
     
    
    [self.view addSubview:_footTabBar];
}


- (void)setupTabView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight)];
    _tableView.backgroundColor = BWTBackgroundGrayColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}
#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.remark = textView.text;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if([text isEqualToString:@"\n"]){
        self.remark = textView.text;
        [textView resignFirstResponder];
        return NO;

    }
    return YES;
    
}

@end
