
//
//  BWTBagVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/17.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBagVC.h"

#import "BagGoodModel.h"
#import "BWTBagTVC.h"

#import "BagCleanInfoModel.h"
#import "OrderCellModel.h"

#import "BWTOrderVC.h"

#import "BWTGoodDetailVC.h"

@interface BWTBagVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *goodsTableView;
@property (nonatomic, strong) UIView *footTabBar;

@property (nonatomic, strong) NSArray *goodArr;
@property (nonatomic, strong) NSMutableArray *cellArr;
@property (nonatomic, strong) NSMutableArray *selectedGoodModelArr; // 被选中的cell中的model

@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, strong) UILabel *totalPriceLabel;

@property (nonatomic, assign) NSInteger selectedCellNum; // 被选中cell数量
@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UILabel *zongjiaLabel;

@property (nonatomic, strong) UIButton *selectAllBtn;

@property (nonatomic, strong) BWTOrderVC *orderVC;

@property (nonatomic, strong) UIView *noDataView;

@end

@implementation BWTBagVC

static NSString *const cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物袋";
    _totalPrice = 0;
    _selectedCellNum = 0;
    self.cellArr = [@[] mutableCopy];
    self.selectedGoodModelArr = [@[] mutableCopy];
    [self setupTabView];
    [self setupFootBar];
    
//    [self loadDate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadDate];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    BWTLog(@"viewDidDisappear");
    [self loadDate];
}
- (void)loadDate{

    if (!BWTIsLogin) {
        return;
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:BWTUsertoken forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:ShoppingCart_good_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
//        BWTLog(@"%@", responseObject);
        self.goodArr = [NSArray yy_modelArrayWithClass:[BagGoodModel class] json:responseObject];
        self.selectedCellNum = 0;
        self.totalPrice = 0.0;
        self.selectAllBtn.selected = NO;
        
        [self.selectedGoodModelArr removeAllObjects];
        [self.cellArr removeAllObjects];
        
        self.noDataView.hidden = self.goodArr.count>0?YES:NO;
        
        [self.goodsTableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}


- (void)cleanBtnDidClick:(UIButton *)btn{
    
    if (self.selectedGoodModelArr.count == 0) {
        [MSTipView showWithMessage:@"请选择商品"];
        return;
    }
    
    NSMutableArray *orderIDsArr = [[NSMutableArray alloc] init];
    for (BagGoodModel *model in self.selectedGoodModelArr) {
        [orderIDsArr addObject:[NSNumber numberWithInteger:model._id]];
    }
    
    NSMutableDictionary *param1 = [[NSMutableDictionary alloc] init];
    [param1 setValue:BWTUsertoken forKey:@"token"];
    [param1 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    [param1 setValue:orderIDsArr forKey:@"shoppingCartIds"];
    
    BWTLog(@"%@", param1);
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:ShoppingCart_final_info parameters:param1 success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        BWTLog(@"%@", responseObject);
        NSMutableArray *cellModelArr = [@[] mutableCopy];
        NSArray *dataArr = [NSArray yy_modelArrayWithClass:[BagCleanInfoModel class] json:responseObject];
        for (BagCleanInfoModel *infoModel in dataArr) {
            OrderCellModel *model = [[OrderCellModel alloc] init];
            model.snapshotVersion = infoModel.snapshotVersion;
            model.title = infoModel.title;
            model.imgUrl = infoModel.goodsImg;
            model.price = infoModel.rentUnitPrice;
            model.goodNum = infoModel.itemCount;
            model.standard = infoModel.standards;
            model.orderID = infoModel.orderId;
            
            [cellModelArr addObject:model];
        }
        
        self.orderVC = [[BWTOrderVC alloc] init];
        self.orderVC.cellModelArr = cellModelArr;
        [self.navigationController pushViewController:self.orderVC animated:YES];
    } fail:^(NSError *error) {
        
    }];
    
    
}

- (void)selectAllBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        self.selectedCellNum = 0;
        self.totalPrice = 0.0;
        [self.selectedGoodModelArr removeAllObjects];
        for (BWTBagTVC *cell in self.cellArr) {
            cell.isSelected = NO;
        }
    } else {
        btn.selected = YES;
        CGFloat totalPrice1 = 0.0;
        for (BWTBagTVC *cell in self.cellArr) {
            cell.isSelected = YES;
            totalPrice1 += cell.oneAmount*cell.itemCount;
        }
        self.selectedGoodModelArr = [NSMutableArray arrayWithArray:self.goodArr];
        self.selectedCellNum = self.cellArr.count;
        self.totalPrice = totalPrice1;
    }
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.goodArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BWTBagTVC *cell = [[BWTBagTVC alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BagGoodModel *bagGoodModel = self.goodArr[indexPath.section];
    cell.goodModel = bagGoodModel;
    
    
    @weakify(self);
    cell.selectBtnBlock = ^(BOOL isSelected, NSInteger itemCount, CGFloat totalPrice) {
        @strongify(self);
        if (!self) return;
        
        if (isSelected) {
            self.totalPrice += totalPrice;
            self.selectedCellNum += 1;
            [self.selectedGoodModelArr addObject:bagGoodModel];
            
        } else {
            self.totalPrice -= totalPrice;
            self.selectedCellNum -= 1;
            [self.selectedGoodModelArr removeObject:bagGoodModel];
            
        }
    };
    cell.goodNumBtnBlock = ^(BOOL isSelected, CGFloat goodPrice, GoodNumBtnType btnType, NSInteger itemCount) {
        if (isSelected) {
            switch (btnType) {
                case GoodNumAdd:{
                    self.totalPrice += goodPrice;
                }
                    break;
                case GoodNumSub:
                    self.totalPrice -= goodPrice;
                    break;
                default:
                    break;
            }
        }
        NSMutableDictionary *param1 = [[NSMutableDictionary alloc] init];
        [param1 setValue:BWTUsertoken forKey:@"token"];
        [param1 setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param1 setValue:[NSNumber numberWithInteger:itemCount] forKey:@"itemCount"];
        [param1 setValue:bagGoodModel.orderId forKey:@"orderId"];
        BWTLog(@"%@", param1);
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:ShoppingCart_good_num_change parameters:param1 success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            BWTLog(@"%@", responseObject);
            
        } fail:^(NSError *error) {
            
        }];
    };
    [self.cellArr addObject:cell];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
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
    
    BWTLog(@"d点击");
    BagGoodModel *goodModel = self.goodArr[indexPath.section];
    BWTGoodDetailVC *goodDetail = [[BWTGoodDetailVC alloc] init];
    goodDetail.goodID = goodModel.goodsId;
    [self.navigationController pushViewController:goodDetail animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        BagGoodModel *goodModel = self.goodArr[indexPath.section];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:goodModel.orderId forKey:@"orderId"];
        [param setValue:[NSNumber numberWithInteger:goodModel._id] forKey:@"shoppingCartId"];
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:ShoppingCart_good_remove parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            BWTLog(@"%@", responseObject);
            [MSTipView showWithMessage:@"删除成功"];
            [self loadDate];
            
        } fail:^(NSError *error) {
            
        }];
        
        
    }];
    action.backgroundColor =  [UIColor colorWithHexString:@"#E33B30"];

    return @[action];
}

