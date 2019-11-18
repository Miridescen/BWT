
//
//  MyCouponTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "MyCouponTVC.h"

#import "CouponModel.h"

@interface MyCouponTVC ()
@property (nonatomic, strong) UILabel *logoLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *expireDateLabel;
@property (nonatomic, strong) UILabel *couponDescLabel;
@property (nonatomic, strong) UIButton *useBtn;


@end

@implementation MyCouponTVC

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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 120)];
    bgView.backgroundColor = BWTWhiteColor;
    [self.contentView addSubview:bgView];
    
    _logoLabel = [[UILabel alloc] init];
    _logoLabel.frame = CGRectMake(15, 54, 11, 25);
    _logoLabel.text = @"¥";
    _logoLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    _logoLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:_logoLabel];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.frame = CGRectMake(26, 35, 39, 47);
    _amountLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:40];
    _amountLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:_amountLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(104.0/375*kScreenWidth, 0, 1, 120)];
    [bgView addSubview:lineView];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(0, CGRectGetHeight(lineView.frame)/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:[UIColor colorWithHexString:@"#CCCCCC"].CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,0, CGRectGetHeight(lineView.frame));
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
    

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(VIEW_BX(lineView)+20, 22, kScreenWidth-20-76-VIEW_BX(lineView)+20, 24);
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    _nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bgView addSubview:_nameLabel];

    _expireDateLabel = [[UILabel alloc] init];
    _expireDateLabel.frame = CGRectMake(VIEW_BX(lineView)+20, VIEW_BY(_nameLabel)+4, kScreenWidth-20-76-VIEW_BX(lineView)+20, 20);
    _expireDateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _expireDateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [bgView addSubview:_expireDateLabel];

    _couponDescLabel = [[UILabel alloc] init];
    _couponDescLabel.frame = CGRectMake(VIEW_BX(lineView)+20, VIEW_BY(_expireDateLabel)+4, kScreenWidth-20-76-VIEW_BX(lineView)+20, 20);
    _couponDescLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _couponDescLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
    [bgView addSubview:_couponDescLabel];

    _useBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-76, 45, 76, 30)];

    [_useBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _useBtn.layer.cornerRadius = 15;
    [_useBtn addTarget:self action:@selector(useBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _useBtn.titleLabel.font = BWTBaseFont(14);
    [bgView addSubview:_useBtn];

    
    
}
- (void)useBtnClick:(UIButton *)btn{
    
    if (_useBtnBlock) {
        _useBtnBlock(_couponModel.couponId, _couponCellType);
    }   
}

- (void)setCouponModel:(CouponModel *)couponModel{
    _couponModel = couponModel;
    
    if ([_couponModel.useState isEqualToString:@"unreceive"]) {
        _couponCellType = CouponTypeUnreceive;
    } else if ([_couponModel.useState isEqualToString:@"useable"]) {
        _couponCellType = CouponTypeUseable;
    } else if ([_couponModel.useState isEqualToString:@"used"]) {
        _couponCellType = CouponTypeUsed;
    } else if ([_couponModel.useState isEqualToString:@"expired"]) {
        _couponCellType = CouponTypeeExpired;
    }
    
    switch (_couponCellType) {
        case CouponTypeUnreceive:
            [_useBtn setTitle:@"领取" forState:UIControlStateNormal];
            _useBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
            break;
        case CouponTypeUseable:
            _logoLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
            _amountLabel.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
            [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
            _useBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
            break;
        case CouponTypeUsed:
            _logoLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            _amountLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            _expireDateLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            _couponDescLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            [_useBtn setTitle:@"已使用" forState:UIControlStateNormal];
            _useBtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            break;
        case CouponTypeeExpired:
            _logoLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            _amountLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            _expireDateLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            _couponDescLabel.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            [_useBtn setTitle:@"已过期" forState:UIControlStateNormal];
            _useBtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0];
            break;
            
        default:
            break;
    }
    
    
    
    _amountLabel.text = [NSString stringWithFormat:@"%.0f", _couponModel.couponAmount];
    _amountLabel.width = [NSString sizeWithText:_amountLabel.text font:[UIFont fontWithName:@"DINAlternate-Bold" size:40]].width;
    _logoLabel.left = (104.0/375*kScreenWidth-11-4-_amountLabel.width)/2;
    _amountLabel.left = VIEW_BX(_logoLabel)+4;
    _nameLabel.text = _couponModel.couponName;
    _expireDateLabel.text = [NSString stringWithFormat:@"有效期至 %@", _couponModel.expireDate];
    _couponDescLabel.text = _couponModel.couponDesc;
}

@end
