//
//  GoodsCategoryModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/15.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsCategoryModel : NSObject
/*
{
    name = 美时美刻,
    modifyDate = 1566354097000,
    state = E,
    id = 24,
    iconUrl = https://statics.lianlianloan.com/system/documents/path/product/zudaola/bwtd/frontcategory/msmk-bg.jpg,
    level = 1,
    goodsCategoryIds = 103,104,105,
    goodsFrontCategorys = [
],
    createDate = 1566354097000,
    categoryType = BWTD_INDEX,
    pid = <null>
}
 */

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *goodsCategoryIds;
@property (nonatomic, copy) NSString *categoryType;


@end

NS_ASSUME_NONNULL_END
