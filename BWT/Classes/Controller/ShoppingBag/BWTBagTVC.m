
//
//  BWTBagTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/17.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBagTVC.h"
#import "BagGoodModel.h"

@interface BWTBagTVC ()


@property (nonatomic, strong) UIImageView *goodImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *standardLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *numGroupView;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UILabel *goodNumLabel;
@property (nonatomic, strong) UIButton *addBtn;

//@property (nonatomic, assign) CGFloat goodPrice;

@end

@implementation BWTBagTVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = BWTBackgroundGrayColor;
        _totalPrice = 0.0;
        _itemCount = 0;
        _isSelected = YES;
        
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BWTBackgroundGrayColor;
        _totalPrice = 0.0;
        _itemCount = 0;
        _isSelected = YES;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    bgView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:bgView];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(20, 60, 20, 20);
    [_selectBtn setImage:[UIImage imageNamed:@"img_select_off"]  forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"img_select_on"]  forState:UIControlStateSelected];
    _selectBtn.selected = NO;
    _selectBtn.hitEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
//    _selectBtn.hitScale = 3;
    [_selectBtn addTarget:self action:@selector(selectBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_selectBtn];
    
    _goodImg = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_BX(_selectBtn)+14, 30, 80, 80)];
//    _goodImg.backgroundColor = BWTBackgroundGrayColor;
//    _goodImg.layer.borderWidth = 1;
//    _goodImg.layer.borderColor = [UIColor colorWithHexString:@"#010101"].CGColor;
    _goodImg.layer.borderWidth = 1;
    _goodImg.layer.borderColor = [UIColor colorWithHexString:@"#F6F6F6"].CGColor;
    [bgView addSubview:_goodImg];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(_goodImg)+12, 30, kScreenWidth-VIEW_BX(_goodImg)-12-20, 40)];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 2;
//    _titleLabel.backgroundColor = [UIColor redColor];
    _titleLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
    [bgView addSubview:_titleLabel];
    
    _standardLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(_goodImg)+12, VIEW_BY(_titleLabel)+12, kScreenWidth-VIEW_BX(_goodImg)-12-20, 14)];
    _standardLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _standardLabel.textAlignment = NSTextAlignmentLeft;
    _standardLabel.textColor = BWTFontBlackColor;
    [bgView addSubview:_standardLabel];
    
    UILabel *loglabel = [[UILabel alloc] init];
    loglabel.frame = CGRectMake(VIEW_BX(_goodImg)+13, VIEW_BY(_standardLabel)+14, 8, 18);
    loglabel.text = @"¥";
    loglabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
    loglabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:loglabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(loglabel)+2, VIEW_BY(_standardLabel)+12, kScreenWidth-250, 20)];
    _priceLabel.text = @"0.00";
    _priceLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.textColor = BWTFontBlackColor;
    [bgView addSubview:_priceLabel];
    
    _numGroupView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-100, VIEW_BY(_standardLabel)+12, 80, 20)];
    _numGroupView.backgroundColor = BWTWhiteColor;
    [bgView addSubview:_numGroupView];
    
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subBtn.frame = CGRectMake(0, 0, 20, 20);
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"img_substract_on"] forState:UIControlStateNormal];
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"img_substract_off"] forState:UIControlStateDisabled];
    [_subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_numGroupView addSubview:_subBtn];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(_numGroupView.width-20, 0, 20, 20);
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"img_add_on"] forState:UIControlStateNormal];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"img_add_off"] forState:UIControlStateDisabled];
    [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_numGroupView addSubview:_addBtn];
    
    _goodNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _numGroupView.width-40, 20)];
    _goodNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _goodNumLabel.textAlignment = NSTextAlignmentCenter;
    _goodNumLabel.textColor =  [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
    
    [_numGroupView addSubview:_goodNumLabel];
    
    
    
}

- (void)setGoodModel:(BagGoodModel *)goodModel{
    _goodModel = goodModel;
    
    _oneAmount = _goodModel.oneAmount;
    
    _itemCount = _goodModel.itemCount;
    if (_itemCount <= 1) {
        _subBtn.enabled = NO;
    }
    
    _totalPrice = _goodModel.oneAmount*_goodModel.itemCount;
    
    [_goodImg sd_setImageWithURL:[NSURL URLWithString:_goodModel.goodsImg]];
    
    _titleLabel.text = _goodModel.title;
//    [_titleLabel topAlignment];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _titleLabel.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_goodModel.title attributes:attributes];
    [_titleLabel sizeToFit];
    
    _goodNumLabel.text = [NSString stringWithFormat:@"%ld", _itemCount];
    
    _standardLabel.text = _goodModel.standards;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@", @(_oneAmount)];
    
    
    
}

- (void)subBtnClick:(UIButton *)btn{
    
    NSInteger goodNum = [_goodNumLabel.text integerValue];
    if (goodNum <= 1) {
        btn.enabled = NO;
        return;
    } else {
        goodNum -= 1;
        self.itemCount = goodNum;
        if (_goodNumBtnBlock) {
            _goodNumBtnBlock(_selectBtn.selected, _goodModel.oneAmount, GoodNumSub, self.itemCount);
        }
        if (goodNum <= 1) {
            btn.enabled = NO;
        }
    }
    
}

- (void)addBtnClick:(UIButton *)btn{
    
    NSInteger goodNum = [_goodNumLabel.text integerValue];

    if (goodNum + 1 > _goodModel.stockQuantity) {
        [MSTipView showWithMessage:@"已达最大库存"];
        return;
    }

    goodNum += 1;
    self.itemCount = goodNum;
    if (_goodNumBtnBlock) {
        _goodNumBtnBlock(_selectBtn.selected, _goodModel.oneAmount, GoodNumAdd, self.itemCount);
    }
    if (goodNum > 1) {
        _subBtn.enabled = YES;
    }
   
}

- (void)selectBtnDidClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    _isSelected = btn.selected;
    if (_selectBtnBlock) {
        _selectBtnBlock(_selectBtn.selected, _itemCount, _totalPrice);
    }
}

- (void)setItemCount:(NSInteger)itemCount{
    _itemCount = itemCount;
    _totalPrice = _goodModel.oneAmount*_itemCount;
    _goodNumLabel.text = [NSString stringWithFormat:@"%ld", _itemCount];
//    _priceLabel.text = [NSString stringWithFormat:@"%.2f", _totalPrice];
}



- (void)setOneAmount:(CGFloat)oneAmount{
    _oneAmount = oneAmount;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    _selectBtn.selected = _isSelected;
}

@end
