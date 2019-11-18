//
//  MSBannerView.h
//  BWT
//
//  Created by Miridescent on 2019/10/16.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MSBannerViewDelegate <NSObject>

@optional
- (void)selectIndex:(NSInteger)index;

@end

@interface MSBannerView : UIView

@property (nonatomic , weak) id <MSBannerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame imgURLArray:(NSMutableArray *)imgURLArray placeholderImage:(UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
