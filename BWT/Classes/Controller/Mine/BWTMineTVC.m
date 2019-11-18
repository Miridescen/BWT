//
//  BWTMineTVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTMineTVC.h"

#import "BWTLoginVC.h"

#import "BWTAddressVC.h"
#import "BWTMyOrderVC.h"
#import "BWTMyCollectVC.h"
#import "BWTMyCouponVC.h"
#import "BWTSettingVC.h"
#import "BWTBrandPhoneVC.h"
#import "BWTChangPhoneVC.h"

#import "BWTUserModel.h"

#import <WebKit/WKWebView.h>

@interface BWTMineTVC ()

@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, strong) BWTUserModel *userModel;

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *changLogoBtn;
@end

@implementation BWTMineTVC

static NSString *const cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hasLogin = [BWTUserTool isLogin];
    if (self.hasLogin) {
        self.userModel = [BWTUserTool userModel];
    }
    self.userModel = [BWTUserTool userModel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotifiction) name:BWTUserLogoutNotifiction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotifiction) name:BWTUserLoginNotifiction object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logoutNotifiction{
    self.hasLogin = NO;
    [self.tableView reloadData];
}

- (void)loginNotifiction{
    self.hasLogin = YES;
    self.userModel = [BWTUserTool userModel];
    BWTLog(@"%@", self.userModel.headPortrait);
    BWTLog(@"%@", self.userModel.nickName);
    [self.tableView reloadData];
}


- (void)phoneNumberClick{
    BWTChangPhoneVC *changePhoneVC = [[BWTChangPhoneVC alloc] init];
    [self.navigationController pushViewController:changePhoneVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        if (self.hasLogin) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 100)];
            bgView.backgroundColor = BWTWhiteColor;
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-200, 30)];
            nameLabel.textColor = BWTFontBlackColor;
            nameLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:22];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.text = self.userModel.nickName;
            [bgView addSubview:nameLabel];
            
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-60, 20, 60, 60)];
            headImageView.backgroundColor = BWTBackgroundGrayColor;
            headImageView.layer.cornerRadius = 30;
            headImageView.layer.masksToBounds = YES;
            [headImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"img_user"]];
            [bgView addSubview:headImageView];
            
            _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, VIEW_BY(nameLabel)+4, 120, 22)];
            _phoneLabel.textColor = BWTFontBlackColor;
            _phoneLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            _phoneLabel.textAlignment = NSTextAlignmentLeft;
            _phoneLabel.text = self.userModel.mobile;
            [bgView addSubview:_phoneLabel];
            
            _changLogoBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_BX(_phoneLabel)+5, VIEW_BY(nameLabel)+4, 40, 20)];
            [_changLogoBtn setTitle:@"更换" forState:UIControlStateNormal];
            [_changLogoBtn setTitleColor:RGBColor(251, 93, 24) forState:UIControlStateNormal];
            _changLogoBtn.layer.borderWidth = 1;
            _changLogoBtn.layer.borderColor = [RGBColor(251, 93, 24) CGColor];
            _changLogoBtn.layer.cornerRadius = 2;
            _changLogoBtn.layer.masksToBounds = YES;
            _changLogoBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14];
            
            [_changLogoBtn addTarget:self action:@selector(phoneNumberClick) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:_changLogoBtn];
            
            _phoneLabel.width = [NSString sizeWithText:_phoneLabel.text font:_phoneLabel.font].width;
            _changLogoBtn.left = VIEW_BX(_phoneLabel)+10;
            
            [cell.contentView addSubview:bgView];
        } else {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 100)];
            bgView.backgroundColor = BWTWhiteColor;
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(20, 35, 99, 30);
            label.text = @"登录/注册";
            label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
            label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
            [bgView addSubview:label];
            
            UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-60, 20, 60, 60)];
            headImageView.backgroundColor = BWTBackgroundGrayColor;
            headImageView.image = [UIImage imageNamed:@"img_user"];
            headImageView.layer.cornerRadius = 30;
            headImageView.layer.masksToBounds = YES;
            [bgView addSubview:headImageView];
            
            [cell.contentView addSubview:bgView];
        }
        
    }
    if (0 < indexPath.row && indexPath.row <=4) {
        NSArray *nameArr = @[@"我的订单", @"我的收藏", @"优惠劵", @"收货地址"];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 80, 22)];
        nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = nameArr[indexPath.row-1];
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
    if (indexPath.row == 5) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 80, 22)];
        nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"设置";
        [bgView addSubview:nameLabel];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 20, 10, 14)];
        arrowImg.image = [UIImage imageNamed:@"img_rightjiantou"];
        [bgView addSubview:arrowImg];
        
        [cell.contentView addSubview:bgView];
        
    }
    if (indexPath.row == 6) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 80, 18)];
        nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"联系客服";
        [bgView addSubview:nameLabel];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-130, 18, 130, 18)];
        phoneLabel.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        phoneLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        phoneLabel.textAlignment = NSTextAlignmentRight;
        phoneLabel.text = @"0571-86702291";
        
        [bgView addSubview:phoneLabel];
        
        [cell.contentView addSubview:bgView];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 120;
    }
    if (0 < indexPath.row && indexPath.row <=4) {
        return 55;
    }
    if (indexPath.row == 5) {
        return 65;
    }
    if (indexPath.row == 6) {
        return 65;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!_hasLogin) {
            BWTLoginVC *loginVC = [[BWTLoginVC alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:loginVC animated:YES];
            });   
        }
        
    }
    if (indexPath.row == 1) {
        if (!_hasLogin) {
            BWTLoginVC *loginVC = [[BWTLoginVC alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:loginVC animated:YES];
            });
        } else {
            BWTMyOrderVC *myOrderVC = [[BWTMyOrderVC alloc] init];
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }
        
    }
    if (indexPath.row == 2) {
        
        if (!_hasLogin) {
            BWTLoginVC *loginVC = [[BWTLoginVC alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:loginVC animated:YES];
            });
        } else{
            BWTMyCollectVC *myCollectVC = [[BWTMyCollectVC alloc] init];
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }
        
    }
    if (indexPath.row == 3) {
        
        if (!_hasLogin) {
            BWTLoginVC *loginVC = [[BWTLoginVC alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:loginVC animated:YES];
            });
        } else {
            BWTMyCouponVC *myCouponVC = [[BWTMyCouponVC alloc] init];
            [self.navigationController pushViewController:myCouponVC animated:YES];
        }
        
    }
    if (indexPath.row == 4) {
        if (!_hasLogin) {
            BWTLoginVC *loginVC = [[BWTLoginVC alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:loginVC animated:YES];
            });
        } else {
            BWTAddressVC *addressVC = [[BWTAddressVC alloc] init];
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        
    }
    if (indexPath.row == 5) {
        BWTSettingVC *addressVC = [[BWTSettingVC alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    
    if (indexPath.row == 6) {

        NSURL *phoneURLOne = [NSURL URLWithString:BWTServerPhone];

        [[UIApplication sharedApplication] openURL:phoneURLOne options:@{} completionHandler:nil];
        
    }
    
}
@end
