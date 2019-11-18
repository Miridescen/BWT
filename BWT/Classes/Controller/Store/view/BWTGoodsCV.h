//
//  BWTGoodsCV.h
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCategoryModel;
@class GoodsModel;
@class GoodsRecommendBrandModel;

NS_ASSUME_NONNULL_BEGIN

@interface BWTGoodsCV : UICollectionView

@property (nonatomic, copy) NSString *storeMenuCRVBgImageUrl;

- (void)loadDataWith:(GoodsCategoryModel *)categoryModel;

// coll点击回调
@property(nonatomic, copy) void(^cellSelectBlock)(GoodsModel *goodModel);
// 品牌列表点击回调
@property(nonatomic, copy) void(^brandSelectBlock)(GoodsRecommendBrandModel *brandModel, NSUInteger categoryID);
// 品牌列表上其他按钮点击回调
@property(nonatomic, copy) void(^brandOtherSelectBlock)(void);
@end

NS_ASSUME_NONNULL_END
