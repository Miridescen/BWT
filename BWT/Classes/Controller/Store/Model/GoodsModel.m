
//
//  GoodsModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/15.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "GoodsModel.h"

@implementation goodsMainPicture

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

@implementation GoodsModel

- (NSString *)description
{
    return [NSObject yy_modelDescription];
}

+(NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"_id":@"id"
             };
}

+(NSDictionary *)modelContainerPropertyGenericClass{
    return @{
             @"goodsMainPicture":[goodsMainPicture class]
             };
}

@end
