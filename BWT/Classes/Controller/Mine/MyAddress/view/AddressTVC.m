
//
//  AddressTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/22.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "AddressTVC.h"

#import "addressModel.h"

@interface AddressTVC ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation AddressTVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = BWTBackgroundGrayColor;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 150)];
    bgView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:bgView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 70, 22)];
    _nameLabel.text = @"王小姐";
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:_nameLabel];
    
    _phoneLabel = [[UILabel alloc] init];
    _phoneLabel.frame = CGRectMake(kScreenWidth-15-40-130, 10, 130, 22);
    _phoneLabel.text = @"18500978800";
    _phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    _phoneLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:_phoneLabel];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.frame = CGRectMake(15, VIEW_BY(_nameLabel)+10, kScreenWidth-40-30, 42);
    _addressLabel.text = @"浙江省 杭州市 西湖区 三墩镇金地自在城鹭影轩C区6栋1单元604";
    _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _addressLabel.numberOfLines = 0;
    _addressLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [bgView addSubview:_addressLabel];
    
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.frame = CGRectMake(15, 106, kScreenWidth-40-30, 1);
    lineLayer.backgroundColor = BWTBackgroundGrayColor.CGColor;
    [bgView.layer addSublayer:lineLayer];
    
    _defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _defaultBtn.frame = CGRectMake(15, 119, 90, 22);
    [_defaultBtn setImage:[UIImage imageNamed:@"img_select_off"]  forState:UIControlStateNormal];
    [_defaultBtn setImage:[UIImage imageNamed:@"img_select_on"]  forState:UIControlStateSelected];
    [_defaultBtn setTitle:@"默认地址" forState:UIControlStateNormal];
    [_defaultBtn setTitleColor:BWTFontBlackColor forState:UIControlStateNormal];
    _defaultBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _defaultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
     [_defaultBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,8,0,0)];
    [_defaultBtn addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_defaultBtn];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(kScreenWidth-15-40-40, 119, 40, 20);
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:BWTFontBlackColor forState:UIControlStateNormal];
    _editBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_editBtn];
   
}

- (void)defaultBtnClick:(UIButton *)btn{
    if (btn.selected) {
        return;
    } else {
        if (_defaultBtnBlock) {
            _defaultBtnBlock(_addressModel);
        }
    }
}

- (void)editBtnClick:(UIButton *)btn{
    if (_editBtnBlock) {
        _editBtnBlock(_addressModel);
    }
}

- (void)setAddressModel:(addressModel *)addressModel{
    _addressModel = addressModel;
    
    _nameLabel.text = _addressModel.name;
    CGSize nameLabelSize = [NSString sizeWithText:_addressModel.name font:BWTBaseFont(16)];
    _nameLabel.width = nameLabelSize.width;
    
    _phoneLabel.text = _addressModel.telephone;
    
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@", _addressModel.street, _addressModel.hourseNumber];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.minimumLineHeight = 20;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (20 - _addressLabel.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    _addressLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", _addressModel.street, _addressModel.hourseNumber] attributes:attributes];
    [_addressLabel sizeToFit];
    
    _defaultBtn.selected = [_addressModel.isDefault isEqualToString:@"t"] ? YES : NO;
    
}
@end
