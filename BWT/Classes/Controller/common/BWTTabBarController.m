//
//  BWTTabBarController.m
//  BWT
//
//  Created by Miridescent on 2019/10/12.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTTabBarController.h"

#import "BWTNavigationController.h"

#import "BWTStoreTVC.h"
#import "BWTShopTVC.h"
#import "BWTMineTVC.h"

@interface BWTTabBarController ()

@end

@implementation BWTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewControllers];
    
    self.tabBar.backgroundColor = [UIColor redColor];
}

- (void)addViewControllers{
    
    BWTStoreTVC *storeVC = [[BWTStoreTVC alloc] init];
    storeVC.view.backgroundColor = [UIColor whiteColor];
    BWTNavigationController *storeNav = [[BWTNavigationController alloc] initWithRootViewController:storeVC];
    
    UITabBarItem *storeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"商城" image:[[UIImage imageNamed:@"icon_tabbar_scoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"icon_tabbar_scon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    storeNav.tabBarItem = storeTabBarItem;
    [storeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTGrayColor} forState:UIControlStateNormal];
    [storeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTMainColor} forState:UIControlStateSelected];
    
    BWTShopTVC *shopVC = [[BWTShopTVC alloc] init];
    storeVC.view.backgroundColor = [UIColor whiteColor];
    BWTNavigationController *shopNav = [[BWTNavigationController alloc] initWithRootViewController:shopVC];
    
    UITabBarItem *shopTabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物袋" image:[[UIImage imageNamed:@"icon_tabbar_buyoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"icon_tabbar_buyon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    shopNav.tabBarItem = shopTabBarItem;
    [shopNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTGrayColor} forState:UIControlStateNormal];
    [shopNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTMainColor} forState:UIControlStateSelected];
    
    BWTMineTVC *mineVC = [[BWTMineTVC alloc] init];
    mineVC.view.backgroundColor = [UIColor whiteColor];
    BWTNavigationController *mineNav = [[BWTNavigationController alloc] initWithRootViewController:mineVC];
    
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"icon_tabbar_myoff"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@"icon_tabbar_myon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    mineNav.tabBarItem = mineTabBarItem;
    [mineNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTGrayColor} forState:UIControlStateNormal];
    [mineNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: BWTMainColor} forState:UIControlStateSelected];
    
    [self addChildViewController:storeNav];
    [self addChildViewController:shopNav];
    [self addChildViewController:mineNav];
    
    
}

@end
