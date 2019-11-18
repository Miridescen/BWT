
//
//  OrderDetailModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/28.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "OrderDetailModel.h"
@implementation orderApply
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
@implementation orderAddress
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
@implementation subOrderListDetail
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
@implementation OrderDetailModel
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
             @"subOrderList":[subOrderListDetail class],
             @"orderAddress":[orderAddress class],
             @"orderApply":[orderApply class]
             };
}
@end
