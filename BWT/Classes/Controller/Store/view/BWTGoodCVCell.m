//
//  BWTGoodCVCell.m
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTGoodCVCell.h"

#import "GoodsModel.h"

@interface BWTGoodCVCell ()

@property (nonatomic, strong) UIView *sellOutView;

@property (nonatomic, strong) UIImageView *goodImg;
@property (nonatomic, strong) UILabel *goodName;
@property (nonatomic, strong) UILabel *realPrice;
@property (nonatomic, strong) UILabel *showPrice;

@end

@implementation BWTGoodCVCell

#define cellWidth (kScreenWidth-3)/2
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = BWTWhiteColor;
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews{

    _goodImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth)];
//    _goodImg.backgroundColor = BWTGrayColor;
    _goodImg.userInteractionEnabled = YES;
    [self.contentView addSubview:_goodImg];
    
    _goodName = [[UILabel alloc] initWithFrame:CGRectMake(15, VIEW_BY(_goodImg)+17, cellWidth-22, 40)];
    _goodName.textAlignment = NSTextAlignmentLeft;
    _goodName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];;
    _goodName.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _goodName.numberOfLines = 2;
    [self.contentView addSubview:_goodName];

    UILabel *loglabel = [[UILabel alloc] init];
    loglabel.frame = CGRectMake(16, VIEW_BY(_goodName)+11, 8, 18);
    loglabel.text = @"¥";
    loglabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    loglabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    [self.contentView addSubview:loglabel];
    
    _realPrice = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(loglabel)+2, VIEW_BY(_goodName)+8, 60, 22)];
    _realPrice.textAlignment = NSTextAlignmentLeft;
    _realPrice.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _realPrice.textColor = BWTFontBlackColor;
    _realPrice.numberOfLines = 1;
    [self.contentView addSubview:_realPrice];
    
    _showPrice = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(_realPrice)+12, VIEW_BY(_goodName)+10, 60, 20)];
    _showPrice.textAlignment = NSTextAlignmentLeft;
    _showPrice.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _showPrice.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    _showPrice.numberOfLines = 1;

    [self.contentView addSubview:_showPrice];
    
    _sellOutView = [[UIView alloc] init];
    _sellOutView.frame = self.bounds;
    _sellOutView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5/1.0];
    [self.contentView addSubview:_sellOutView];
    
    UIView *sellOutBgview = [[UIView alloc] init];
    sellOutBgview.frame = CGRectMake(cellWidth-42, 6, 36, 24);
    sellOutBgview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1/1.0];
    sellOutBgview.layer.borderWidth = 1;
    sellOutBgview.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
    [_sellOutView addSubview:sellOutBgview];
    
    UILabel *sellOutlabel = [[UILabel alloc] init];
    sellOutlabel.frame = CGRectMake(6, 4, 24, 17);
    sellOutlabel.text = @"售磬";
    sellOutlabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    sellOutlabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [sellOutBgview addSubview:sellOutlabel];
}

- (void)setGoodModel:(GoodsModel *)goodModel{
    
    _goodModel = goodModel;
    
    [_goodImg sd_setImageWithURL:[NSURL URLWithString:_goodModel.goodsMainPicture.annexUrl]];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _goodName.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _goodName.attributedText = [[NSAttributedString alloc] initWithString:_goodModel.title attributes:attributes];
//    [_goodName sizeToFit];
    [_goodName topAlignment];
    
    _realPrice.text = [NSString stringWithFormat:@"%@", @(_goodModel.displayDepositPrice)];
    CGSize realSize = [NSString sizeWithText:_realPrice.text font:_realPrice.font];
    _realPrice.width = realSize.width;
    
    CGSize showSize = [NSString sizeWithText:[NSString stringWithFormat:@"¥%@", @(_goodModel.displayPrice)] font:_showPrice.font];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", @(_goodModel.displayPrice)] attributes:attribtDic];
    _showPrice.attributedText = attribtStr;
    _showPrice.left = VIEW_BX(_realPrice)+10;
    _showPrice.width = showSize.width;
    
    _sellOutView.hidden = _goodModel.stockQuantity <= 0 ? NO : YES;
    
}

@end
