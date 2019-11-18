
//
//  OrderTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/23.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "OrderTVC.h"
#import "OrderGoodTVC.h"
#import "OrderModel.h"
#import "OrderDetailModel.h"

@interface subOrderTVC ()

@property (nonatomic, strong) UIImageView *goodImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation subOrderTVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = BWTBackgroundGrayColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    bgView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:bgView];
    
    _goodImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    _goodImgView.layer.borderWidth = 1;
    _goodImgView.layer.borderColor = [UIColor colorWithHexString:@"#F6F6F6"].CGColor;
    [bgView addSubview:_goodImgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 20, kScreenWidth-127, 47)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
    _titleLabel.numberOfLines = 0;
    [bgView addSubview:_titleLabel];
    
    _standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 80, kScreenWidth-170, 20)];
    _standardLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _standardLabel.textAlignment = NSTextAlignmentLeft;
    _standardLabel.textColor = BWTFontBlackColor;
    [bgView addSubview:_standardLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-85, 80, 65, 20)];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _priceLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [bgView addSubview:_priceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119, kScreenWidth, 1)];
    lineView.backgroundColor = BWTBackgroundGrayColor;
    [bgView addSubview:lineView];
    
}

- (void)setSubOrderList:(subOrderList *)subOrderList{
    _subOrderList = subOrderList;
    
    [_goodImgView sd_setImageWithURL:[NSURL URLWithString:_subOrderList.goodsImg]];
    _titleLabel.text = _subOrderList.title;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _titleLabel.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_subOrderList.title attributes:attributes];
    [_titleLabel sizeToFit];
    
    _standardLabel.text = [NSString stringWithFormat:@"规格：%@", _subOrderList.standards];
    _standardLabel.width = [NSString sizeWithText:_standardLabel.text font:_standardLabel.font].width;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@ x %ld", @(_subOrderList.itemPrice), _subOrderList.itemCount];
    CGFloat priceLabelWidth = [NSString sizeWithText:_priceLabel.text font:_priceLabel.font].width;
    _priceLabel.width = priceLabelWidth;
    _priceLabel.left = kScreenWidth - priceLabelWidth - 20;
}
- (void)setDetailSubOrder:(subOrderListDetail *)detailSubOrder{
    _detailSubOrder = detailSubOrder;
    [_goodImgView sd_setImageWithURL:[NSURL URLWithString:_detailSubOrder.goodsImg]];
    _titleLabel.text = _detailSubOrder.title;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _titleLabel.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_detailSubOrder.title attributes:attributes];
    [_titleLabel sizeToFit];
    
    _standardLabel.text = [NSString stringWithFormat:@"规格：%@", _detailSubOrder.standards];
    _standardLabel.width = [NSString sizeWithText:_standardLabel.text font:_standardLabel.font].width;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@ x %ld", @(_detailSubOrder.itemPrice), _detailSubOrder.itemCount];
    CGFloat priceLabelWidth = [NSString sizeWithText:_priceLabel.text font:_priceLabel.font].width;
    _priceLabel.width = priceLabelWidth;
    _priceLabel.left = kScreenWidth - priceLabelWidth - 20;
}


@end
// ======================================================================
@interface OrderTVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UILabel *stateLabel;
// --------------------------------------------------

@property (nonatomic, strong) UITableView *subOrderTV;

@property (nonatomic, strong) NSArray *subOrderDataArr;
// --------------------------------------------------
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *itemCountLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) UIButton *stateBtnOne;
@property (nonatomic, strong) UIButton *stateBtnTwo;



@property (nonatomic, assign) OrderCellType orderCellType;

@end

