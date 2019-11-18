
//
//  BWTMyCouponVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTMyCouponVC.h"

#import "MyCouponTVC.h"
#import "CouponModel.h"
#import "BWTSodeScanVC.h"

@interface BWTMyCouponVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) NSArray *couponArr;

@property (nonatomic, strong) UIView *noDataView;
@end

@implementation BWTMyCouponVC
static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠劵";
    
    [self setupSubView];
    
    [self loadData];
}

- (void)loadData{
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:BWTUsertoken forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:Coupon_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        BWTLog(@"%@", responseObject);
        self.couponArr = [NSArray yy_modelArrayWithClass:[CouponModel class] json:responseObject];
        
        self.noDataView.hidden = self.couponArr.count>0?YES:NO;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)setupSubView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight)];
    _tableView.backgroundColor = BWTBackgroundGrayColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    self.noDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] init];
    self.noDataView.backgroundColor = BWTWhiteColor;
    imageView.frame = CGRectMake((kScreenWidth-180)/2, 112, 180, 180);
    imageView.image = [UIImage imageNamed:@"img_youhuiquan_null.png"];
    [self.noDataView addSubview:imageView];
    
    UILabel *tiplabel = [[UILabel alloc] init];
    tiplabel.frame = CGRectMake((kScreenWidth-140)/2, VIEW_BY(imageView)+10, 140, 24);
    tiplabel.text = @"暂无优惠劵";
    tiplabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self.noDataView addSubview:tiplabel];
    [self.view addSubview:_noDataView];
    self.noDataView.hidden = YES;
    
    UIView *footBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight-10-kNavigationBarHeight, kScreenWidth, kTabBarHeight+10)];
    footBar.backgroundColor = BWTWhiteColor;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.1];
    [footBar addSubview:lineView];
    [self.view addSubview:footBar];
    
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 8, kScreenWidth-40, 45)];
    [_createBtn setTitle:@"扫码激活优惠劵" forState:UIControlStateNormal];
    _createBtn.backgroundColor = BWTMainColor;
    [_createBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];;
    [_createBtn addTarget:self action:@selector(createNewCoupon:) forControlEvents:UIControlEventTouchUpInside];
    _createBtn.layer.cornerRadius = 5;
    _createBtn.layer.masksToBounds = YES;
    [footBar addSubview:_createBtn];
    
    
    
    
    
}

- (void)createNewCoupon:(UIButton *)btn{
    BWTSodeScanVC *codeScanVC = [[BWTSodeScanVC alloc] init];
    codeScanVC.getCouponSuccessBlock = ^{
        [self loadData];
    };
    [self.navigationController pushViewController:codeScanVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCouponTVC *cell = [[MyCouponTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.couponModel = self.couponArr[indexPath.row];
    @weakify(self);
    cell.useBtnBlock = ^(NSInteger couponID, CouponType couponType) {
        @strongify(self);
        if (!self) return;
        switch (couponType) {
            case CouponTypeUnreceive:{
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setValue:BWTUsertoken forKey:@"token"];
                [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
                [param setValue:[NSNumber numberWithInteger:couponID] forKey:@"couponId"];
                @weakify(self);
                [AFNetworkTool postJSONWithUrl:Coupon_get parameters:param success:^(id responseObject) {
                    @strongify(self);
                    if (!self) return;
                    BWTLog(@"%@", responseObject);
                    [MSTipView showWithMessage:@"领取成功"];
                    [self loadData];
                } fail:^(NSError *error) {
                    
                }];
            }
                
                break;
            case CouponTypeUseable:{
                self.navigationController.tabBarController.selectedIndex = 0;
                [self.navigationController popViewControllerAnimated:NO];
            }
                break;
            case CouponTypeUsed:
                break;
            case CouponTypeeExpired:
                break;
                
            default:
                break;
        }
    };

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

@end
