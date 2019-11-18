
//
//  BWTStoreMenuCRV.m
//  BWT
//
//  Created by Miridescent on 2019/10/14.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTStoreMenuCRV.h"

#import "GoodsRecommendBrandModel.h"

@interface BWTStoreMenuCRV ()

@property (nonatomic, strong) NSMutableArray *menuBtnArr;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *btnBgView;
@property (nonatomic, strong) UIButton *otherBtn;
@end

@implementation BWTStoreMenuCRV
#define BtnBaseTag 1100

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuArr = [@[] mutableCopy];
        self.menuBtnArr = [@[] mutableCopy];
        [self addMenuView];
    }
    return self;
}

// 分类view
- (void)addMenuView{
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_bgImageView];
    
    
    _btnBgView = [[UIView alloc] initWithFrame:CGRectMake(14, 102, kScreenWidth-28, 200)];
    _btnBgView.backgroundColor = BWTWhiteColor;
    [self addSubview:_btnBgView];
    
//    CGFloat btnWidth = (kScreenWidth-56-24*3)/4;
    CGFloat jianju = (kScreenWidth-30-4*62)/4;
    
    _otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(3*(62+jianju)+jianju/2, 22+62+22, 62, 62)];
    _otherBtn.backgroundColor = BWTWhiteColor;
    [_otherBtn addTarget:self action:@selector(otherBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 40)];
    pic.image = [UIImage imageNamed:@"icon_other"];
    [_otherBtn addSubview:pic];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 62, 18)];
    title.backgroundColor = BWTClearColor;
    title.text = @"其他";
    title.textColor = BWTFontBlackColor;
    title.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    title.textAlignment = NSTextAlignmentCenter;
    [_otherBtn addSubview:title];
}
- (void)btnClick:(UIButton *)btn{

    if (self.menuBtnClickBlock) {
        self.menuBtnClickBlock(_menuArr[btn.tag-BtnBaseTag]);
    }
}

- (void)otherBtnClick:(UIButton *)btn{
    
    if (self.otherBtnClickBlock) {
        self.otherBtnClickBlock();
    }
}

- (void)setMenuArr:(NSArray<GoodsRecommendBrandModel *> *)menuArr{
    _menuArr = menuArr;
    
    if (_menuArr.count <= 3) {
        _btnBgView.height = 100;
        _btnBgView.top = 202;
    } else {
        _btnBgView.height = 200;
        _btnBgView.top = 102;
    }
    
    _btnBgView.hidden = _menuArr.count<=0 ? YES : NO;
    
    [_btnBgView removeAllSubviews];
    [_menuBtnArr removeAllObjects];
    
    NSInteger btnCount = _menuArr.count;
//    CGFloat btnWidth = (kScreenWidth-56-24*3)/4;
    CGFloat jianju = (kScreenWidth-30-4*62)/4;
    
    if (btnCount > 7) {
        btnCount = 7;
    }
    for (NSInteger i = 0; i < btnCount; i++ ) {

        GoodsRecommendBrandModel *brandModel = _menuArr[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 62)];
        btn.backgroundColor = BWTWhiteColor;
        btn.tag = BtnBaseTag+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 40)];
        [pic sd_setImageWithURL:[NSURL URLWithString:brandModel.iconUrl]];
        [btn addSubview:pic];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 62, 18)];
        title.backgroundColor = BWTClearColor;
        title.text = brandModel.value;
        title.textColor = BWTFontBlackColor;
        title.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        title.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:title];

 
        if (i < 4) {
            btn.top = 22;
            btn.left = i*(64+jianju)+jianju/2;
            
            CGFloat titleW = [NSString sizeWithText:title.text font:title.font].width;
            if (titleW > 62) {
                title.width = [NSString sizeWithText:title.text font:title.font].width;
                title.left = (62-title.width)/2;
            }
            
        } else {
            btn.top = 22+62+22;
            btn.left = i%4*(64+jianju)+jianju/2;
            
            CGFloat titleW = [NSString sizeWithText:title.text font:title.font].width;
            if (titleW > 62) {
                title.width = [NSString sizeWithText:title.text font:title.font].width;
                title.left = (62-title.width)/2;
            }
        }
        
        [_btnBgView addSubview:btn];
        [_menuBtnArr addObject:btn];
        
    }
    
    _otherBtn.frame = CGRectMake(btnCount%4*(64+jianju)+jianju/2, btnCount<4?22:22+62+22, 62, 62);
    [_btnBgView addSubview:_otherBtn];
    
}
- (void)setBgImageUrl:(NSString *)bgImageUrl{
    _bgImageUrl = bgImageUrl;
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:_bgImageUrl]];
}

@end