@implementation OrderTVC


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubView];
        
    }
    return self;
}
- (void)setupSubView{
    _headerView = [[UIView alloc] init];
    _headerView.frame = CGRectMake(0, 10, kScreenWidth, 45);
    _headerView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:_headerView];
    
    _orderNumLabel = [[UILabel alloc] init];
    _orderNumLabel.frame = CGRectMake(20, 13, 204, 20);
    _orderNumLabel.font = BWTBaseFont(14);
    _orderNumLabel.textColor = BWTFontBlackColor;
    [_headerView addSubview:_orderNumLabel];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.frame = CGRectMake(kScreenWidth-20-42, 13, 42, 20);
    _stateLabel.font = BWTBaseFont(14);
    [_headerView addSubview:_stateLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    lineView.backgroundColor = BWTBackgroundGrayColor;
    [_headerView addSubview:lineView];
    // ------------------------------------------------
    _subOrderTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, kScreenWidth, 20)];
    _subOrderTV.backgroundColor = BWTBackgroundGrayColor;
    _subOrderTV.delegate = self;
    _subOrderTV.dataSource = self;
    _subOrderTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subOrderTV.bounces = NO;
    _subOrderTV.showsVerticalScrollIndicator = NO;
    _subOrderTV.showsHorizontalScrollIndicator = NO;

    [self.contentView addSubview:_subOrderTV];
    
    
    // ------------------------------------------------

    _footerView = [[UIView alloc] init];
    _footerView.frame = CGRectMake(0, 362, kScreenWidth, 95);
    _footerView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:_footerView];
    
    _itemCountLabel = [[UILabel alloc] init];
    _itemCountLabel.frame = CGRectMake(188, 15, 97, 20);
    _itemCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _itemCountLabel.textColor = BWTFontBlackColor;
    [_footerView addSubview:_itemCountLabel];
    
    
    _totalPriceLabel = [[UILabel alloc] init];
    _totalPriceLabel.frame = CGRectMake(290, 11, 70, 25);
    _totalPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _totalPriceLabel.textColor = BWTFontBlackColor;
    [_footerView addSubview:_totalPriceLabel];
    
    _stateBtnOne = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-76-15-76, 51, 76, 30)];
    _stateBtnOne.layer.borderWidth = 1;
    _stateBtnOne.layer.cornerRadius = 2;
    _stateBtnOne.titleLabel.font = BWTBaseFont(14);
    [_stateBtnOne addTarget:self action:@selector(stateOneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_stateBtnOne];
    
    _stateBtnTwo = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-76, 51, 76, 30)];
    _stateBtnTwo.layer.borderWidth = 1;
    _stateBtnTwo.layer.cornerRadius = 2;
    _stateBtnTwo.titleLabel.font = BWTBaseFont(14);
    [_stateBtnTwo addTarget:self action:@selector(stateTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_stateBtnTwo];
    
    
}

