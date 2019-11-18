//
//  OrderCellModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/26.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderCellModel : NSObject  // orderCell的数据model

@property (nonatomic, assign) NSInteger skuID;
@property (nonatomic, copy) NSString *snapshotVersion;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger goodNum;
@property (nonatomic, copy) NSString *standard;


@property (nonatomic, copy) NSString *orderID;



@end

NS_ASSUME_NONNULL_END
