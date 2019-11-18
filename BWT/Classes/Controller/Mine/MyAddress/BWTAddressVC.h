//
//  BWTAddressVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/22.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseVC.h"

NS_ASSUME_NONNULL_BEGIN
@class addressModel;
@interface BWTAddressVC : BWTBaseVC

@property (nonatomic, copy) void(^selectRowBlock)(addressModel *address);

@end

NS_ASSUME_NONNULL_END
