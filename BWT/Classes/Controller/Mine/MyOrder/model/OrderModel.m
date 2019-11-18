
//
//  OrderModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/23.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "OrderModel.h"
@implementation subOrderList
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
@implementation OrderModel
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
             @"subOrderList":[subOrderList class]
             };
}
@end
