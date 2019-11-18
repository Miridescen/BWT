//
//  BWTGoodsBaseCV.h
//  BWT
//
//  Created by Miridescent on 2019/10/18.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsModel;

@interface BWTGoodsBaseCV : UICollectionView



@property(nonatomic, copy) void(^cellSelectBlock)(GoodsModel *goodModel);

// 根据ID加载数据
- (void)loadDataWithGoodsFrontCategoryId:(NSInteger)goodsFrontCategoryId goodsAttributeValues:(NSInteger)goodsAttributeValues;
- (void)loadDataWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
