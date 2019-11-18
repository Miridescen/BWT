
//
//  SKUButtonGroupView.m
//  BWT
//
//  Created by Miridescent on 2019/10/25.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "SKUButtonGroupView.h"
#import "GoodDetailModel.h"
@interface SKUButtonGroupView ()

@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *skuBtnArr;

@property (nonatomic, strong) groupSkuAttributeMix *groupSkuAttr;

@end

@implementation SKUButtonGroupView
#define BtnBaseTag 1200
- (instancetype)initWithFrame:(CGRect)frame groupSkuAttr:(groupSkuAttributeMix *)attr{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.titleArr = [@[] mutableCopy];
        self.skuBtnArr = [@[] mutableCopy];
        self.groupSkuAttr = attr;
        NSArray *skuDetailArr = attr.goodsAttributeValues;
        for (NSInteger i = 0; i < skuDetailArr.count; i++) {
            goodsAttributeValues *arrValue = skuDetailArr[i];
            [self.titleArr addObject:arrValue.value];
        }
        [self setupSubBtn];
    }
    
    return self;
}

- (void)setupSubBtn{
    
    CGFloat left = 0;
    for (NSInteger i = 0; i < self.titleArr.count; i++) {
        CGFloat btnTitleWidth = [NSString sizeWithText:self.titleArr[i] font:BWTBaseFont(14)].width+26;
        if (btnTitleWidth < 54) {
            btnTitleWidth = 54;
        }
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(left, 0, btnTitleWidth, 34)];
        btn.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1/1.0];
        btn.titleLabel.font = BWTBaseFont(14);
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:BWTFontBlackColor forState:UIControlStateNormal];
        [btn setTitleColor:BWTMainColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(skuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = BtnBaseTag+i;
        btn.layer.borderWidth = 1;
        [self addSubview:btn];
        if (i == 0 ) {
            btn.selected = YES;
            self.firstValue = btn.titleLabel.text;
        }
        if (btn.selected) {
            btn.layer.borderColor = BWTMainColor.CGColor;
        } else {
            btn.layer.borderColor = BWTClearColor.CGColor;
        }
        [self.skuBtnArr addObject:btn];
        
        left += btnTitleWidth+10;
    }
}
- (void)skuBtnClick:(UIButton *)btn{
    if (btn.selected) {
        return;
    }
    for (UIButton *btn1 in self.skuBtnArr) {
        if (btn1 == btn) {
            btn1.selected = YES;
        } else {
            btn1.selected = NO;
        }
        
        if (btn1.selected) {
            btn1.layer.borderColor = BWTMainColor.CGColor;
        } else {
            btn1.layer.borderColor = BWTClearColor.CGColor;
        }
    }
    if (btn.selected) {
        btn.layer.borderColor = BWTMainColor.CGColor;
    } else {
        btn.layer.borderColor = BWTClearColor.CGColor;
    }
    if (self.BtnClickBlock) {
        self.BtnClickBlock(self.groupSkuAttr.name, btn.titleLabel.text, btn);
    }
}

@end
