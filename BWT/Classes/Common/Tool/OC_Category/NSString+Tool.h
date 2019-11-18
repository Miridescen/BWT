//
//  NSString+Tool.h
//  BWT
//
//  Created by Miridescent on 2019/10/17.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(Tool)

+ (BOOL)isBlackString:(NSString *)string;
+ (BOOL)isMobilePhone:(NSString *)string;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
