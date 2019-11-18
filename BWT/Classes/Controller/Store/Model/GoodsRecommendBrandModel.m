
//
//  GoodsRecommendBrandModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/15.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "GoodsRecommendBrandModel.h"

@implementation GoodsRecommendBrandModel

- (NSString *)description
{
    return [NSObject yy_modelDescription];
}

+(NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"_id":@"id"
             };
}

@end
