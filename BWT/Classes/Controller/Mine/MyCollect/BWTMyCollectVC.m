
//
//  BWTMyCollectVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTMyCollectVC.h"

#import "GoodCollectModel.h"
#import "GoodCollectTVC.h"

#import "BWTGoodDetailVC.h"

@interface BWTMyCollectVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *goodArr;

@property (nonatomic, strong) UIView *noDataView;

@end

@implementation BWTMyCollectVC
static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self setupTabView];
    [self loadData];
}
- (void)loadData{
    @weakify(self);

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:BWTUsertoken forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    [AFNetworkTool postJSONWithUrl:Goods_favor_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        BWTLog(@"%@", responseObject);
        self.goodArr = [NSArray yy_modelArrayWithClass:[GoodCollectModel class] json:responseObject];
        self.noDataView.hidden = self.goodArr.count>0?YES:NO;
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}
- (void)setupTabView{
    
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
    imageView.image = [UIImage imageNamed:@"img_shoucang_null.png"];
    [self.noDataView addSubview:imageView];
    
    UILabel *tiplabel = [[UILabel alloc] init];
    tiplabel.frame = CGRectMake((kScreenWidth-140)/2, VIEW_BY(imageView)+10, 140, 24);
    tiplabel.text = @"暂无收藏";
    tiplabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    tiplabel.textAlignment = NSTextAlignmentCenter;
    tiplabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self.noDataView addSubview:tiplabel];
    [self.view addSubview:_noDataView];
    self.noDataView.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.goodArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GoodCollectTVC *cell = [[GoodCollectTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.collectModel = self.goodArr[indexPath.section];
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
    GoodCollectModel *model = self.goodArr[indexPath.section];
    BWTGoodDetailVC *detailVC = [[BWTGoodDetailVC alloc] init];
    detailVC.goodID = model.goodsId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        GoodCollectModel *goodModel = self.goodArr[indexPath.section];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:BWTUsertoken forKey:@"token"];
        [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
        [param setValue:[NSNumber numberWithInteger:goodModel.goodsId] forKey:@"goodsId"];
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:Good_remove_favor parameters:param success:^(id responseObject) {
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
