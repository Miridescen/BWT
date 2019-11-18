
//
//  CommonConstant.h
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#ifndef CommonConstant_h
#define CommonConstant_h

// environment
#ifdef __cplusplus
#define BWT_EXTERN_C_BEGIN  extern "C" {
#define BWT_EXTERN_C_END  }
#else
#define BWT_EXTERN_C_BEGIN
#define BWT_EXTERN_C_END
#endif

BWT_EXTERN_C_BEGIN

/**
 是否打印
 */
#ifdef DEBUG
#define BWTLog(FORMAT, ...) fprintf(stderr,"file__%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#define BWTLog(...)
#else
#define BWTLog(...)
#endif
/**
 弱引用
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif
/**
 强引用
 */
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//判断设备类型

#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//屏幕值
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kStatusBarHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 44.0 : 20.0)
#define kNavigationBarHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)
#define kTabBarHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 83.0 : 49.0)
#define kBottomMargin ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 34.0 : 0.0

//font
#define BWTFontName @"PingFangSC-Regular"
#define BWTBaseFont(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]

//color
#define BWTClearColor [UIColor clearColor]
#define BWTRedColor [UIColor redColor]
#define BWTMainColor [UIColor colorWithRed:251/255.0 green:78/255.0 blue:9/255.0 alpha:1]
#define BWTGrayColor [UIColor colorWithRed:145/255.0 green:139/255.0 blue:138/255.0 alpha:1]
#define BWTBackgroundGrayColor [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]
#define BWTWhiteColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define BWTFontBlackColor [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1]
#define BWTFontGrayColor [UIColor colorWithRed:145/255.0 green:139/255.0 blue:138/255.0 alpha:1]

#define RGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// 用户信息
#define BWTUserID [BWTUserTool userId]
#define BWTUsertoken [BWTUserTool userToken]
#define BWTIsLogin [BWTUserTool isLogin]

// THIRD
//客服
#define BWTMeiyiAPPKEY  @"8812c09f46e63bc70e405f4f8e32bce9"
#define BWTMeiyiGroupID  @"d0532d426a09f3a2c003f47826f33f99"
// 微信
#define weixinAPPKEY  @"wx43a7d99d1a5ca92a"
//支付宝
#define alipayAPPKEY  @"2019102168482809"


// 通知
#define BWTUserLogoutNotifiction @"BWTUserLogoutNotifiction" // 用户退出通知
#define BWTUserLoginNotifiction @"BWTUserLoginNotifiction"   // 用户登录通知
#define BWTPresentLoginVCNotifiction @"BWTPresentLoginVCNotifiction" // 弹出登录页通知
#define BWTWeixinLoginNotifiction @"BWTWeixinLoginNotifiction" // 从微信拿到信息通知
#define BWTWeixinPaySuccessNotifiction @"BWTWeixinPaySuccessNotifiction" // 微信支付成功通知
#define BWTWeixinPayFailNotifiction @"BWTWeixinPayFailNotifiction" // 微信支付失败通知

#define BWTAliPaySuccessNotifiction @"BWTAliPaySuccessNotifiction" // 支付宝支付成功
#define BWTAliPayFailNotifiction @"BWTAliPayFailNotifiction" // 支付宝支付失败
// 弹框倒计时 key
#define BWTpushVersionTip @"BWTpushVersionTip"  // 用于检测7天内是否弹升级提示框
#define BWTPushUserAggree @"BWTPushUserAggree"  // 用于检测7天内是否弹用户协议

// 更新
#define BWTItuenssURL @"123123123123" // 更新跳转ituness的连接
// 客服电话
#define BWTServerPhone [NSString stringWithFormat:@"tel:057186702291"] // 客服电话
#endif /* CommonConstant_h */
