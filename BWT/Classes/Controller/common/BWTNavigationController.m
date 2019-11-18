//
//  BWTNavigationController.m
//  BWT
//
//  Created by Miridescent on 2019/10/12.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTNavigationController.h"

@interface BWTNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BWTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"img_topreturn"]];
    [self.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"img_topreturn"]];
    self.navigationBar.tintColor = RGBColor(142, 142, 142);
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
//        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 12, 18)];
//        //设置UIButton的图像
//        [backButton setImage:[UIImage imageNamed:@"img_topreturn"] forState:UIControlStateNormal];
//        //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
//        [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
//        //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//        //覆盖返回按键
//        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    viewController.navigationItem.backBarButtonItem = item;
    

    [super pushViewController:viewController animated:animated];
}

- (void)backItemClick{
    [self popViewControllerAnimated:YES];
}


@end
