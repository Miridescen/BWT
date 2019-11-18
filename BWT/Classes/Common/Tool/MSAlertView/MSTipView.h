//
//  MSTipView.h
//  BWT
//
//  Created by Miridescent on 2019/10/15.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSTipView : UIView

// 显示时间，默认是3s，当超过10个字的时候，showTime是每个字0.3s
@property(nonatomic, assign) CGFloat showTime;

// 是否显示背景蒙版效果，默认不显示
@property(nonatomic, assign) BOOL showBackgroundView;

// 距离父View顶部的距离，默认是黄金分割比
@property (nonatomic, assign) CGFloat posY;


- (id)initWithView:(UIView *)view message:(NSString *)message;
- (id)initWithView:(UIView *)view title:(NSString *)title message:(NSString *)message;

- (id)initWithWindow:(UIWindow *)window message:(NSString *)message;
- (id)initWithWindow:(UIWindow *)window title:(NSString *)title message:(NSString *)message;

+ (void)showWithMessage:(NSString *)message;

- (void)show;

- (void)dismiss;
- (void)dismiss:(BOOL)animation;
- (void)dismiss:(BOOL)animation callback:(SEL)sel;


@end

NS_ASSUME_NONNULL_END