- (void)setTotalPrice:(CGFloat)totalPrice{
    _totalPrice = totalPrice;
    
    NSString *floatStr = [NSString stringWithFormat:@"¥ %@", @(_totalPrice)];
    if ([floatStr containsString:@"."]) {
        if ([[NSString stringWithFormat:@"¥ %.2f", _totalPrice] isEqualToString:@"¥ -0.00"]) {
            _totalPriceLabel.text = @"¥ 0";
        } else {
            _totalPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f", _totalPrice];
        }
        
    } else {
        _totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@", @(_totalPrice)];
    }

    CGSize totalPriceLabelSize = [NSString sizeWithText:_totalPriceLabel.text font:_totalPriceLabel.font];
    _totalPriceLabel.width = totalPriceLabelSize.width;
    _totalPriceLabel.left = kScreenWidth-100.0/375*kScreenWidth-20-totalPriceLabelSize.width;
    
    _zongjiaLabel.left = kScreenWidth-100.0/375*kScreenWidth-20-totalPriceLabelSize.width-42;
}
- (void)setSelectedCellNum:(NSInteger)selectedCellNum{
    _selectedCellNum = selectedCellNum;
    [_clearBtn setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)_selectedCellNum] forState:UIControlStateNormal];
    _selectAllBtn.selected = _selectedCellNum == _goodArr.count?YES:NO;
        
}
- (void)setupTabView{
    
    _goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-50)];
    _goodsTableView.backgroundColor = BWTBackgroundGrayColor;
    _goodsTableView.delegate = self;
    _goodsTableView.dataSource = self;
    _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _goodsTableView.bounces = NO;
    _goodsTableView.showsVerticalScrollIndicator = NO;
    _goodsTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_goodsTableView];
    
    self.noDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((kScreenWidth-180)/2, 112, 180, 180);
    imageView.image = [UIImage imageNamed:@"img_address_nuff.png"];
    self.noDataView.backgroundColor = BWTWhiteColor;
    [self.noDataView addSubview:imageView];
    
    UILabel *tiplabel = [[UILabel alloc] init];
    tiplabel.frame = CGRectMake((kScreenWidth-140)/2, VIEW_BY(imageView)+10, 140, 24);
    tiplabel.text = @"购物袋是空的呦";
    tiplabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self.noDataView addSubview:tiplabel];
    [self.view addSubview:_noDataView];
    self.noDataView.hidden = YES;
}

