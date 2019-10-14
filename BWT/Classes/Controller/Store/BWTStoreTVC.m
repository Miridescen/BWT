//
//  BWTStoreTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTStoreTVC.h"

#import "BWTStoreHeadView.h"
#import "BWTStoreMenuTVC.h"

@interface BWTStoreTVC ()<UISearchBarDelegate>

@end

@implementation BWTStoreTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

#pragma mark - private method
- (void)setupNav{
    
    
    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 33)];
    [rightBarButton setImage:[UIImage imageNamed:@"icon_collection"] forState:UIControlStateNormal];
    [rightBarButton setTitle:@"收藏夹" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:BWTGrayColor forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = [UIFont systemFontOfSize:9.0];
    
    rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, 14, 12, 14);
    rightBarButton.titleEdgeInsets = UIEdgeInsetsMake(20, -18, 0, 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-70, 32)];
    searchBar.placeholder = @"Search";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"11");
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"22");
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"33");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.row == 0) {
        cell = [[BWTStoreMenuTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 352;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BWTStoreHeadView *headView = [[BWTStoreHeadView alloc] init];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}





@end
