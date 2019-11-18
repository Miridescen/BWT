//
//  BWTBuyNowOrderVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/26.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class GoodDetailModel;
@class goodsSkuVOS;
@class OrderCellModel;
@interface BWTBuyNowOrderVC : BWTBaseVC

@property (nonatomic, strong) OrderCellModel *cellModel;
@property (nonatomic, strong) GoodDetailModel *goodModel;
@property (nonatomic, strong) goodsSkuVOS *selectSku;
@property (nonatomic, assign) NSInteger selectNum;

@end

NS_ASSUME_NONNULL_END
