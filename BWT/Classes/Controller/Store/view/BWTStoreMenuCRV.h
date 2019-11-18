//
//  BWTStoreMenuCRV.h
//  BWT
//
//  Created by Miridescent on 2019/10/14.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsRecommendBrandModel;

NS_ASSUME_NONNULL_BEGIN

@interface BWTStoreMenuCRV : UICollectionReusableView

@property(strong, nonatomic) NSArray <GoodsRecommendBrandModel *>*menuArr;
@property (nonatomic, copy) NSString *bgImageUrl;

@property(copy, nonatomic) void(^menuBtnClickBlock)(GoodsRecommendBrandModel *brandModel);
@property(copy, nonatomic) void(^otherBtnClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
