//
//  OrderDetailModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/28.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface orderApply : NSObject

@property (nonatomic, copy) NSString *overdueDay;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) CGFloat totalRent;
@property (nonatomic, copy) NSString *serviceFee;
@property (nonatomic, copy) NSString *orderState;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, copy) NSString *receivedDate;
@property (nonatomic, copy) NSString *rentType;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) CGFloat depositFree;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *paymentCycleName;
@property (nonatomic, copy) NSString *orderStateName;
@property (nonatomic, copy) NSString *paymentCycle;
@property (nonatomic, copy) NSString *deliverDate;
@property (nonatomic, assign) CGFloat couponAmount;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, assign) CGFloat unitRent;
@property (nonatomic, copy) NSString *depositReduce;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, copy) NSString *payDate;
@property (nonatomic, copy) NSString *depositPayable;
@property (nonatomic, copy) NSString *distributeDate;
@property (nonatomic, assign) CGFloat actualRent;
@property (nonatomic, copy) NSString *deliveryType;
@property (nonatomic, copy) NSString *useRemainingDay;
@property (nonatomic, copy) NSString *currentState;
@property (nonatomic, copy) NSString *payOff;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *applyDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *returnDate;

@end
@interface orderAddress : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *receiver;

@end
@interface subOrderListDetail : NSObject

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *standards;
@property (nonatomic, assign) CGFloat itemPrice;

@end
@interface OrderDetailModel : NSObject


@property (nonatomic, copy) NSString *orderHistory;
@property (nonatomic, strong) orderAddress *orderAddress;
@property (nonatomic, copy) NSString *orderExpress;
@property (nonatomic, copy) NSString *orderRenew;
@property (nonatomic, strong) NSArray<subOrderListDetail *> *subOrderList;
@property (nonatomic, copy) NSString *orderIds;
@property (nonatomic, copy) NSString *itemAttributes;
@property (nonatomic, copy) NSString *orderBuyout;
@property (nonatomic, strong) orderApply *orderApply;

@end

NS_ASSUME_NONNULL_END
