
//
//  BWTAddressVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/22.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTAddressVC.h"

#import "AddressTVC.h"
#import "addressModel.h"

#import "BWTCreateAddressVC.h"
#import "BWTUpdateAddressVC.h"

@interface BWTAddressVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) NSArray *addressArr;

@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, strong) NSMutableArray *cellArray;


@end

@implementation BWTAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.cellArray = [@[] mutableCopy];

    [self setupSubView];
    
    [self loadData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)loadData{

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:BWTUsertoken forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:Address_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
//        BWTLog(@"%@", responseObject);
        self.addressArr = [NSArray yy_modelArrayWithClass:[addressModel class] json:responseObject];
        
        self.noDataView.hidden = self.addressArr.count>0?YES:NO;
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)setupSubView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-60)];
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
    imageView.frame = CGRectMake((kScreenWidth-180)/2, 112, 180, 180);
    imageView.image = [UIImage imageNamed:@"img_address_nuff.png"];
    self.noDataView.backgroundColor = BWTWhiteColor;
    [self.noDataView addSubview:imageView];
    
    UILabel *tiplabel = [[UILabel alloc] init];
    tiplabel.frame = CGRectMake((kScreenWidth-140)/2, VIEW_BY(imageView)+10, 140, 24);
    tiplabel.text = @"暂无收货地址";
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
    [_createBtn setTitle:@"新增" forState:UIControlStateNormal];
    _createBtn.backgroundColor = [UIColor colorWithHexString:@"#FF6600"];
    [_createBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _createBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_createBtn addTarget:self action:@selector(createNewAddress:) forControlEvents:UIControlEventTouchUpInside];
    _createBtn.layer.cornerRadius = 5;
    _createBtn.layer.masksToBounds = YES;
    [footBar addSubview:_createBtn];
    
    
    
}


- (void)createNewAddress:(UIButton *)btn{
    BWTCreateAddressVC *createAddress = [[BWTCreateAddressVC alloc] init];
    [self.navigationController pushViewController:createAddress animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.addressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressTVC *cell = [[AddressTVC alloc] init];
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressModel = self.addressArr[indexPath.section];
    @weakify(self);
    cell.defaultBtnBlock = ^(addressModel * _Nonnull addressModel) {
        @strongify(self);
        if (!self) return;
        NSString *fullAddStr = [NSString stringWithFormat:@"%@&&%@", addressModel.street, addressModel.hourseNumber];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:@"t" forKey:@"isDefault"];
        [param setValue:addressModel.name forKey:@"name"];
        [param setValue:fullAddStr forKey:@"street"];
        [param setValue:addressModel.telephone forKey:@"telephone"];
        [param setValue:[NSNumber numberWithInteger:addressModel._id] forKey:@"id"];
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:Address_update parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            [MSTipView showWithMessage:@"修改成功"];
            [self loadData];
        } fail:^(NSError *error) {
            
        }];
        
    };
    cell.editBtnBlock = ^(addressModel * _Nonnull addressModel) {
        @strongify(self);
        if (!self) return;
        BWTUpdateAddressVC *updateAddress = [[BWTUpdateAddressVC alloc] init];
        updateAddress.addressModel = addressModel;
        [self.navigationController pushViewController:updateAddress animated:YES];
    };
//    [self.cellArray addObject:cell];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = BWTBackgroundGrayColor;
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addressModel *model = self.addressArr[indexPath.section];
    if (self.selectRowBlock) {
        self.selectRowBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        addressModel *addModel = self.addressArr[indexPath.section];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:[NSNumber numberWithInteger:addModel._id] forKey:@"id"];
        
        BWTLog(@"%@", param);
        
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:Address_delete parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            BWTLog(@"%@", responseObject);
            [MSTipView showWithMessage:@"删除成功"];
            [self loadData];
            
        } fail:^(NSError *error) {
            
        }];
        
        
    }];
    action.backgroundColor =  [UIColor colorWithHexString:@"#E33B30"];

    return @[action];
}


@end
