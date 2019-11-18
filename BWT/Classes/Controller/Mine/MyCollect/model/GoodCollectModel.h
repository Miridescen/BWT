//
//  GoodCollectModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//
/*
 {
     displayDepositPrice = 48.00,
     title = Ariella 一字带凉鞋一字带凉鞋一字带凉鞋一字带凉鞋一字带凉鞋,
     goodsId = 429,
     goodsCategoryId = 103,
     annexUrl = https://statics.lianlianloan.com/system/documents/path/develop/release/goods/GOODS_CAROUSEL_PICTURE_a40be7b7-78b3-4602-86c4-fe332e4c9d5e.png
 }
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodCollectModel : NSObject
@property (nonatomic, copy) NSString *annexUrl;
@property (nonatomic, assign) NSInteger goodsCategoryId;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat displayDepositPrice;
@end

NS_ASSUME_NONNULL_END
