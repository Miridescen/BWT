
//
//  SKUView.m
//  BWT
//
//  Created by Miridescent on 2019/10/25.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "SKUView.h"

#import "GoodDetailModel.h"
#import "SKUButtonGroupView.h"

@interface SKUView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *googImg;
@property (nonatomic, strong) UILabel *goodTitle;
@property (nonatomic, strong) UILabel *goodPrice;
@property (nonatomic, strong) UIButton *closeBtn;


@property (nonatomic, strong) UITableView *SKUTableView;

@property (nonatomic, strong) UILabel *skuNameLabel;
@property (nonatomic, strong) UIView *skuDetailView;

@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *numGroupView;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UILabel *goodNumLabel;
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) NSArray *SKUAttrArr; // SKU分类类数组
@property (nonatomic, strong) NSArray *SKUArr;  // SKU组合数组

@property (nonatomic, strong) NSMutableDictionary *selectSkuAttrDic; // 勾选的sku组合
@property (nonatomic, strong)  goodsSkuVOS *selectedGoodSKU; // 被选中的sku

@property (nonatomic, assign) NSInteger selectNum; // 选中的数量


@end
@implementation SKUView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBAColor(100, 100, 100, 0.5);
        self.SKUArr = [@[] mutableCopy];
        self.SKUAttrArr = [@[] mutableCopy];
        self.selectSkuAttrDic = [[NSMutableDictionary alloc] init];
        self.selectNum = 1;
        [self sutupSubView];
    }
    return self;
}
- (void)setGoodModel:(GoodDetailModel *)goodModel{
    _goodModel = goodModel;
    
    BWTLog(@"%@", _goodModel.title);
 
    _SKUArr = goodModel.goodsSkuVOS;
    _SKUAttrArr = goodModel.groupSkuAttributeMix;
    
    self.bgView.height = 132 + _SKUAttrArr.count*74 + 85 + kTabBarHeight + 10;
    self.bgView.top = self.height-self.bgView.height;
    
    [UIView addCornerWithView:_bgView type:UIRectCornerTopLeft|UIRectCornerTopRight size:CGSizeMake(5, 5)];
    _SKUTableView.height = _SKUAttrArr.count*74;
    
    self.footView.top = 132 + _SKUAttrArr.count*74;
    
    [_googImg sd_setImageWithURL:[NSURL URLWithString:goodModel.goodsMainPicture.annexUrl]];
    _goodTitle.text = goodModel.title;
    _goodTitle.textColor = [UIColor colorWithHexString:@"#010101"];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _goodTitle.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _goodTitle.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", goodModel.title] attributes:attributes];
    [_goodTitle sizeToFit];
    
    _goodPrice.text = [NSString stringWithFormat:@"%@", @(goodModel.displayDepositPrice)];
 
}
- (void)closeBtnClick:(UIButton *)btn{
    [self removeFromSuperview];
}
- (void)subBtnClick:(UIButton *)btn{
    
    if (self.selectNum > 1) {
        self.selectNum--;
        self.goodNumLabel.text = [NSString stringWithFormat:@"%ld", (long)self.selectNum];
    }
    if (self.selectNum <= 1) {
        btn.enabled = NO;
    }
}
- (void)addBtnClick:(UIButton *)btn{
    
    for (goodsSkuVOS *skuVOS in self.SKUArr) {  // 查询哪个SKU是选中的SKU
        NSArray *goodsSkuAttributeKeyMixVOSArr = skuVOS.goodsSkuAttributeKeyMixVOS;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (goodsSkuAttributeKeyMixVOS *goodsSkuAttributeKeyMixVOS in goodsSkuAttributeKeyMixVOSArr) {
            goodsAttributeValues *goodsAttributeValues1 = [[goodsAttributeValues alloc] init];
            if (goodsSkuAttributeKeyMixVOS.goodsAttributeValues.count > 0) {
                goodsAttributeValues1 = goodsSkuAttributeKeyMixVOS.goodsAttributeValues[0];
            }
            NSString *value = goodsAttributeValues1.value;
            NSString *name = goodsSkuAttributeKeyMixVOS.name;
            [dic setObject:value forKey:name];
        }
        
        if ([self.selectSkuAttrDic isEqual:dic]) {
            self.selectedGoodSKU = skuVOS;
        }
    }
    if (self.selectedGoodSKU.stockQuantity < self.selectNum + 1) {
        [MSTipView showWithMessage:@"此商品库存不足"];
        return;
    }
    
    self.selectNum++;
    self.goodNumLabel.text = [NSString stringWithFormat:@"%ld", (long)self.selectNum];
    
    if (self.selectNum > 1) {
        self.subBtn.enabled = YES;
    }
}
- (void)sureBtnClick:(UIButton *)btn{
    
    if (self.selectNum <= 0) {
        [MSTipView showWithMessage:@"此商品库存不足"];
        return;
    }
    
    for (goodsSkuVOS *skuVOS in self.SKUArr) {  // 查询哪个SKU是选中的SKU
        NSArray *goodsSkuAttributeKeyMixVOSArr = skuVOS.goodsSkuAttributeKeyMixVOS;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        for (goodsSkuAttributeKeyMixVOS *goodsSkuAttributeKeyMixVOS in goodsSkuAttributeKeyMixVOSArr) {
            goodsAttributeValues *goodsAttributeValues1 = [[goodsAttributeValues alloc] init];
            if (goodsSkuAttributeKeyMixVOS.goodsAttributeValues.count > 0) {
                goodsAttributeValues1 = goodsSkuAttributeKeyMixVOS.goodsAttributeValues[0];
            }
            NSString *value = goodsAttributeValues1.value;
            NSString *name = goodsSkuAttributeKeyMixVOS.name;
            [dic setObject:value forKey:name];
        }
        
        if ([self.selectSkuAttrDic isEqual:dic]) {
            self.selectedGoodSKU = skuVOS;
        }
    }
    if (self.selectedGoodSKU.stockQuantity < self.selectNum) {
        [MSTipView showWithMessage:@"此商品库存不足"];
        return;
    }
    if (self.sureBtnClickBlock) {
        
        self.sureBtnClickBlock(self.selectedGoodSKU, self.selectSkuAttrDic, self.selectNum);
    }
    [self removeFromSuperview];
    
}

