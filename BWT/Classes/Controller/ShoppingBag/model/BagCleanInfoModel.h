//
//  BagCleanInfoModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/27.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BagCleanInfoModel : NSObject
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger stockQuantity;
@property (nonatomic, copy) NSString *paymentCycle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, copy) NSString *snapshotVersion;
@property (nonatomic, copy) NSString *postage;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, assign) CGFloat totalRent;
@property (nonatomic, assign) CGFloat depositPayable;
@property (nonatomic, assign) CGFloat depositReduce;
@property (nonatomic, copy) NSString *standards;
@property (nonatomic, copy) NSString *paymentCycleDesc;
@property (nonatomic, assign) NSInteger depositRate;
@property (nonatomic, copy) NSString *durationDesc;
@property (nonatomic, assign) CGFloat firstAmount;
@property (nonatomic, assign) NSInteger depositReal;
@property (nonatomic, assign) CGFloat rentUnitPrice;
@property (nonatomic, copy) NSString *orderId;
@end

NS_ASSUME_NONNULL_END
