
//
//  GoodDetailModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/17.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "GoodDetailModel.h"
@implementation goodsAttributeValues
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
@implementation groupSkuAttributeMix
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
             @"goodsAttributeValues":[goodsAttributeValues class],
             };
}
@end
@implementation goodsSpecAttributeKeyMixVOS
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
             @"goodsAttributeValues":[goodsAttributeValues class],
             };
}
@end
@implementation goodsSkuAttributeKeyMixVOS
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
             @"goodsAttributeValues":[goodsAttributeValues class],
             };
}
@end
@implementation goodsSkuVOS
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
             @"goodsSkuAttributeKeyMixVOS":[goodsSkuAttributeKeyMixVOS class],
             };
}
@end
@implementation goodsAnnexInfoVO
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

@implementation goodsPictureVOS
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
             @"goodsAnnexInfoVO":[goodsAnnexInfoVO class],
             };
}
@end

@implementation goodDetail_goodsMainPicture
- (NSString *)description
{
    return [NSObject yy_modelDescription];
}
@end

@implementation GoodDetailModel
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
             @"goodsMainPicture":[goodDetail_goodsMainPicture class],
             @"goodsPictureVOS":[goodsPictureVOS class],
             @"goodsSkuVOS":[goodsSkuVOS class],
             @"goodsSpecAttributeKeyMixVOS":[goodsSpecAttributeKeyMixVOS class],
             @"groupSkuAttributeMix":[groupSkuAttributeMix class]
             };
}
@end
