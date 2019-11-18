
//
//  BWTBrandGoodsVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/18.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBrandGoodsVC.h"

#import "BWTGoodsBaseCV.h"
#import "BWTGoodDetailVC.h"

#import "GoodsModel.h"

@interface BWTBrandGoodsVC ()

@property (nonatomic, strong) BWTGoodsBaseCV *brandGoodsCV;

@end

@implementation BWTBrandGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.brandGoodsCV = [[BWTGoodsBaseCV alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
    [self.brandGoodsCV loadDataWithGoodsFrontCategoryId:self.categoryID goodsAttributeValues:self.brandID];
    
    @weakify(self);
    self.brandGoodsCV.cellSelectBlock = ^(GoodsModel * _Nonnull goodModel) {
        @strongify(self);
        if (!self) return;
        BWTGoodDetailVC *detailVC = [[BWTGoodDetailVC alloc] init];
        detailVC.goodID = goodModel._id;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    [self.view addSubview:_brandGoodsCV];
    
}

@end
