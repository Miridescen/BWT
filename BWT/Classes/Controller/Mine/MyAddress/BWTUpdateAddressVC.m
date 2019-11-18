
//
//  BWTUpdateAddressVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/22.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTUpdateAddressVC.h"

#import "addressModel.h"
#import "BWTTextView.h"

#import "BLAreaPickerView.h"
@interface BWTUpdateAddressVC ()<UITableViewDelegate, UITableViewDataSource, BLPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *createBtn;

@property (nonatomic, strong) BLAreaPickerView *pickView;

@property (nonatomic, strong) UILabel *addressSelectLabel;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) BWTTextView *messageTV;
@property (nonatomic, strong) UISwitch *defaultSwitch;

@property (nonatomic, strong) addressModel *freshAddressModel;
@property (nonatomic, copy) NSString *provinceStreetStr; // 省市区地址信息
@property (nonatomic, copy) NSString *detailStreetStr; // 详细信息

@end

@implementation BWTUpdateAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改收货地址";
    self.freshAddressModel = [[addressModel alloc] init];
    self.freshAddressModel.name = _addressModel.name;
    self.freshAddressModel.telephone = _addressModel.telephone;
    _provinceStreetStr = _addressModel.street;
    _detailStreetStr = _addressModel.hourseNumber;
    self.freshAddressModel.isDefault = _addressModel.isDefault;
    [self setupSubView];
}

- (void)setupSubView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 330)];
    _tableView.backgroundColor = BWTBackgroundGrayColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    
    _createBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, VIEW_BY(_tableView)+40, kScreenWidth-40, 45)];
    [_createBtn setTitle:@"保存" forState:UIControlStateNormal];
    _createBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    [_createBtn setTitleColor:BWTWhiteColor forState:UIControlStateNormal];
    _createBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _createBtn.layer.cornerRadius = 5;
    _createBtn.layer.masksToBounds = YES;
    [_createBtn addTarget:self action:@selector(createNewAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createBtn];
   
}

