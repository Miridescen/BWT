
//
//  OrderGoodTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/21.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "OrderGoodTVC.h"
#import "OrderCellModel.h"

@interface OrderGoodTVC ()

@property (nonatomic, strong) UIImageView *goodImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *numGroupView;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UILabel *goodNumLabel;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation OrderGoodTVC
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 120)];
    bgView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:bgView];
    
    _goodImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    _goodImg.layer.borderWidth = 1;
    _goodImg.layer.borderColor = [UIColor colorWithHexString:@"#F6F6F6"].CGColor;
    [bgView addSubview:_goodImg];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 20, kScreenWidth-127, 47)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
    
//    _titleLabel.text = @"adidas Yeezy 700 Wave Runner Solid Grey  (38码) (735)";
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
    
}

- (void)setOrderCellModel:(OrderCellModel *)orderCellModel{
    _orderCellModel = orderCellModel;
    
    [_goodImg sd_setImageWithURL:[NSURL URLWithString:_orderCellModel.imgUrl]];
    _titleLabel.text = _orderCellModel.title;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _titleLabel.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_orderCellModel.title attributes:attributes];
    [_titleLabel sizeToFit];
    
    _standardLabel.text = [NSString stringWithFormat:@"规格:%@", _orderCellModel.standard];
    _standardLabel.width  = [NSString sizeWithText:_standardLabel.text font:_standardLabel.font].width + 1;
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@ x %ld", @(_orderCellModel.price), (long)_orderCellModel.goodNum];
    _priceLabel.width = [NSString sizeWithText:_priceLabel.text font:_priceLabel.font].width + 1;
    _priceLabel.left = kScreenWidth-_priceLabel.width-20;
 
}

@end
