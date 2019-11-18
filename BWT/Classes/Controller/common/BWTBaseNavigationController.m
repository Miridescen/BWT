

//
//  BWTBaseNavigationController.m
//  BWT
//
//  Created by Miridescent on 2019/10/31.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseNavigationController.h"

@interface BWTBaseNavigationController ()

@end

@implementation BWTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = NO;
    
    // 自定义返回图片(在返回按钮旁边) 这个效果由navigationBar控制
    [self.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"img_topreturn"]];
    [self.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"img_topreturn"]];
    self.navigationBar.tintColor = RGBColor(142, 142, 142);
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
//        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 12, 18)];
//        //设置UIButton的图像
//        [backButton setImage:[UIImage imageNamed:@"img_return"] forState:UIControlStateNormal];
//        //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
//        [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
//        //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
//        //覆盖返回按键
//        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
//    item.imageInsets = UIEdgeInsetsMake(0, 5, 0, -15);
//    
    viewController.navigationItem.backBarButtonItem = item;

    [super pushViewController:viewController animated:animated];
}
- (void)backItemClick{
    [self popViewControllerAnimated:YES];
}

@end
