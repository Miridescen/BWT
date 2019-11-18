//
//  BWTSodeScanVC.h
//  BWT
//
//  Created by Miridescent on 2019/11/2.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BWTBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWTSodeScanVC : BWTBaseVC

@property (nonatomic, copy) void(^getCouponSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
