//
//  BWTCanUseCouponVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/26.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class CouponModel;
@interface BWTCanUseCouponVC : BWTBaseVC

@property (nonatomic, assign) NSInteger category;
@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy) void(^couponUseBlock)(CouponModel *couponModel);

@end

NS_ASSUME_NONNULL_END