- (void)setOrderModel:(OrderModel *)orderModel{
    _orderModel = orderModel;
    
    if ([_orderModel.orderState isEqualToString:@"finish"]) {
        _orderCellType = OrderCellTypeFinished;
        _footerView.height = 50;
    } else if ([_orderModel.orderState isEqualToString:@"canceled"]) {
        _orderCellType = OrderCellTypeCanceled;
    } else if ([_orderModel.orderState isEqualToString:@"wait_pay"]) {
        _orderCellType = OrderCellTypeWaitPay;
    } else if ([_orderModel.orderState isEqualToString:@"wait_deliver"]) {
        _orderCellType = OrderCellTypeWaitDeliver;
        _footerView.height = 50;
    } else if ([_orderModel.orderState isEqualToString:@"wait_receive"]) {
        _orderCellType = OrderCellTypeWaitReceive;
    }
    
    
    _orderNumLabel.text = [NSString stringWithFormat:@"订单号：%@", _orderModel.orderId];
    _orderNumLabel.width = [NSString sizeWithText:_orderNumLabel.text font:BWTBaseFont(14)].width;
    
    _stateLabel.text = _orderModel.orderStateName;
    
    switch (_orderCellType) {
        case OrderCellTypeFinished:
            _stateLabel.textColor = BWTFontGrayColor;
            _stateBtnOne.hidden = YES;
            _stateBtnTwo.hidden = YES;
            break;
        case OrderCellTypeCanceled:
            _stateLabel.textColor = BWTFontGrayColor;
            _stateBtnOne.hidden = YES;
            _stateBtnTwo.hidden = NO;
            [_stateBtnTwo setTitle:@"删除订单" forState:UIControlStateNormal];
            [_stateBtnTwo setTitleColor: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            _stateBtnTwo.layer.borderColor = [BWTFontGrayColor CGColor];
            break;
        case OrderCellTypeWaitPay:
            _stateLabel.textColor = RGBColor(255, 102, 0);
            _stateBtnOne.hidden = NO;
            [_stateBtnOne setTitle:@"取消订单" forState:UIControlStateNormal];
            [_stateBtnOne setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            _stateBtnOne.layer.borderColor = [BWTFontGrayColor CGColor];
            _stateBtnTwo.hidden = NO;
            [_stateBtnTwo setTitle:@"去支付" forState:UIControlStateNormal];
            [_stateBtnTwo setTitleColor:RGBColor(255, 102, 0) forState:UIControlStateNormal];
            _stateBtnTwo.layer.borderColor = [RGBColor(255, 102, 0) CGColor];
        
            break;
        case OrderCellTypeWaitDeliver:
            _stateLabel.textColor = RGBColor(255, 102, 0);
            _stateBtnOne.hidden = YES;
            _stateBtnTwo.hidden = YES;
        
            break;
        case OrderCellTypeWaitReceive:
            _stateLabel.textColor = RGBColor(255, 102, 0);
            _stateBtnOne.hidden = YES;
            _stateBtnTwo.hidden = NO;
            [_stateBtnTwo setTitle:@"确认收货" forState:UIControlStateNormal];
            [_stateBtnTwo setTitleColor:RGBColor(255, 102, 0) forState:UIControlStateNormal];
            _stateBtnTwo.layer.borderColor = [RGBColor(255, 102, 0) CGColor];
            break;
            
        default:
            break;
    }

    _subOrderDataArr = _orderModel.subOrderList;
    _subOrderTV.height = _subOrderDataArr.count*120;
    [self.subOrderTV reloadData];

    _footerView.top = VIEW_BY(_subOrderTV);
    
    NSString *couponStr = _orderModel.couponAmount>0?[NSString stringWithFormat:@"优惠券：-¥%@  ", @(_orderModel.couponAmount)]:@"";
    
    _itemCountLabel.text = [NSString stringWithFormat:@"共%ld件  %@合计：¥", (long)_orderModel.itemCount, couponStr];
    
    _totalPriceLabel.text = [NSString stringWithFormat:@"%@", @(_orderModel.totalAmount)];
    _totalPriceLabel.width = [NSString sizeWithText:_totalPriceLabel.text font:_totalPriceLabel.font].width;
    _totalPriceLabel.left = kScreenWidth-20-_totalPriceLabel.width;
    
    _itemCountLabel.width = [NSString sizeWithText:_itemCountLabel.text font:_itemCountLabel.font].width;
    _itemCountLabel.left = kScreenWidth-20-_itemCountLabel.width-_totalPriceLabel.width-8;
}

- (void)stateOneBtnClick:(UIButton *)btn{
    if (self.stateOneBtnBlock) {
        self.stateOneBtnBlock(_orderCellType);
    }
}
- (void)stateTwoBtnClick:(UIButton *)btn{
    if (self.stateTwoBtnBlock) {
        self.stateTwoBtnBlock(_orderCellType);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subOrderDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    subOrderTVC *cell = [[subOrderTVC alloc] init];
    cell.subOrderList = self.subOrderDataArr[indexPath.row];
    cell.backgroundColor = BWTBackgroundGrayColor;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.subCellClickBlock) {
        self.subCellClickBlock();
    }
}
@end