- (void)sutupSubView{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-400, kScreenWidth, 400)];
    _bgView.backgroundColor = BWTWhiteColor;

    [_bgView addSubview:self.headView];
    //-------------
    _SKUTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, 160)];
    _SKUTableView.delegate = self;
    _SKUTableView.dataSource = self;
    _SKUTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _SKUTableView.bounces = NO;
    _SKUTableView.showsVerticalScrollIndicator = NO;
    _SKUTableView.showsHorizontalScrollIndicator = NO;
    [_bgView addSubview:_SKUTableView];
    
    [_bgView addSubview:self.footView];
    [self addSubview:_bgView];
    
}
- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTabBarHeight+85 + 10)];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 60, 20)];
        _numLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
        _numLabel.text = @"购买数量";
        [_footView addSubview:_numLabel];
        
        _numGroupView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-20-101, 25, 101, 28)];
        _numGroupView.backgroundColor = BWTWhiteColor;
        [_footView addSubview:_numGroupView];
        
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _subBtn.frame = CGRectMake(0, 0, 28, 28);
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"img_substract_on"] forState:UIControlStateNormal];
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"img_substract_off"] forState:UIControlStateDisabled];
        _subBtn.enabled = NO;
        [_subBtn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numGroupView addSubview:_subBtn];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(_numGroupView.width-28, 0, 28, 28);
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"img_add_on"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"img_add_off"] forState:UIControlStateDisabled];
        [_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_numGroupView addSubview:_addBtn];
        
        _goodNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 45, 28)];
        _goodNumLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:20];
        _goodNumLabel.textAlignment = NSTextAlignmentCenter;
        _goodNumLabel.textColor = BWTFontBlackColor;
        _goodNumLabel.text = @"1";
        [_numGroupView addSubview:_goodNumLabel];
        
        [_footView addSubview:_numGroupView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, kScreenWidth, 1)];
        lineView.backgroundColor = BWTBackgroundGrayColor;
        [_footView addSubview:lineView];
 
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 93, kScreenWidth-40, 45)];
        _sureBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 5;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:_sureBtn];
        
    }
    
    return _footView;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 132)];
        
        _googImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 80, 80)];
        _googImg.backgroundColor = BWTBackgroundGrayColor;
        _googImg.layer.borderWidth = 1;
        _googImg.layer.borderColor = BWTBackgroundGrayColor.CGColor;
        [_headView addSubview:_googImg];
        
        _goodTitle = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(_googImg)+12, 30, kScreenWidth-20-VIEW_BX(_googImg)-12, 47)];
        _goodTitle.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _goodTitle.textAlignment = NSTextAlignmentLeft;
        _goodTitle.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];
        _goodTitle.numberOfLines = 0;
        [_headView addSubview:_goodTitle];
        
        UILabel *lgolabel = [[UILabel alloc] init];
        lgolabel.frame = CGRectMake(VIEW_BX(_googImg)+13, VIEW_BY(_goodTitle)+14, 8, 18);
        lgolabel.text = @"¥";
        lgolabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
        lgolabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        [_headView addSubview:lgolabel];
        
        _goodPrice = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_BX(lgolabel)+2, VIEW_BY(_goodTitle)+11, kScreenWidth-20-VIEW_BX(lgolabel)-2, 21)];
        _goodPrice.text = @"¥0.00";
        _goodPrice.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
        _goodPrice.textAlignment = NSTextAlignmentLeft;
        _goodPrice.textColor = BWTFontBlackColor;
        [_headView addSubview:_goodPrice];
        
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-29-9, 9, 20, 20)];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"img_buyclose"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_closeBtn];
    }
    
    return _headView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.SKUAttrArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    groupSkuAttributeMix *skuAtt = self.SKUAttrArr[indexPath.row];
    
    _skuNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 30, 20)];
    _skuNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];;
    _skuNameLabel.textAlignment = NSTextAlignmentLeft;
    _skuNameLabel.textColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1/1.0];;
    _skuNameLabel.text = skuAtt.name;
    _skuNameLabel.width = [NSString sizeWithText:_skuNameLabel.text font:_skuNameLabel.font].width;
    [cell addSubview:_skuNameLabel];

    SKUButtonGroupView *btnGroupVIew = [[SKUButtonGroupView alloc] initWithFrame:CGRectMake(20, 40, kScreenWidth-40, 34) groupSkuAttr:skuAtt];
    [self.selectSkuAttrDic setObject:btnGroupVIew.firstValue forKey:skuAtt.name];
    btnGroupVIew.BtnClickBlock = ^(NSString * _Nonnull skuName, NSString * _Nonnull skuValue, UIButton * _Nonnull btn) {
        
        [self.selectSkuAttrDic setObject:skuValue forKey:skuName];
        
        for (goodsSkuVOS *skuVOS in self.SKUArr) {  // 查询哪个SKU是选中的SKU
            NSArray *goodsSkuAttributeKeyMixVOSArr = skuVOS.goodsSkuAttributeKeyMixVOS;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (goodsSkuAttributeKeyMixVOS *goodsSkuAttributeKeyMixVOS in goodsSkuAttributeKeyMixVOSArr) {
                goodsAttributeValues *goodsAttributeValues1 = [[goodsAttributeValues alloc] init];
                if (goodsSkuAttributeKeyMixVOS.goodsAttributeValues.count > 0) {
                    goodsAttributeValues1 = goodsSkuAttributeKeyMixVOS.goodsAttributeValues[0];
                }
                NSString *value = goodsAttributeValues1.value;
                NSString *name = goodsSkuAttributeKeyMixVOS.name;
                [dic setObject:value forKey:name];
            }
            
            if ([self.selectSkuAttrDic isEqual:dic]) {
                self.selectedGoodSKU = skuVOS;
            }
        }
        if (self.selectedGoodSKU.stockQuantity == 0) {
            self.selectNum = 0;
            self.goodNumLabel.text = @"0";
            self.subBtn.enabled = NO;
            self.addBtn.enabled = NO;
        } else {
            self.selectNum = 1;
            self.goodNumLabel.text = @"1";
            self.subBtn.enabled = NO;
            self.addBtn.enabled = YES;
        }
    };
 
    if (self.selectSkuAttrDic.count == self.SKUAttrArr.count) {
        for (goodsSkuVOS *skuVOS in self.SKUArr) {  // 查询哪个SKU是选中的SKU
            NSArray *goodsSkuAttributeKeyMixVOSArr = skuVOS.goodsSkuAttributeKeyMixVOS;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (goodsSkuAttributeKeyMixVOS *goodsSkuAttributeKeyMixVOS in goodsSkuAttributeKeyMixVOSArr) {
                goodsAttributeValues *goodsAttributeValues1 = [[goodsAttributeValues alloc] init];
                if (goodsSkuAttributeKeyMixVOS.goodsAttributeValues.count > 0) {
                    goodsAttributeValues1 = goodsSkuAttributeKeyMixVOS.goodsAttributeValues[0];
                }
                NSString *value = goodsAttributeValues1.value;
                NSString *name = goodsSkuAttributeKeyMixVOS.name;
                [dic setObject:value forKey:name];
            }
            
            if ([self.selectSkuAttrDic isEqual:dic]) {
                self.selectedGoodSKU = skuVOS;
            }
        }
        if (self.selectedGoodSKU.stockQuantity == 0) {
            self.selectNum = 0;
            self.goodNumLabel.text = @"0";
            self.subBtn.enabled = NO;
            self.addBtn.enabled = NO;
        }
    }
    
    [cell addSubview:btnGroupVIew];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

@end
