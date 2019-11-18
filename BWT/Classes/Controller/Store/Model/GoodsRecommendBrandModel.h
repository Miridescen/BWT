//
//  GoodsRecommendBrandModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/15.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsRecommendBrandModel : NSObject

/*
 {
     attachUrl = <null>,
     customValueText = <null>,
     id = 331,
     iconUrl = http://www.wincan365.com/asset/image/home_icon_lj.png,
     level = 44,
     goodsAttributeKeyId = 2,
     value = Adidas,
     createDate = 1566617731000,
     customValueId = <null>,
     modifyDate = 1566617731000,
     state = E
 }
 */

@property (nonatomic, copy) NSString *attachUrl;
@property (nonatomic, copy) NSString *customValueText;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger goodsAttributeKeyId;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *state;

@end

NS_ASSUME_NONNULL_END
