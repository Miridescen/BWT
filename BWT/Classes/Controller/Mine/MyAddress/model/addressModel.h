//
//  addressModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/22.
//  Copyright © 2019 Miridescent. All rights reserved.
//
/*
 {
     id = 291,
     hourseNumber = 我去饿,
     province = ,
     isDefault = t,
     provinceCode = <null>,
     street = 浙江省杭州市,
     cityCode = <null>,
     userId = 234588,
     districtCode = <null>,
     longitude = 120.21201,
     city = ,
     payFreight = <null>,
     district = ,
     hasEvevator = t,
     telephone = 13588829102,
     floor = 1,
     name = 真实的,
     latitude = 30.2084
 }
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface addressModel : NSObject
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *hourseNumber;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *districtCode;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *payFreight;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *hasEvevator;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *floor;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@end

NS_ASSUME_NONNULL_END
