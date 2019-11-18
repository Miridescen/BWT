//
//  OrderModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/23.
//  Copyright © 2019 Miridescent. All rights reserved.
//
/*
 {
   overdueDay=<null>,
   couponAmount=60,
   totalAmount=1090,
   itemCount=2,
   subOrderList=[
     {
       standards=红色;35,
       title=test101201;宝宝test1,
       orderId=20191017144350549284,
       itemPrice=1000,
       goodsImg=https: //statics.lianlianloan.com/system/documents/path/develop/release/goods/GOODS_CAROUSEL_PICTURE_f1d9f9fc-4b27-485d-9ba5-a6b6050d80d8.png,
       itemCount=1
     },
     {
       standards=乳白色,
       title=宝宝test1,
       orderId=20191017144356253610,
       itemPrice=150,
       goodsImg=https: //statics.lianlianloan.com/system/documents/path/develop/release/goods/GOODS_CAROUSEL_PICTURE_e605a40a-085a-403f-a691-1c5126ec8f99.png,
       itemCount=1
     }
   ],
   orderIds=20191017144350549284,
   20191017144356253610,
   endDate=<null>,
   title=test101201;宝宝test1,
   useRemainingDay=<null>,
   standards=<null>,
   orderId=20191017144412437168,
   orderState=finish,
   startDate=<null>,
   duration=-1M,
   goodsImg=<null>,
   orderStateName=已完成,
   rentType=<null>
 }
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface subOrderList : NSObject

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *standards;
@property (nonatomic, assign) CGFloat itemPrice;

@end
@interface OrderModel : NSObject


@property (nonatomic, copy) NSString *overdueDay;
@property (nonatomic, assign) CGFloat couponAmount;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) CGFloat itemCount;
@property (nonatomic, strong) NSArray<subOrderList *> *subOrderList;
@property (nonatomic, copy) NSString *orderIds;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *useRemainingDay;
@property (nonatomic, copy) NSString *standards;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderState;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *goodsImg;
@property (nonatomic, copy) NSString *orderStateName;
@property (nonatomic, copy) NSString *rentType;

@end

NS_ASSUME_NONNULL_END
