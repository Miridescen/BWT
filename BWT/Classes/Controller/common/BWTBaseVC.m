
//
//  BWTBaseVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/14.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseVC.h"

@interface BWTBaseVC ()<UIGestureRecognizerDelegate>

@end

@implementation BWTBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BWTBackgroundGrayColor;
    
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    //2.创建滑动手势，taregt设置interactivePopGestureRecognizer的target，所以当界面滑动的时候就会自动调用target的action方法。
//    //handleNavigationTransition是私有类_UINavigationInteractiveTransition的方法，系统主要在这个方法里面实现动画的。
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
//    [pan addTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
//    //3.设置代理
//    pan.delegate = self;
//    //4.添加到导航控制器的视图上
//    [self.navigationController.view addGestureRecognizer:pan];
//
//    //5.禁用系统的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if (self.childViewControllers.count == 1 ) {
            
            return NO;
        }
        
        if (self.navigationController.interactivePopGestureRecognizer &&
            [[self.navigationController.interactivePopGestureRecognizer.view gestureRecognizers] containsObject:gestureRecognizer]) {
            
            CGPoint tPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
            
            if (tPoint.x >= 0) {
                CGFloat y = fabs(tPoint.y);
                CGFloat x = fabs(tPoint.x);
                CGFloat af = 30.0f/180.0f * M_PI;
                CGFloat tf = tanf(af);
                if ((y/x) <= tf) {
                    return YES;
                }
                return NO;
                
            }else{
                return NO;
            }
        }
    }
    return  YES;

}


@end
