//
//  BWTTabBarController.m
//  BWT
//
//  Created by Miridescent on 2019/10/12.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTTabBarController.h"

#import "BWTNavigationController.h"
#import "HomeVC.h"

@interface BWTTabBarController ()

@end

@implementation BWTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addViewControllers];
}

- (void)addViewControllers{
    
    HomeVC *homeVC = [[HomeVC alloc] init];
    homeVC.view.backgroundColor = [UIColor whiteColor];
    BWTNavigationController *HomeNav = [[BWTNavigationController alloc] initWithRootViewController:homeVC];
    
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"他店商城" image:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:@""] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    HomeNav.tabBarItem = homeTabBarItem;
    [HomeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]} forState:UIControlStateNormal];
    [HomeNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor yellowColor]} forState:UIControlStateSelected];
    
    [self addChildViewController:HomeNav];
    
    
}

@end
