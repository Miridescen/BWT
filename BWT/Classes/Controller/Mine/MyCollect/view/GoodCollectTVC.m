
//
//  GoodCollectTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "GoodCollectTVC.h"
#import "GoodCollectModel.h"
@interface GoodCollectTVC ()

@property (nonatomic, strong) UIImageView *goodImgView;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation GoodCollectTVC
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BWTBackgroundGrayColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        
    }
    return self;
}


- (void)setupSubviews{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    bgView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:bgView];
    
    _goodImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 80, 80)];
    _goodImgView.layer.borderWidth = 1;
    _goodImgView.layer.borderColor = [UIColor colorWithHexString:@"#F6F6F6"].CGColor;
    [bgView addSubview:_goodImgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 31, kScreenWidth-132, 47)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
    _titleLabel.numberOfLines = 0;
//    [_titleLabel topAlignment];

    [bgView addSubview:_titleLabel];
    
    UILabel *discountPriceLogo = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(_goodImgView)+13, VIEW_BY(_titleLabel)+12, 54, 20)];
    discountPriceLogo.textColor = RGBColor(251, 93, 24);
    discountPriceLogo.font = [UIFont fontWithName:@"PingFang SC" size:14];
    discountPriceLogo.textAlignment = NSTextAlignmentCenter;
    discountPriceLogo.numberOfLines = 1;
    discountPriceLogo.text = @"折扣价";
    discountPriceLogo.layer.borderWidth = 1;
    discountPriceLogo.layer.borderColor = [RGBColor(251, 93, 24) CGColor];
    discountPriceLogo.layer.cornerRadius = 2;
    discountPriceLogo.layer.masksToBounds = YES;
    [bgView addSubview:discountPriceLogo];
    
    UILabel *loglabel = [[UILabel alloc] init];
    loglabel.frame = CGRectMake(VIEW_BX(discountPriceLogo)+12, VIEW_BY(_titleLabel)+14, 8, 18);
    loglabel.text = @"¥";
    loglabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    loglabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:loglabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(loglabel)+2, 90, kScreenWidth-VIEW_BX(loglabel)-2-20, 20)];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _priceLabel.textColor = BWTFontBlackColor;
    [bgView addSubview:_priceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 139, kScreenWidth, 1)];
    lineView.backgroundColor = BWTBackgroundGrayColor;
    [bgView addSubview:lineView];
    
}

- (void)setCollectModel:(GoodCollectModel *)collectModel{
    _collectModel = collectModel;
    
    [_goodImgView sd_setImageWithURL:[NSURL URLWithString:_collectModel.annexUrl]];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _titleLabel.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_collectModel.title attributes:attributes];
//    [_titleLabel topAlignment];
//    _titleLabel.text = _collectModel.title;
    [_titleLabel sizeToFit];

    _priceLabel.text = [NSString stringWithFormat:@"%@", @(_collectModel.displayDepositPrice)];
    
}


@end
