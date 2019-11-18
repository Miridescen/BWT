//
//  OrderTVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/23.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class OrderModel;
@class subOrderList;

@class subOrderListDetail;

typedef enum : NSUInteger {
    OrderCellTypeFinished,          // 已完成
    OrderCellTypeCanceled,          // 已取消
    OrderCellTypeWaitReceive,       // 带收货
    OrderCellTypeWaitDeliver,       // 待发货
    OrderCellTypeWaitPay,           // 代付款
} OrderCellType;

@interface subOrderTVC : UITableViewCell

@property (nonatomic, strong) subOrderList *subOrderList;
@property (nonatomic, strong) subOrderListDetail *detailSubOrder;

@end

@interface OrderTVC : UITableViewCell

@property (nonatomic, strong) OrderModel *orderModel;

@property (nonatomic, copy) void(^stateOneBtnBlock)(OrderCellType orderCellType);
@property (nonatomic, copy) void(^stateTwoBtnBlock)(OrderCellType orderCellType);

@property (nonatomic, copy) void(^subCellClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
