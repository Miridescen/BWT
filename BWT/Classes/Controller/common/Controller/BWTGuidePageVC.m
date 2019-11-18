
//
//  BWTGuidePageVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/30.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTGuidePageVC.h"
#import "BWTTabBarController.h"

@interface BWTGuidePageVC ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation BWTGuidePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(kScreenWidth * 4, 0);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    NSArray *imageViewNameArray = @[@"1-寻真1242-2688", @"1-问独1242-2688", @"1-志趣1242-2688", @"1-乐活1242-2688"];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:imageViewNameArray[i]];
        if (i == 3) {
            imageView.userInteractionEnabled = YES;
            [self initWithImageView:imageView];
            
        }
        [mainScrollView addSubview:imageView];
        
    }
    [self.view addSubview:mainScrollView];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth-60)/2, kScreenHeight-(kTabBarHeight-49)-32, 60, 6)];
    pageControl.numberOfPages = 4;
    pageControl.pageIndicatorTintColor = BWTWhiteColor;
    pageControl.currentPageIndicatorTintColor = BWTMainColor;
//    pageControl.backgroundColor = [UIColor redColor];
//    pageControl.currentPage = 0;
    self.pageControl = pageControl;
    
    [self.view addSubview:pageControl];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = (scrollView.contentOffset.x + kScreenWidth / 2 ) / kScreenWidth;
    self.pageControl.currentPage = currentPage;
}

- (void)initWithImageView:(UIImageView *)imageView
{
    
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-211)/2, kScreenHeight-(kTabBarHeight-49)-58-40, 211, 40)];

    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startButton setBackgroundColor:[UIColor colorWithHexString:@"#FF6600"]];
    [startButton addTarget:self action:@selector(startapp:) forControlEvents:UIControlEventTouchUpInside];
    startButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    startButton.layer.cornerRadius = 20.0;
    startButton.layer.masksToBounds = YES;
    
    [imageView addSubview:startButton];
    
}
- (void)startapp:(UIButton *)button
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[BWTTabBarController alloc] init];
}

@end
