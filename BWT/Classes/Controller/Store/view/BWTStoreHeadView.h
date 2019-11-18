//
//  BWTStoreHeadView.h
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsCategoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface BWTStoreHeadView : UIView

@property(nonatomic, strong) NSArray *menuArr;

@property(copy, nonatomic) void(^btnClickBlock)(GoodsCategoryModel *categoryModel);

@end

NS_ASSUME_NONNULL_END
