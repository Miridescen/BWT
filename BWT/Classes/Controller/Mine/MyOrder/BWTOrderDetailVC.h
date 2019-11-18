//
//  BWTOrderDetailVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/28.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OrderDetailVCTypeWaitPay,  // 待付款
    OrderDetailVCTypeWaitReceive, // 待收货
    OrderDetailVCTypeWaitDeliver, // 待发货
    OrderDetailVCTypeFinished,  // 已完成
    OrderDetailVCTypeCanceled,  // 已关闭
} OrderDetailVCType;

@interface BWTOrderDetailVC : BWTBaseVC

@property (nonatomic, assign) OrderDetailVCType orderDetailVCType;

@property (nonatomic, copy) NSString *orderID;

@end

NS_ASSUME_NONNULL_END
