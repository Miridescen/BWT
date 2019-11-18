//
//  BWTUserModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

/*
 mobile = 17610392293,
 userId = 234618,
 appletUnid = <null>,
 appletGlobalId = <null>,
 headPortrait = https://statics.lianlianloan.com/production/statics/zudaola/images/defphoto.png,
 token = GAL/0t4GQx1DxuKVb0l/Q3Psc3sTQ04PYadmH1eRwbE=,
 nickName = a8097M23z1G
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BWTUserModel : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger appletUnid;
@property (nonatomic, assign) NSInteger appletGlobalId;
@property (nonatomic, copy) NSString *headPortrait;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userToken;
@end

NS_ASSUME_NONNULL_END
