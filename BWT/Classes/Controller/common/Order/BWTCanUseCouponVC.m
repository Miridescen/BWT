

//
//  BWTCanUseCouponVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/26.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTCanUseCouponVC.h"
#import "MyCouponTVC.h"
#import "CouponModel.h"
@interface BWTCanUseCouponVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) NSArray *couponArr;
@end

@implementation BWTCanUseCouponVC

static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠劵";
    
    [self setupSubView];
    
    [self loadData];
}

- (void)loadData{
    
    
     @weakify(self);

       NSMutableDictionary *param1 = [[NSMutableDictionary alloc] initWithCapacity:1];
       [param1 setValue:[NSNumber numberWithInteger:self.category] forKey:@"category"];
       [param1 setValue:[NSNumber numberWithFloat:self.price] forKey:@"price"];
       [param1 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
       [param1 setValue:BWTUsertoken forKey:@"token"];
    
    BWTLog(@"%@", param1);
       [AFNetworkTool postJSONWithUrl:Coupon_canuse_list parameters:param1 success:^(id responseObject) {
           @strongify(self);
           if (!self) return;
           BWTLog(@"%@", responseObject);

           self.couponArr = [NSArray yy_modelArrayWithClass:[CouponModel class] json:responseObject];
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
    
    UIView *footBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight-kNavigationBarHeight, kScreenWidth, kTabBarHeight)];
    footBar.backgroundColor = BWTWhiteColor;
    [self.view addSubview:footBar];
    
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, kScreenWidth-40, 40)];
    [_createBtn setTitle:@"扫码激活优惠劵" forState:UIControlStateNormal];
    _createBtn.backgroundColor = BWTMainColor;
    [_createBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _createBtn.titleLabel.font = BWTBaseFont(16);
    [_createBtn addTarget:self action:@selector(createNewCoupon:) forControlEvents:UIControlEventTouchUpInside];
    [footBar addSubview:_createBtn];
    
    
    
}

- (void)createNewCoupon:(UIButton *)btn{
    
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
    CouponModel *model = self.couponArr[indexPath.row];
    cell.couponModel = model;
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
                if (self.couponUseBlock) {
                    self.couponUseBlock(model);
                    [self.navigationController popViewControllerAnimated:NO];
                }
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
