
//
//  BWTMyOrderVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/23.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTMyOrderVC.h"

#import "OrderModel.h"
#import "OrderTVC.h"

#import "BWTCheckoutVC.h"

#import "BWTOrderDetailVC.h"



@interface BWTMyOrderVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *orderDataArr;
@property (nonatomic, strong) NSArray *cellHeightArr;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *noDataView;

@end

@implementation BWTMyOrderVC

static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self setupSubView];
    [self loadData];
}

- (void)loadData{

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:BWTUsertoken forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:Order_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        BWTLog(@"支付成功 == 123123");
//        BWTLog(@"%@", responseObject);
        self.orderDataArr = [NSArray yy_modelArrayWithClass:[OrderModel class] json:responseObject];
        self.cellHeightArr = [self cellHeightWith:self.orderDataArr];
        self.noDataView.hidden = self.orderDataArr.count>0?YES:NO;
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)setupSubView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
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
    imageView.image = [UIImage imageNamed:@"img_dingdan_null.png"];
    [self.noDataView addSubview:imageView];
    
    UILabel *tiplabel = [[UILabel alloc] init];
    tiplabel.frame = CGRectMake((kScreenWidth-140)/2, VIEW_BY(imageView)+10, 140, 24);
    tiplabel.text = @"暂无订单";
    tiplabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self.noDataView addSubview:tiplabel];
    [self.view addSubview:_noDataView];
    self.noDataView.hidden = YES;
    
    
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderTVC *cell = [[OrderTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    OrderModel *orderModel = self.orderDataArr[indexPath.row];
    cell.orderModel = orderModel;
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self)
    cell.subCellClickBlock = ^{
        @strongify(self);
        if (!self) return;
        BWTOrderDetailVC *detailVC = [[BWTOrderDetailVC alloc] init];
        detailVC.orderID = orderModel.orderId;
        if ([orderModel.orderState isEqualToString:@"finish"]) {
            detailVC.orderDetailVCType = OrderDetailVCTypeFinished;
        } else if ([orderModel.orderState isEqualToString:@"canceled"]) {
            detailVC.orderDetailVCType = OrderDetailVCTypeCanceled;
        } else if ([orderModel.orderState isEqualToString:@"wait_pay"]) {
            detailVC.orderDetailVCType = OrderDetailVCTypeWaitPay;
        } else if ([orderModel.orderState isEqualToString:@"wait_deliver"]) {
            detailVC.orderDetailVCType = OrderDetailVCTypeWaitDeliver;
        } else if ([orderModel.orderState isEqualToString:@"wait_receive"]) {
            detailVC.orderDetailVCType = OrderDetailVCTypeWaitReceive;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    cell.stateOneBtnBlock = ^(OrderCellType orderCellType) {
        @strongify(self);
        if (!self) return;
        switch (orderCellType) {
            case OrderCellTypeFinished:
                break;
            case OrderCellTypeCanceled:
                break;
            case OrderCellTypeWaitPay:{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定取消订单？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setValue:BWTUsertoken forKey:@"token"];
                    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
                    [param setValue:orderModel.orderId forKey:@"orderId"];
                    @weakify(self);
                    [AFNetworkTool postJSONWithUrl:Order_cancel parameters:param success:^(id responseObject) {
                        @strongify(self);
                        if (!self) return;
                        [self loadData];
                        
                    } fail:^(NSError *error) {
                        
                    }];
                    
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
                
            }
                break;
            case OrderCellTypeWaitDeliver:
            
                break;
            case OrderCellTypeWaitReceive:
                break;
                
            default:
                break;
        }
        
        
    };
    cell.stateTwoBtnBlock = ^(OrderCellType orderCellType) {
        @strongify(self);
        if (!self) return;
        switch (orderCellType) {
            case OrderCellTypeFinished:
                break;
            case OrderCellTypeCanceled:{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定删除订单？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setValue:BWTUsertoken forKey:@"token"];
                    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
                    [param setValue:orderModel.orderId forKey:@"orderId"];
                    @weakify(self);
                    [AFNetworkTool postJSONWithUrl:Order_delete parameters:param success:^(id responseObject) {
                        @strongify(self);
                        if (!self) return;
                        [self loadData];
                        
                    } fail:^(NSError *error) {
                        
                    }];
                    
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
                
            }
                break;
            case OrderCellTypeWaitPay:{
                BWTCheckoutVC *checkoutVC = [[BWTCheckoutVC alloc] init];
                checkoutVC.amount = orderModel.totalAmount;
                checkoutVC.orderIDs = orderModel.orderIds;
                [self.navigationController pushViewController:checkoutVC animated:YES];
                
            }
                break;
            case OrderCellTypeWaitDeliver:
            
                break;
            case OrderCellTypeWaitReceive:{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定收货？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setValue:BWTUsertoken forKey:@"token"];
                    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
                    [param setValue:orderModel.orderId forKey:@"orderId"];
                    @weakify(self);
                    [AFNetworkTool postJSONWithUrl:Order_sure parameters:param success:^(id responseObject) {
                        @strongify(self);
                        if (!self) return;
                        [self loadData];
                        
                    } fail:^(NSError *error) {
                        
                    }];
                    
                }]];
                [self presentViewController:alertC animated:YES completion:nil];
                
            }
                break;
                
            default:
                break;
        }
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.cellHeightArr[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = self.orderDataArr[indexPath.row];
    BWTOrderDetailVC *detailVC = [[BWTOrderDetailVC alloc] init];
    detailVC.orderID = model.orderId;
    if ([model.orderState isEqualToString:@"finish"]) {
        detailVC.orderDetailVCType = OrderDetailVCTypeFinished;
    } else if ([model.orderState isEqualToString:@"canceled"]) {
        detailVC.orderDetailVCType = OrderDetailVCTypeCanceled;
    } else if ([model.orderState isEqualToString:@"wait_pay"]) {
        detailVC.orderDetailVCType = OrderDetailVCTypeWaitPay;
    } else if ([model.orderState isEqualToString:@"wait_deliver"]) {
        detailVC.orderDetailVCType = OrderDetailVCTypeWaitDeliver;
    } else if ([model.orderState isEqualToString:@"wait_receive"]) {
        detailVC.orderDetailVCType = OrderDetailVCTypeWaitReceive;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
     
}


- (NSArray *)cellHeightWith:(NSArray *)dataArr{
    NSInteger itemCount = dataArr.count;
    NSMutableArray *cellHeightArr = [@[] mutableCopy];
    for (NSInteger i = 0; i < itemCount; i++) {
        OrderModel *model = dataArr[i];
        
        CGFloat cellHeight = model.subOrderList.count*120 + 150;
        if ([model.orderState isEqualToString:@"finish"]) {
            cellHeight -= 45;
        } else if ([model.orderState isEqualToString:@"canceled"]) {
        } else if ([model.orderState isEqualToString:@"wait_pay"]) {
        } else if ([model.orderState isEqualToString:@"wait_deliver"]) {
            cellHeight -= 45;
        } else if ([model.orderState isEqualToString:@"wait_receive"]) {
        }
        
        
        [cellHeightArr addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    
    return cellHeightArr;
}

@end
