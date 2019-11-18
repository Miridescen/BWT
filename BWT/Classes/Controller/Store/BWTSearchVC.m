
//
//  BWTSearchVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/21.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTSearchVC.h"
#import "BWTGoodsBaseCV.h"
#import "BWTGoodDetailVC.h"

#import "GoodsModel.h"

@interface BWTSearchVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) BWTGoodsBaseCV *brandGoodsCV;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, copy) NSString *searchStr;
@end

@implementation BWTSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldchanag) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData{
    if ([NSString isBlackString:self.searchStr]) {
//        [MSTipView showWithMessage:@"请输入搜索内容"];
        MSTipView *view = [[MSTipView alloc] initWithView:self.view message:@"请输入搜索内容"];
        view.showTime = 2;
        [view show];
        return;
    }
    
    self.brandGoodsCV = [[BWTGoodsBaseCV alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
    [self.brandGoodsCV loadDataWithTitle:self.searchStr];
    
    @weakify(self);
    self.brandGoodsCV.cellSelectBlock = ^(GoodsModel * _Nonnull goodModel) {
        @strongify(self);
        if (!self) return;
        BWTGoodDetailVC *detailVC = [[BWTGoodDetailVC alloc] init];
        detailVC.goodID = goodModel._id;
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    [self.view addSubview:_brandGoodsCV];
}

- (void)setupNav{
        
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(defaultBtnDidClick:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.navigationItem.hidesBackButton = YES;
    
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, kScreenWidth-80, 32)];
//    _searchView.backgroundColor = BWTBackgroundGrayColor;

    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(-8, 0, kScreenWidth-74, 32)];
    _searchTF.backgroundColor = BWTBackgroundGrayColor;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 20, 20)];
    leftImg.image = [UIImage imageNamed:@"icon_search"];
    [leftView addSubview:leftImg];
    
    _searchTF.placeholder = @"Search";
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.returnKeyType = UIReturnKeySearch;
    [_searchTF setLeftView:leftView];
    _searchTF.clearButtonMode = UITextFieldViewModeAlways;
    _searchTF.delegate = self;
    [_searchView addSubview:_searchTF];
//    [_searchTF becomeFirstResponder];
    
    self.navigationItem.titleView = _searchView;
    
    self.navigationItem.leftBarButtonItem = nil;
 
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    [super didMoveToParentViewController:parent];
//    BWTLog(@"parent  == %@", parent);
}
- (void)willMoveToParentViewController:(nullable UIViewController *)parent{
    [super willMoveToParentViewController:parent];
//    BWTLog(@"parent 123123 == %@", parent);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([NSString isBlackString:self.searchTF.text]) {
        [self.searchTF becomeFirstResponder];
    } else {
        [self.searchTF resignFirstResponder];
    }
    
}

- (void)defaultBtnDidClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.brandGoodsCV removeAllSubviews];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.searchStr = textField.text;
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchStr = textField.text;
    [textField resignFirstResponder];
    [self loadData];
    return YES;
}

- (void)textFieldchanag{
    BWTLog(@"123123");
    if ([NSString isBlackString:self.searchTF.text]) {
        [self.brandGoodsCV removeAllSubviews];
    }
}

@end
