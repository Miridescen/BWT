//
//  SKUButtonGroupView.h
//  BWT
//
//  Created by Miridescent on 2019/10/25.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class groupSkuAttributeMix;
@interface SKUButtonGroupView : UIView

- (instancetype)initWithFrame:(CGRect)frame groupSkuAttr:(groupSkuAttributeMix *)attr;

@property (nonatomic, copy) NSString *firstValue;

@property (nonatomic, copy) void(^BtnClickBlock)(NSString *skuName, NSString *skuValue, UIButton *btn);

@end

NS_ASSUME_NONNULL_END
