//
//  BWTTabBarController.m
//  BWT
//
//  Created by Miridescent on 2019/10/12.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTTabBarController.h"

#import "BWTNavigationController.h"
#import "BWTBaseNavigationController.h"

#import "BWTStoreVC.h"
#import "BWTBagVC.h"
#import "BWTMineTVC.h"

#import "BWTLoginVC.h"

@interface BWTTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BWTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    self.delegate = self;
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [self addViewControllers];
    
}

- (void)addViewControllers{
    
    BWTStoreVC *storeVC = [[BWTStoreVC alloc] init];
    storeVC.view.backgroundColor = [UIColor whiteColor];
    BWTNavigationController *storeNav = [[BWTNavigationController alloc] initWithRootViewController:storeVC];
    
    UITabBarItem *storeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城" image:[[UIImage imageNamed:@"icon_tabbar_scoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"icon_tabbar_scon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    storeNav.tabBarItem = storeTabBarItem;
    [storeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTFontBlackColor} forState:UIControlStateNormal];
    [storeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTFontBlackColor} forState:UIControlStateSelected];
    
    BWTBagVC *shopVC = [[BWTBagVC alloc] init];
    storeVC.view.backgroundColor = [UIColor whiteColor];
    BWTBaseNavigationController *shopNav = [[BWTBaseNavigationController alloc] initWithRootViewController:shopVC];
    
    UITabBarItem *shopTabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物袋" image:[[UIImage imageNamed:@"icon_tabbar_buyoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"icon_tabbar_buyon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    shopNav.tabBarItem = shopTabBarItem;
    [shopNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTFontBlackColor} forState:UIControlStateNormal];
    [shopNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTFontBlackColor} forState:UIControlStateSelected];
    
    BWTMineTVC *mineVC = [[BWTMineTVC alloc] init];
    storeVC.view.backgroundColor = [UIColor whiteColor];
    BWTBaseNavigationController *mineNav = [[BWTBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"icon_tabbar_myoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"icon_tabbar_myon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    mineNav.tabBarItem = mineTabBarItem;
    [mineNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTFontBlackColor} forState:UIControlStateNormal];
    [mineNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTFontBlackColor} forState:UIControlStateSelected];
    
    [self addChildViewController:storeNav];
    [self addChildViewController:shopNav];
    [self addChildViewController:mineNav];
    
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if ([[viewController.childViewControllers objectAtIndex:0] isKindOfClass:[BWTBagVC class]]) {
        if (!BWTIsLogin) {
//            [BWTUserTool presentLoginVC];
            BWTLoginVC *login = [[BWTLoginVC alloc] init];

            [[UINavigationController currentNC] pushViewController:login animated:YES];
            return NO;
        }
    }
//    if ([[viewController.childViewControllers objectAtIndex:0] isKindOfClass:[BWTMineTVC class]]) {
//        if (!BWTIsLogin) {
//            [BWTUserTool presentLoginVC];
//            return NO;
//        }
//    }
    return YES;
}

@end
