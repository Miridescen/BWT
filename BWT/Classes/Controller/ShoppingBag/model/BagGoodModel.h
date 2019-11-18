//
//  BagGoodModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/21.
//  Copyright © 2019 Miridescent. All rights reserved.
//

/*
 {
     id = 240,
     stockQuantity = 10,
     depositRate = 0,
     paymentCycleDesc = 一次性,
     putoutStatus = UP,
     itemCount = 1,
     skuState = E,
     standards = 黑色;35,
     title = Ariella 一字带凉鞋一字带凉鞋一字带凉鞋一字带凉鞋一字带凉鞋,
     durationDesc = 共-1个月,
     oneAmount = 48,
     goodsCategoryId = 103,
     orderId = 20191018170742572069,
     orderType = shoes,
     duration = -1M,
     paymentCycle = ALL,
     goodsImg = https://statics.lianlianloan.com/system/documents/path/develop/release/goods/GOODS_CAROUSEL_PICTURE_a40be7b7-78b3-4602-86c4-fe332e4c9d5e.png,
     goodsId = 429,
     itemId = 882
 }
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BagGoodModel : NSObject
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger stockQuantity;
@property (nonatomic, assign) NSInteger depositRate;
@property (nonatomic, copy) NSString *paymentCycleDesc;
@property (nonatomic, copy) NSString *putoutStatus;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, copy) NSString *skuState;
@property (nonatomic, copy) NSString *standards;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *durationDesc;
@property (nonatomic, assign) CGFloat oneAmount;
@property (nonatomic, assign) NSInteger goodsCategoryId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *paymentCycle;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger itemId;

@end

NS_ASSUME_NONNULL_END
