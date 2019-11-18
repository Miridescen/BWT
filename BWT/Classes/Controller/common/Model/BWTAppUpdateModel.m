
//
//  BWTAppUpdateModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/30.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTAppUpdateModel.h"

@implementation BWTAppUpdateModel
- (NSString *)description
{
    return [NSObject yy_modelDescription];
}

+(NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"_id":@"id",
             @"newsVersion":@"newVersion"
             };
}
@end
