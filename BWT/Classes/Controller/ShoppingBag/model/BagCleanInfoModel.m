
//
//  BagCleanInfoModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/27.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BagCleanInfoModel.h"

@implementation BagCleanInfoModel
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
