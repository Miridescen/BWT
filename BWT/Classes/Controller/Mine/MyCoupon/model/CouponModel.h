//
//  CouponModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//
/*
 {
     userId = 234588,
     validDate = 2019/09/02,
     couponCategory = 103,
     id = 241,
     couponAmount = 20,
     expireDate = 2019/10/02,
     couponName = 潮鞋满减券,
     couponDesc = 满200可用,
     useState = expired,
     couponId = 24
 }
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *validDate;
@property (nonatomic, assign) NSInteger couponCategory;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) CGFloat couponAmount;
@property (nonatomic, copy) NSString *expireDate;
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *couponDesc;
@property (nonatomic, copy) NSString *useState;
@property (nonatomic, assign) NSInteger couponId;
@end

NS_ASSUME_NONNULL_END
