//
//  BWTStoreHeadView.m
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTStoreHeadView.h"

@implementation BWTStoreHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.titleArray = @[@"运动潮鞋", @"轻奢潮鞋", @"美时美刻", @"轻奢包袋"];
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
    NSInteger btnCount = _titleArray.count;
    CGFloat btnWidth = kScreenWidth/self.titleArray.count;
    for (NSInteger i = 0; i < btnCount; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, 40)];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexStringMore:@"#A29D9C"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexStringMore:@"#333333"] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        [self addSubview:button];
    }
}

- (void)btnDidClick:(UIButton *)btn{
    if (btn.selected) {
        return;
    } else {
        btn.selected = YES;
        NSLog(@"%@", btn.titleLabel.text);
    }
}

@end
