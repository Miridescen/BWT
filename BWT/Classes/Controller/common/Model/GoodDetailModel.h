//
//  GoodDetailModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/17.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface goodsAttributeValues : NSObject
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *value;
@end

#pragma mark - groupSkuAttributeMix
@interface groupSkuAttributeMix : NSObject
@property (nonatomic, assign) CGFloat format;
@property (nonatomic, strong) NSArray<goodsAttributeValues *> *goodsAttributeValues;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@end

#pragma mark - goodsSpecAttributeKeyMixVOS
@interface goodsSpecAttributeKeyMixVOS : NSObject
@property (nonatomic, assign) CGFloat format;
@property (nonatomic, strong) NSArray<goodsAttributeValues *> *goodsAttributeValues;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@end

#pragma mark - goodsSkuVOS
@interface goodsSkuAttributeKeyMixVOS : NSObject
@property (nonatomic, strong) NSArray<goodsAttributeValues *> *goodsAttributeValues;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@end

@interface goodsSkuVOS : NSObject
@property (nonatomic, assign) CGFloat depositPrice;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, strong) NSArray<goodsSkuAttributeKeyMixVOS *> *goodsSkuAttributeKeyMixVOS;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) CGFloat skuPrice;
@property (nonatomic, assign) NSInteger stockQuantity;
@end

#pragma mark - goodsPictureVOS
@interface goodsAnnexInfoVO : NSObject
@property (nonatomic, copy) NSString *annexType;
@property (nonatomic, copy) NSString *annexUrl;
@property (nonatomic, assign) NSInteger _id;
@end

@interface goodsPictureVOS : NSObject
@property (nonatomic, assign) NSInteger annexInfoId;
@property (nonatomic, strong) goodsAnnexInfoVO *goodsAnnexInfoVO;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger level;
@end


#pragma mark - goodsMainPicture
@interface goodDetail_goodsMainPicture : NSObject
@property (nonatomic, copy) NSString *annexUrl;
@end


#pragma mark - GoodDetailModel
@interface GoodDetailModel : NSObject
@property (nonatomic, copy) NSString *accessory;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) CGFloat displayDepositPrice;
@property (nonatomic, assign) CGFloat displayPrice;
@property (nonatomic, assign) NSInteger goodsCategoryId;
@property (nonatomic, strong) goodDetail_goodsMainPicture *goodsMainPicture;
@property (nonatomic, strong) NSArray<goodsPictureVOS *> *goodsPictureVOS;
@property (nonatomic, strong) NSArray<goodsSkuVOS *> *goodsSkuVOS;
@property (nonatomic, strong) NSArray<goodsSpecAttributeKeyMixVOS *> *goodsSpecAttributeKeyMixVOS;
@property (nonatomic, strong) NSArray<groupSkuAttributeMix *> *groupSkuAttributeMix;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, copy) NSString *snapshotVersion;
@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
