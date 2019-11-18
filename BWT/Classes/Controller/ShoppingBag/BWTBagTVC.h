//
//  BWTBagTVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/17.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    GoodNumAdd, // 增加物品数量
    GoodNumSub, // 减少物品数量
} GoodNumBtnType;

@class BagGoodModel;
@interface BWTBagTVC : UITableViewCell

@property (nonatomic, strong) BagGoodModel *goodModel;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, assign) CGFloat oneAmount;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) void(^selectBtnBlock)(BOOL isSelected, NSInteger itemCount, CGFloat totalPrice);
@property (nonatomic, copy) void(^goodNumBtnBlock)(BOOL isSelected, CGFloat goodPrice, GoodNumBtnType btnType, NSInteger itemCount);

@end

NS_ASSUME_NONNULL_END
