
//
//  BWTUserModel.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTUserModel.h"

@implementation BWTUserModel
- (NSString *)description
{
    return [NSObject yy_modelDescription];
}

+(NSDictionary *)modelCustomPropertyMapper{
    return @{
             @"userToken":@"token"
             };
}
@end
