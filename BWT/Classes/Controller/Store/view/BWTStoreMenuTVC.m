//
//  BWTStoreMenuTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTStoreMenuTVC.h"

@implementation BWTStoreMenuTVC

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 352);
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"img_bannerbg"];
    bgImageView.backgroundColor = BWTMainColor;
    bgImageView.userInteractionEnabled = NO;
    [self.contentView addSubview:bgImageView];
    
}

@end
