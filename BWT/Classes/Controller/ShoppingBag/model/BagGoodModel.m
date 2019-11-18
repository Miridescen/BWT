
//
//  BagGoodModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/21.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BagGoodModel.h"

@implementation BagGoodModel
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
