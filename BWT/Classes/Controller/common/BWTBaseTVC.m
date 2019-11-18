
//
//  BWTBaseTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/14.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBaseTVC.h"

@interface BWTBaseTVC ()<UIGestureRecognizerDelegate>

@end

@implementation BWTBaseTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = BWTBackgroundGrayColor;
    
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
    //只有导航的根控制器不需要右滑的返回的功能。
//    if (self.navigationController.viewControllers.count <= 1)
//    {
//        return NO;
//    }
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
    return YES;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 打印touch到的视图
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//
//    // 如果视图为UITableViewCellContentView（即点击tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
