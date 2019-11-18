
//
//  BWTGoodsBaseCV.m
//  BWT
//
//  Created by Miridescent on 2019/10/18.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTGoodsBaseCV.h"

#import "BWTGoodCVCell.h"
#import "GoodsModel.h"

@interface BWTGoodsBaseCV ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, assign) NSInteger getDataID;
@property (nonatomic, copy) NSString *getDataTitle;

@property (nonatomic, strong) NSMutableArray *goodsListArr;
@property (nonatomic, assign) NSInteger goodsTotalcount;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionReusableView *footView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *noMoreDataLabel;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;


@property (nonatomic, strong) UIView *noDataView;

@end

@implementation BWTGoodsBaseCV

static NSString * const cellReuseIdentifier = @"11cellReuseIdentifier";
static NSString * const headReuseIdentifier = @"11headReuseIdentifier";
static NSString * const footReuseIdentifier = @"11footReuseIdentifier";
- (instancetype)initWithFrame:(CGRect)frame{
   
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake((kScreenWidth-3)/2, (kScreenWidth-3)/2+102);
    self.flowLayout.minimumLineSpacing = 3;
    self.flowLayout.minimumInteritemSpacing = 3;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(3, 0, 0, 0);
    self.flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    self.flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 40);
    
    return [self initWithFrame:frame collectionViewLayout:self.flowLayout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

        [self registerClass:[BWTGoodCVCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headReuseIdentifier];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footReuseIdentifier];
        self.goodsListArr = [@[] mutableCopy];
        self.pageNum = 1;
        self.pageSize = 10;
        self.goodsTotalcount = 0;
        self.backgroundColor = BWTBackgroundGrayColor;
        self.delegate = self;
        self.dataSource = self;
        
        
        self.noDataView = [[UIView alloc] initWithFrame:self.bounds];
        self.noDataView.backgroundColor = BWTWhiteColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((kScreenWidth-180)/2, 112, 180, 180);
        imageView.image = [UIImage imageNamed:@"img_neirong_null.png"];
        [self.noDataView addSubview:imageView];
        
        UILabel *tiplabel = [[UILabel alloc] init];
        tiplabel.frame = CGRectMake((kScreenWidth-140)/2, VIEW_BY(imageView)+10, 140, 24);
        tiplabel.text = @"未搜索到相关内容";
        tiplabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        tiplabel.textAlignment = NSTextAlignmentCenter;
        tiplabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        [self.noDataView addSubview:tiplabel];
        [self addSubview:_noDataView];
        self.noDataView.hidden = YES;
            
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y) < scrollView.contentSize.height * 0.2) {
        
        
        NSDictionary *param = [[NSMutableDictionary alloc] init];
        if (self.getDataID && self.categoryID) {
            NSArray *arr = @[[NSString stringWithFormat:@"%ld", (long)(long)self.getDataID]];
            [param setValue:[NSNumber numberWithInteger:self.categoryID] forKey:@"goodsFrontCategoryId"];
            [param setValue:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
            [param setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
            [param setValue:arr forKey:@"goodsAttributeValues"];
        }
        if (self.getDataTitle) {
            [param setValue:self.getDataTitle forKey:@"title"];
            [param setValue:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
            [param setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
            [param setValue:[NSNumber numberWithInteger:26] forKey:@"goodsFrontCategoryId"];
        }
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:Goods_list parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            BWTLog(@"%@", responseObject);
            NSArray *goodsArr = [NSArray yy_modelArrayWithClass:[GoodsModel class] json:responseObject[@"items"]];
            if (goodsArr.count > 0) {
                self.pageNum += 1;
                [self.goodsListArr addObjectsFromArray:goodsArr];
                self.noDataView.hidden = self.goodsListArr.count>0?YES:NO;
                [self bringSubviewToFront:self.noDataView];
            }
            
            if (self.goodsListArr.count >= self.goodsTotalcount) {
                self.noMoreDataLabel.hidden = NO;
                [self.activityView stopAnimating];
                self.activityView.hidden = YES;
            } else {
                self.noMoreDataLabel.hidden = YES;
                self.activityView.hidden = NO;
                [self.activityView startAnimating];
            }
            
            [self reloadData];
        } fail:^(NSError *error) {
            
        }];
                    
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BWTGoodCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[BWTGoodCVCell alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-3)/2, (kScreenWidth-3)/2)];
    }
    cell.goodModel = self.goodsListArr[indexPath.row];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headReuseIdentifier forIndexPath:indexPath];
        if (!headView) {
            headView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        }
        return headView;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        _footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footReuseIdentifier forIndexPath:indexPath];
        [_footView addSubview:self.activityView];
        [_footView addSubview:self.noMoreDataLabel];
        if (!_footView) {
            _footView = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];

        }
        return _footView;
        
    }

    return nil;
}

