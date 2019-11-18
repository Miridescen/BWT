//
//  BWTUserTool.h
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BWTUserModel;
@interface BWTUserTool : NSObject

+ (void)loginWithUserModel:(BWTUserModel *)model;
+ (BWTUserModel *)userModel;
+ (BOOL)isLogin;

+ (void)changeUserPhone:(NSString *)phone;

+ (NSString *)userToken;
+ (NSInteger)userId;

+ (void)logout;

+ (void)presentLoginVC; // 执行一系列是否要login判断

@end

NS_ASSUME_NONNULL_END
