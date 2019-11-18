//
//  UIView+MSFoundation.h
//  狗脑发热iOS
//
//  Created by 824810056 on 2018/10/11.
//  Copyright © 2018年 Miridescent. All rights reserved.
//

//get the left top origin's x,y of a view
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)

//get the width size of the view:width,height
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)

//get the right bottom origin's x,y of a view
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height)

#import <UIKit/UIKit.h>

@interface UIView (MSFoundation)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;

- (void)removeAllSubviews;
- (UIViewController *)viewController;
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

- (UIView*)subViewOfClassName:(NSString*)className;

+ (void)addCornerWithView:(UIView *)aView type:(UIRectCorner)aCorners size:(CGSize)aSize;

@end