- (void)setupFootBar{
    self.footTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kNavigationBarHeight-kTabBarHeight-50, kScreenWidth, 50)];
    _footTabBar.backgroundColor = [UIColor whiteColor];
//    _footTabBar.layer.masksToBounds = NO;
//
//    _footTabBar.layer.shadowColor = [UIColor blackColor].CGColor;
//    _footTabBar.layer.shadowOpacity = 0.8f;
//    _footTabBar.layer.shadowRadius = 4.f;
//    _footTabBar.layer.shadowOffset = CGSizeMake(4,4);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" andAlpha:0.1];
    [_footTabBar addSubview:lineView];
    [self.view addSubview:_footTabBar];
    
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectAllBtn.frame = CGRectMake(20, 15, 20, 20);
    [_selectAllBtn setImage:[UIImage imageNamed:@"img_select_off"]  forState:UIControlStateNormal];
    [_selectAllBtn setImage:[UIImage imageNamed:@"img_select_on"]  forState:UIControlStateSelected];
    _selectAllBtn.selected = NO;
    [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:_selectAllBtn];
    
    UILabel *quanxuanlabel = [[UILabel alloc] init];
    quanxuanlabel.frame = CGRectMake(48, 15, 28, 20);
    quanxuanlabel.text = @"全选";
    quanxuanlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    quanxuanlabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [_footTabBar addSubview:quanxuanlabel];

    
//    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _selectAllBtn.frame = CGRectMake(20.0/375*kScreenWidth, 0, 60.0/375*kScreenWidth, 50);
//    [_selectAllBtn setImage:[UIImage imageNamed:@"img_select_off"]  forState:UIControlStateNormal];
//    [_selectAllBtn setImage:[UIImage imageNamed:@"img_select_on"]  forState:UIControlStateSelected];
//    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
//    [_selectAllBtn setTitleColor:BWTFontBlackColor forState:UIControlStateNormal];
//    _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    _selectAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    _selectAllBtn.selected = YES;
//     [_selectAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,8,0,0)];
//    [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_footTabBar addSubview:_selectAllBtn];
    
    _zongjiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 42, 20)];
    _zongjiaLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _zongjiaLabel.text = @"合计:";
    _zongjiaLabel.textColor = BWTFontBlackColor;
    [_footTabBar addSubview:_zongjiaLabel];
    
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 10, 20)];
    _totalPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    _totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@", @(_totalPrice)];
    
    _totalPriceLabel.textColor = [UIColor colorWithHexString:@"#E33B30"];
    [_footTabBar addSubview:_totalPriceLabel];
    
    _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100.0/375*kScreenWidth, 0, 100.0/375*kScreenWidth, 50)];
    _clearBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    [_clearBtn setTitle:[NSString stringWithFormat:@"结算(%ld)", (long)self.selectedCellNum] forState:UIControlStateNormal];
    [_clearBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _clearBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [_clearBtn addTarget:self action:@selector(cleanBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footTabBar addSubview:_clearBtn];
     
    
    [self.view addSubview:_footTabBar];
    
    CGSize totalPriceLabelSize = [NSString sizeWithText:_totalPriceLabel.text font:_totalPriceLabel.font];
    _totalPriceLabel.width = totalPriceLabelSize.width;
    _totalPriceLabel.left = kScreenWidth-100.0/375*kScreenWidth-20-totalPriceLabelSize.width;
    
    _zongjiaLabel.left = kScreenWidth-100.0/375*kScreenWidth-20-totalPriceLabelSize.width-42;
    
}
@end
