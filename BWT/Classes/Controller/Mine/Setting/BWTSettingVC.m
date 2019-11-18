
//
//  BWTSettingVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTSettingVC.h"
#import "BWTXieyiVC.h"
#import "BWTYinshiVC.h"
#import "BWTVersionVC.h"

@interface BWTSettingVC ()

@end

@implementation BWTSettingVC

static NSString *const cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = BWTBackgroundGrayColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"用户协议";
        [bgView addSubview:nameLabel];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 20, 10, 14)];
        arrowImg.image = [UIImage imageNamed:@"img_rightjiantou"];
        [bgView addSubview:arrowImg];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
    }
    if (indexPath.row == 1) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"隐私政策";
        [bgView addSubview:nameLabel];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 20, 10, 14)];
        arrowImg.image = [UIImage imageNamed:@"img_rightjiantou"];
        [bgView addSubview:arrowImg];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [cell.contentView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
    }
    if (indexPath.row == 2) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"关于";
        [bgView addSubview:nameLabel];
        
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-20-130-6-6, 17, 130, 18)];
        versionLabel.textColor = BWTFontBlackColor;
        versionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        versionLabel.textAlignment = NSTextAlignmentRight;
        
        [bgView addSubview:versionLabel];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"%@", appVersion];
        versionLabel.width = [NSString sizeWithText:versionLabel.text font:versionLabel.font].width;
        versionLabel.left = kScreenWidth-15-6-15-versionLabel.width;

        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 20, 10, 14)];
        arrowImg.image = [UIImage imageNamed:@"img_rightjiantou"];
        [bgView addSubview:arrowImg];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
        
    }
    if (indexPath.row == 3) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake((kScreenWidth-64)/2, 16, 64, 22);
        label.text = @"退出登录";
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        label.textColor = [UIColor colorWithRed:227/255.0 green:59/255.0 blue:48/255.0 alpha:1/1.0];
        [bgView addSubview:label];
        
        [cell.contentView addSubview:bgView];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 65;
    }
    if (indexPath.row == 1) {
        return 55;
    }
    if (indexPath.row == 2) {
        return 65;
    }
    if (indexPath.row == 3) {
        return 65;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        BWTXieyiVC *xieyi = [[BWTXieyiVC alloc] init];
        [self.navigationController pushViewController:xieyi animated:YES];
    }
    if (indexPath.row == 1) {
        BWTYinshiVC *yinsi = [[BWTYinshiVC alloc] init];
        [self.navigationController pushViewController:yinsi animated:YES];
    }
    if (indexPath.row == 2) {
        BWTVersionVC *version = [[BWTVersionVC alloc] init];
        [self.navigationController pushViewController:version animated:YES];
    }
    if (indexPath.row == 3) {
        [BWTUserTool logout];
//        [MSTipView showWithMessage:@"退出成功"];
        self.navigationController.tabBarController.selectedIndex = 0;
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

@end
