//
//  BWTStoreHeadView.m
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//



#import "BWTStoreHeadView.h"

#import "GoodsCategoryModel.h"

@interface BWTStoreHeadView ()

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, strong) UIScrollView *bgScrollView;

@end

@implementation BWTStoreHeadView

#define BtnBaseTag 1000

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.menuArr = [@[] mutableCopy];
        self.btnArr = [@[] mutableCopy];
        self.backgroundColor = BWTWhiteColor;
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        self.bgScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.bgScrollView];
        [self loadData];
    }
    return self;
    
}
- (void)loadData{
    
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:Goods_category_list parameters:@{@"categoryType":@"BWTD_INDEX"} success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        self.menuArr = [NSArray yy_modelArrayWithClass:[GoodsCategoryModel class] json:responseObject];
    } fail:^(NSError *error) {
        
    }];
}

- (void)btnDidClick:(UIButton *)btn{
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    for (UIButton *btn1 in _btnArr) {
        if (btn1.tag != btn.tag) {
            btn1.selected = NO;
        }
    }
    if (self.btnClickBlock) {
        self.btnClickBlock(_menuArr[btn.tag-BtnBaseTag]);
    }
}

- (void)setMenuArr:(NSArray *)menuArr{
    
    _menuArr = menuArr;
    NSInteger btnCount = _menuArr.count;
    
    CGFloat left = 15;
    

    for (NSInteger i = 0; i < btnCount; i++) {
        
        GoodsCategoryModel *categoryModel = _menuArr[i];
        CGFloat btnWidth = [NSString sizeWithText:categoryModel.name font:[UIFont fontWithName:@"PingFangSC-Medium" size:15]].width;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(left, 9, btnWidth, 21)];
        [button setTitle:categoryModel.name forState:UIControlStateNormal];
        [button setTitleColor: [UIColor colorWithRed:162/255.0 green:157/255.0 blue:156/255.0 alpha:1/1.0]
 forState:UIControlStateNormal];
        [button setTitleColor:BWTFontBlackColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [button addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = BtnBaseTag+i;
        [_bgScrollView addSubview:button];
        [_btnArr addObject:button];
        if (i == 0) {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
        left += btnWidth+30;
    }
    
    _bgScrollView.contentSize = CGSizeMake(left-10, 0);
    
}

@end
