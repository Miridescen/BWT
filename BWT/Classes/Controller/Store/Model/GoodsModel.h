//
//  GoodsModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/15.
//  Copyright © 2019 Miridescent. All rights reserved.
//
/*
{
    "id": 435,
    "goodsCategoryId": 103,
    "title": "test101401",
    "putoutStatus": "UP",
    "displayPrice": 1.00,
    "rentType": null,
    "rentTermUnit": "m",
    "displayDepositPrice": "2.00",
    "displayRentUnitPrice": 10.00,
    "createDate": 1571036100000,
    "modifyDate": 1571036150000,
    "goodsMainPicture": {
        "id": 915,
        "annexableId": 435,
        "annexableType": "GOODS",
        "annexableInnerCategory": "GOODS_CAROUSEL_PICTURE",
        "annexUrl": "https://statics.lianlianloan.com/system/documents/path/develop/release/goods/GOODS_CAROUSEL_PICTURE_820e5bc1-44b0-489e-afc7-5a6206b25368.png",
        "annexSize": 19285,
        "annexType": "jpg",
        "annexName": null,
        "createDate": 1571036093000,
        "modifyDate": 1571036150000,
        "state": "E"
    },
    "shopId": 33,
    "shopName": "生活会",
    "stockQuantity": 36
}
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface goodsMainPicture : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger annexableId;
@property (nonatomic, copy) NSString *annexableType;
@property (nonatomic, copy) NSString *annexableInnerCategory;
@property (nonatomic, copy) NSString *annexUrl;
@property (nonatomic, copy) NSString *annexSize;
@property (nonatomic, copy) NSString *annexType;
@property (nonatomic, copy) NSString *annexName;
@property (nonatomic, copy) NSString *state;

@end

@interface GoodsModel : NSObject
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger goodsCategoryId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *putoutStatus;
@property (nonatomic, assign) CGFloat displayPrice;
@property (nonatomic, copy) NSString *rentType;
@property (nonatomic, copy) NSString *rentTermUnit;
@property (nonatomic, assign) CGFloat displayDepositPrice;
@property (nonatomic, assign) CGFloat displayRentUnitPrice;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString *shopName;
@property (nonatomic, assign) NSInteger stockQuantity;
@property (nonatomic, strong) goodsMainPicture *goodsMainPicture;
@end

NS_ASSUME_NONNULL_END