- (void)createNewAddress:(UIButton *)btn{
    
    self.freshAddressModel.name = self.nameTF.text;
    if ([NSString isBlackString:self.freshAddressModel.name]) {
        [MSTipView showWithMessage:@"姓名不能为空"];
        return;
    }
    
    self.freshAddressModel.telephone = self.phoneTF.text;
    if ([NSString isBlackString:self.freshAddressModel.telephone]) {
        [MSTipView showWithMessage:@"电话不能为空"];
       
        return;
    }
    if (![NSString isMobilePhone:self.freshAddressModel.telephone]) {
               [MSTipView showWithMessage:@"请输入正确手机号"];
               return;
           }


    if ([NSString isBlackString:self.provinceStreetStr]) {
        [MSTipView showWithMessage:@"请填写完整地址"];
        return;
    }
    
    self.detailStreetStr = self.messageTV.text;
    if ([NSString isBlackString:self.detailStreetStr]) {
        [MSTipView showWithMessage:@"请填写完整地址"];
        return;
    }
    
    NSString *fullAddStr = [NSString stringWithFormat:@"%@&&%@", self.provinceStreetStr, self.detailStreetStr];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:BWTUsertoken forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:BWTUserID] forKey:@"userId"];
    [param setValue:self.freshAddressModel.isDefault forKey:@"isDefault"];
    [param setValue:self.freshAddressModel.name forKey:@"name"];
    [param setValue:fullAddStr forKey:@"street"];
    [param setValue:self.freshAddressModel.telephone forKey:@"telephone"];
    [param setValue:[NSNumber numberWithInteger:self.addressModel._id] forKey:@"id"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:Address_update parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        [MSTipView showWithMessage:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
        
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = BWTBackgroundGrayColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"收货人";
        [bgView addSubview:nameLabel];
        
       
        _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth-20-150, 18, 150, 18)];
        _nameTF.textAlignment = NSTextAlignmentRight;
        _nameTF.text = _addressModel.name;
        _nameTF.delegate = self;
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [bgView addSubview:_nameTF];
    
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
    }
    if (indexPath.row == 1) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"手机号码";
        [bgView addSubview:nameLabel];
        
        
        _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth-20-150, 18, 150, 18)];
        _phoneTF.textAlignment = NSTextAlignmentRight;
        _phoneTF.delegate = self;
        _phoneTF.text = _addressModel.telephone;
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [bgView addSubview:_phoneTF];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgView.layer addSublayer:lineLayer];

        [cell.contentView addSubview:bgView];
    }
    if (indexPath.row == 2) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"收货地址";
        [bgView addSubview:nameLabel];
        
        _addressSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-20-6-6-130, 17, 130, 18)];
        _addressSelectLabel.textColor = BWTFontBlackColor;
        _addressSelectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _addressSelectLabel.textAlignment = NSTextAlignmentRight;
        _addressSelectLabel.text = _addressModel.street;
        CGSize size = [NSString sizeWithText:_addressModel.street font:_addressSelectLabel.font];
        _addressSelectLabel.width = size.width;
        _addressSelectLabel.left = kScreenWidth-20-15-size.width;
        [bgView addSubview:_addressSelectLabel];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-20-10, 20, 10, 14)];
        arrowImg.image = [UIImage imageNamed:@"img_rightjiantou"];
        [bgView addSubview:arrowImg];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
    }
    if (indexPath.row == 3) {
        UIView *bgview = [[UIView alloc] init];
        bgview.frame = CGRectMake(0, 0, kScreenWidth, 80);
        bgview.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        
        
        _messageTV = [[BWTTextView alloc] initWithFrame:CGRectMake(16, 10, kScreenWidth-32, 60)];
        _messageTV.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _messageTV.delegate = self;
        _messageTV.text = _addressModel.hourseNumber;
        _messageTV.returnKeyType = UIReturnKeyDone;
        [bgview addSubview:_messageTV];
        
        [cell.contentView addSubview:bgview];
    }
    if (indexPath.row == 4) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 55)];
        bgView.backgroundColor = BWTWhiteColor;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 100, 18)];
        nameLabel.textColor = BWTFontBlackColor;
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"设为默认地址";
        [bgView addSubview:nameLabel];
        
        _defaultSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-20-50, 13, 50, 30)];
        _defaultSwitch.onTintColor = [UIColor colorWithHexString:@"#FF934B"];
        [_defaultSwitch addTarget:self action:@selector(defaultSwitchClick:) forControlEvents:UIControlEventValueChanged];
        _defaultSwitch.on = [_addressModel.isDefault isEqualToString:@"t"] ? YES : NO;
        [bgView addSubview:_defaultSwitch];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.frame = CGRectMake(0, 54, kScreenWidth, 1);
        lineLayer.backgroundColor = [BWTBackgroundGrayColor CGColor];
        [bgView.layer addSublayer:lineLayer];
        
        [cell.contentView addSubview:bgView];
    }
    return cell;
}
- (void)defaultSwitchClick:(UISwitch *)defaultSwitch{
    self.freshAddressModel.isDefault = defaultSwitch.on ? @"t" : @"f";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 65;
    }
    if (indexPath.row == 1) {
        return 55;
    }
    if (indexPath.row == 2) {
        return 65;
    }
    if (indexPath.row == 3) {
        return 80;
    }
    if (indexPath.row == 4) {
        return 65;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self.nameTF resignFirstResponder];
        [self.phoneTF resignFirstResponder];
        [self.messageTV resignFirstResponder];
        _pickView = [[BLAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
        _pickView.pickViewDelegate = self;
        _pickView.cancelButtonColor = BWTFontBlackColor;
        _pickView.sureButtonColor = BWTFontBlackColor;
        [_pickView bl_show];
        
    }
}

#pragma mark - - BLPickerViewDelegate
- (void)bl_selectedAreaResultWithProvince:(NSString *)provinceTitle city:(NSString *)cityTitle area:(NSString *)areaTitle{
    NSString *addText = [NSString stringWithFormat:@"%@%@%@", provinceTitle, cityTitle, areaTitle];
    _addressSelectLabel.text = addText;
    CGSize size = [NSString sizeWithText:addText font:_addressSelectLabel.font];
    _addressSelectLabel.width = size.width;
    _addressSelectLabel.left = kScreenWidth-20-6-6-size.width;
    
    self.provinceStreetStr = addText;

}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField ==  self.nameTF){
        self.freshAddressModel.name = textField.text;
        [textField resignFirstResponder];
    }
    if (textField == self.phoneTF) {
        self.freshAddressModel.telephone = textField.text;
        [textField resignFirstResponder];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField ==  self.nameTF) {
        self.freshAddressModel.name = textField.text;
        [textField resignFirstResponder];
        return YES;
    }
    if (textField ==  self.phoneTF) {
        self.freshAddressModel.telephone = textField.text;
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView{
     self.detailStreetStr = textView.text;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if([text isEqualToString:@"\n"]){
//        if ([NSString isBlackString:textView.text]) {
//            [MSTipView showWithMessage:@"详细地址不能为空"];
//            return YES;
//        }
        self.detailStreetStr = textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



@end
