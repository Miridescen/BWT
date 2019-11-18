//
//  AddressTVC.h
//  BWT
//
//  Created by Miridescent on 2019/10/22.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class addressModel;
@interface AddressTVC : UITableViewCell

@property (nonatomic, strong) addressModel *addressModel;

@property (nonatomic, strong) UIButton *defaultBtn;

@property (nonatomic, copy) void(^defaultBtnBlock)(addressModel *addressModel);
@property (nonatomic, copy) void(^editBtnBlock)(addressModel *addressModel);
@end

NS_ASSUME_NONNULL_END
