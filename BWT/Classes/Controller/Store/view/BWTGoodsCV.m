//
//  BWTGoodsCV.m
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTGoodsCV.h"

#import "BWTGoodCVCell.h"
#import "BWTStoreMenuCRV.h"

#import "BWTSearchVC.h"

#import "GoodsCategoryModel.h"
#import "GoodsRecommendBrandModel.h"
#import "GoodsModel.h"


@interface BWTGoodsCV ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) GoodsCategoryModel *categoryModel;
@property (nonatomic, strong) BWTStoreMenuCRV *storeMenuCRV;

@property (nonatomic, strong) NSMutableArray *goodsListArr;

@property (nonatomic, assign) NSInteger totoalGoodsCount;

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionReusableView *footView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *noMoreDataLabel;

@property (nonatomic, strong) NSArray *brandArr; // 品牌列表Arr
@property (nonatomic, assign) NSInteger categoruID; // 分类ID

@end

@implementation BWTGoodsCV

static NSString * const cellReuseIdentifier = @"cellReuseIdentifier";
static NSString * const headReuseIdentifier = @"headReuseIdentifier";
static NSString * const footReuseIdentifier = @"footReuseIdentifier";

- (instancetype)initWithFrame:(CGRect)frame{
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake((kScreenWidth-3)/2, (kScreenWidth-3)/2+102);
    self.flowLayout.minimumLineSpacing = 3;
    self.flowLayout.minimumInteritemSpacing = 3;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(3, 0, 0, 0);
    self.flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 352);
    self.flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 40);
    
    return [self initWithFrame:frame collectionViewLayout:self.flowLayout];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    BWTLog(@"123");
    if (fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y) < scrollView.contentSize.height * 0.2) {
        
        NSDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[NSNumber numberWithInteger:self.categoryModel._id] forKey:@"goodsFrontCategoryId"];
        [param setValue:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
        [param setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
        BWTLog(@"上拉加载%@   pageNum == %ld", param, self.pageNum);
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:Goods_list parameters:param success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
//            BWTLog(@"%@", responseObject);
            NSArray *goodsArr = [NSArray yy_modelArrayWithClass:[GoodsModel class] json:responseObject[@"items"]];
            if (goodsArr.count > 0) {
                self.pageNum += 1;
                [self.goodsListArr addObjectsFromArray:goodsArr];
            }
            if (self.goodsListArr.count >= self.totoalGoodsCount) {
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
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {

        [self registerClass:[BWTGoodCVCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        [self registerClass:[BWTStoreMenuCRV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headReuseIdentifier];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footReuseIdentifier];
        self.goodsListArr = [@[] mutableCopy];
        self.pageNum = 1;
        self.pageSize = 10;
        self.totoalGoodsCount = 0;
        self.backgroundColor = BWTBackgroundGrayColor;
        self.dataSource = self;
        self.delegate = self;
            
    }
    return self;
}

#pragma mark - public method

- (void)loadDataWith:(GoodsCategoryModel *)categoryModel{
    
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    [self removeAllSubviews];

    self.noMoreDataLabel.hidden = YES;
    
    _categoryModel = categoryModel;
    
    @weakify(self);

    NSDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSNumber numberWithInteger:categoryModel._id] forKey:@"goodsFrontCategoryId"];
    [AFNetworkTool postJSONWithUrl:Goods_recommand_brand_list parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        
        NSArray *result = (NSArray *)responseObject;
        
        
        if (result.count > 0) {
            self.categoruID = [result[0][@"id"] integerValue];
            self.brandArr = [NSArray yy_modelArrayWithClass:[GoodsRecommendBrandModel class] json:result[0][@"goodsAttributeValues"]];
            self.storeMenuCRV.menuArr = self.brandArr;

            
        } else {
            self.brandArr = [@[] mutableCopy];
            self.storeMenuCRV.menuArr = self.brandArr;
        }
        [self reloadData];
    } fail:^(NSError *error) {
        
    }];
    self.pageNum = 1;
    self.pageSize = 10;
    NSDictionary *param1 = [[NSMutableDictionary alloc] init];
    [param1 setValue:[NSNumber numberWithInteger:categoryModel._id] forKey:@"goodsFrontCategoryId"];
    [param1 setValue:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
    [param1 setValue:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
    
//    BWTLog(@"首次加载%@", param1);
    [AFNetworkTool postJSONWithUrl:Goods_list parameters:param1 success:^(id responseObject) {
        
        @strongify(self);
        if (!self) return;
        
//        BWTLog(@"%@", responseObject);
        self.totoalGoodsCount = [responseObject[@"total"] integerValue];
        NSArray *goodsArr = [NSArray yy_modelArrayWithClass:[GoodsModel class] json:responseObject[@"items"]];
        if (goodsArr.count > 0) {
            self.pageNum += 1;
        }
        self.goodsListArr = [NSMutableArray arrayWithArray:goodsArr];
        
        if (self.goodsListArr.count >= self.totoalGoodsCount) {
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
        cell = [[BWTGoodCVCell alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-3)/2, (kScreenWidth-3)/2+102)];
    }
    cell.goodModel = self.goodsListArr[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        BWTStoreMenuCRV *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headReuseIdentifier forIndexPath:indexPath];
        if (!headView) {
            
        }

        @weakify(self);
        headView.menuBtnClickBlock = ^(GoodsRecommendBrandModel * _Nonnull brandModel) {
            @strongify(self);
            if (!self) return;
            if (self.brandSelectBlock) {
                self.brandSelectBlock(brandModel, self.categoruID);
            }
        };
        headView.otherBtnClickBlock = ^{
            @strongify(self);
            if (!self) return;
            if (self.brandOtherSelectBlock) {
                self.brandOtherSelectBlock();
            }
        };
        self.storeMenuCRV = headView;
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

#pragma mark - setter
- (void)setStoreMenuCRVBgImageUrl:(NSString *)storeMenuCRVBgImageUrl{
    _storeMenuCRVBgImageUrl = storeMenuCRVBgImageUrl;
    self.storeMenuCRV.bgImageUrl = _storeMenuCRVBgImageUrl;
}



@end
