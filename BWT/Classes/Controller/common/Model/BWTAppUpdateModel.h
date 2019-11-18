//
//  BWTAppUpdateModel.h
//  BWT
//
//  Created by Miridescent on 2019/10/30.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BWTAppUpdateModel : NSObject
@property (nonatomic, copy) NSString *newsVersion;
@property (nonatomic, copy) NSString *issueDate;
@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, copy) NSString *appDownloadUrl;
@property (nonatomic, assign) BOOL forceUpgrade;
@property (nonatomic, copy) NSString *upgradeDesc;
@property (nonatomic, assign) BOOL needUpgrade;
@property (nonatomic, copy) NSString *appPlatform;
@end

NS_ASSUME_NONNULL_END
