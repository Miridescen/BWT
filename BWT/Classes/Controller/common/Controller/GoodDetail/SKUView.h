//
//  SKUView.h
//  BWT
//
//  Created by Miridescent on 2019/10/25.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodDetailModel;
@class goodsSkuVOS;
@interface SKUView : UIView

@property (nonatomic, strong) GoodDetailModel *goodModel;

@property (nonatomic, copy) void(^sureBtnClickBlock)(goodsSkuVOS *selectedSKU, NSDictionary *standard, NSInteger selectNum);

@end

NS_ASSUME_NONNULL_END
