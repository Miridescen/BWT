//
//  BWTOrderVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/21.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseVC.h"



NS_ASSUME_NONNULL_BEGIN
@class GoodDetailModel;
@class goodsSkuVOS;
@class OrderCellModel;
@interface BWTOrderVC : BWTBaseVC


@property (nonatomic, strong) NSArray <OrderCellModel *>*cellModelArr;
@property (nonatomic, strong) GoodDetailModel *goodModel;
@property (nonatomic, strong) goodsSkuVOS *selectSku;
@property (nonatomic, assign) NSInteger selectNum;

@end

NS_ASSUME_NONNULL_END