- (UILabel *)noMoreDataLabel{
    if (!_noMoreDataLabel) {
        _noMoreDataLabel = [[UILabel alloc] init];
        _noMoreDataLabel.frame = CGRectMake((kScreenWidth-114)/2, 13, 114, 20);
        _noMoreDataLabel.text = @"我是有底线的哦～";
        _noMoreDataLabel.backgroundColor = BWTBackgroundGrayColor;
        _noMoreDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _noMoreDataLabel.textColor = [UIColor colorWithHexString:@"#A29D9C"];
    }
    return _noMoreDataLabel;
}
- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((kScreenWidth-30)/2, 5, 30, 30)];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _activityView;
}
#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
       GoodsModel *goodModel = self.goodsListArr[indexPath.row];
       if (_cellSelectBlock) {
           _cellSelectBlock(goodModel);
       }
}

#pragma mark - publicMethod

- (void)loadDataWithGoodsFrontCategoryId:(NSInteger)goodsFrontCategoryId goodsAttributeValues:(NSInteger)goodsAttributeValues{
    
    self.noMoreDataLabel.hidden = YES;
    self.categoryID = goodsFrontCategoryId;
    self.getDataID = goodsAttributeValues;
    NSArray *arr = @[[NSString stringWithFormat:@"%ld", self.getDataID]];
    NSDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSNumber numberWithInteger:goodsFrontCategoryId] forKey:@"goodsFrontCategoryId"];
    [param setValue:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
    [param setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
    [param setValue:arr forKey:@"goodsAttributeValues"];
    
    @weakify(self)
    [AFNetworkTool postJSONWithUrl:Goods_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        self.goodsTotalcount = [responseObject[@"total"] integerValue];
        NSArray *goodsArr = [NSArray yy_modelArrayWithClass:[GoodsModel class] json:responseObject[@"items"]];
        if (goodsArr.count > 0) {
            self.pageNum += 1;
        }
        [self.goodsListArr removeAllObjects];
        [self.goodsListArr addObjectsFromArray:goodsArr];
        self.noDataView.hidden = self.goodsListArr.count>0?YES:NO;
        [self bringSubviewToFront:self.noDataView];
        
        if (self.goodsListArr.count >= self.goodsTotalcount) {
            self.noMoreDataLabel.hidden = NO;
            [self.activityView stopAnimating];
            self.activityView.hidden = YES;
        } else {
            self.noMoreDataLabel.hidden = YES;
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
        }
        [self reloadData];
    } fail:^(NSError *error) {
        
    }];
    
}


- (void)loadDataWithTitle:(NSString *)title{
    self.getDataTitle = title;
}

#pragma mark - setter
- (void)setGetDataTitle:(NSString *)getDataTitle{
    _getDataTitle = getDataTitle;
    
    self.noMoreDataLabel.hidden = YES;
    @weakify(self);

    NSDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.getDataTitle forKey:@"title"];
    [param setValue:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
    [param setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
    [param setValue:[NSNumber numberWithInteger:26] forKey:@"goodsFrontCategoryId"];
    [AFNetworkTool postJSONWithUrl:Goods_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        self.goodsTotalcount = [responseObject[@"total"] integerValue];
        NSArray *goodsArr = [NSArray yy_modelArrayWithClass:[GoodsModel class] json:responseObject[@"items"]];
        if (goodsArr.count > 0) {
            self.pageNum += 1;
        }
        [self.goodsListArr removeAllObjects];
        [self.goodsListArr addObjectsFromArray:goodsArr];
        self.noDataView.hidden = self.goodsListArr.count>0?YES:NO;
        [self bringSubviewToFront:self.noDataView];
        
        if (self.goodsListArr.count >= self.goodsTotalcount) {
            self.noMoreDataLabel.hidden = NO;
            [self.activityView stopAnimating];
            self.activityView.hidden = YES;
        } else {
            self.noMoreDataLabel.hidden = YES;
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
        }
        
        [self reloadData];
        
    } fail:^(NSError *error) {
        
    }];
}


@end
