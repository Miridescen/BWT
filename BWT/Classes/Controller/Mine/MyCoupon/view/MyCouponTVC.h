//
//  MyCouponTVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CouponModel;
typedef enum : NSUInteger {
    CouponTypeUnreceive,        // 未领取
    CouponTypeUseable,          // 可用
    CouponTypeUsed,             // 已用
    CouponTypeeExpired,         // 已失效
} CouponType;
@interface MyCouponTVC : UITableViewCell
@property (nonatomic, strong) CouponModel *couponModel;

@property (nonatomic, assign) CouponType couponCellType;

@property (nonatomic, copy) void(^useBtnBlock)(NSInteger couponID, CouponType couponType);
@end

NS_ASSUME_NONNULL_END
