//
//  BWTTextView.h
//  BWT
//
//  Created by Miridescent on 2019/10/22.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BWTTextView : UITextView

@property (nonatomic,copy)NSString *placeholder;
@property (nonatomic,strong) UIColor * placeholderColor;

@end

NS_ASSUME_NONNULL_END
