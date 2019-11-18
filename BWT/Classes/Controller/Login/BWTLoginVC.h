//
//  BWTLoginVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/21.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWTLoginVC : BWTBaseVC

@property (nonatomic, copy) void(^loginSuccessBlock)(void);

@end

NS_ASSUME_NONNULL_END
