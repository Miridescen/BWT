
//
//  BWTBrandPhoneVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTBrandPhoneVC.h"
#import "BWTUserModel.h"

@interface BWTBrandPhoneVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *vertifiTF;
@property (nonatomic, strong) UIButton *getVerifiBtn;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *vertifi;
@end

@implementation BWTBrandPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BWTWhiteColor;
    self.navigationController.navigationBar.hidden = YES;
    [self addTopView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getVerifiBtnClick{
    
    self.phone = self.phoneTF.text;
    NSString *optStr = @"【发送手机验证码】取到的验证码";
    if ([NSString isBlackString:self.phone]) {
        [MSTipView showWithMessage:@"手机号不能为空"];
        return;
        
    } else {
        if (![NSString isMobilePhone:self.phone]) {
            [MSTipView showWithMessage:@"请输入正确手机号"];
            return;
        }
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:optStr forKey:@"otp"];
    [param setValue:self.phone forKey:@"mobile"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:User_get_vertifi parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        __block int timeout=60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getVerifiBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    [self.getVerifiBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateNormal];
                    self.getVerifiBtn.userInteractionEnabled = YES;
                });
            }else{
                int seconds = timeout % 60;
                
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                if ([strTime isEqualToString:@"00"]) {
                    strTime = @"60";
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.getVerifiBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                    [self.getVerifiBtn setTitleColor: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    self.getVerifiBtn.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
    } fail:^(NSError *error) {
            
    }];
    
}
- (void)brindBtnClick{
    
    self.phone = self.phoneTF.text;
    self.vertifi = self.vertifiTF.text;
    if ([NSString isBlackString:self.phone]) {
        [MSTipView showWithMessage:@"手机号不能为空"];
        return;
        
    } else {
        if (![NSString isMobilePhone:self.phone]) {
            [MSTipView showWithMessage:@"请输入正确手机号"];
            return;
        }
    }
    if ([NSString isBlackString:self.vertifi]) {
        [MSTipView showWithMessage:@"验证码不能为空"];
        return;
        
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"Ios" forKey:@"channel"];
    [param setValue:self.headPortrait forKey:@"headPortrait"];
    [param setValue:self.phone forKey:@"mobile"];
    [param setValue:self.nickName forKey:@"nickName"];
    [param setValue:@"noOther" forKey:@"origin"];
    [param setValue:self.vertifi forKey:@"otp"];
    [param setValue:@"lease" forKey:@"productCode"];
    [param setValue:@"weixin" forKey:@"thirdPlatformType"];
    [param setValue:self.appletUnid forKey:@"thirdPlatformUnid"];
    
    BWTLog(@"%@", param);
    
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:User_register_and_login parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        BWTLog(@"%@", responseObject);
        
        BWTUserModel *model = [BWTUserModel yy_modelWithJSON:responseObject];
        [BWTUserTool loginWithUserModel:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:BWTUserLoginNotifiction object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
        
    } fail:^(NSError *error) {
            
    }];
     
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField ==  self.phoneTF) {
        self.phone = textField.text;
        [textField resignFirstResponder];
        return YES;
    }
    if (textField ==  self.vertifiTF) {
        self.vertifi = textField.text;
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
     
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField ==  self.phoneTF) {
        self.phone = textField.text;
        [textField resignFirstResponder];
    }
    if (textField ==  self.vertifiTF) {
        self.vertifi = textField.text;
        [textField resignFirstResponder];
    }
}
- (void)addTopView{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, kStatusBarHeight+15, 20, 20)];
    [backBtn setImage:[UIImage imageNamed:@"img_leftreturn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(36, kStatusBarHeight+80, 140, 37);
    titleLabel.text = @"绑定手机号";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:26];
    titleLabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1/1.0];
    [self.view addSubview:titleLabel];
    
    // -----------
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(38, 194, kScreenWidth-2*38, 33)];
    [self.view addSubview:phoneView];
    
    UILabel *phonelabel = [[UILabel alloc] init];
    phonelabel.frame = CGRectMake(0, 0, 45, 21);
    phonelabel.text = @"手机号";
    phonelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    phonelabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1/1.0];
    [phoneView addSubview:phonelabel];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(64, 0, kScreenWidth-2*38-64, 21)];
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.delegate = self;
    _phoneTF.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:26];
    _phoneTF.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    
    NSString *phoneholderText = @"请输入手机号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:phoneholderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                  value: [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0]
                  range:NSMakeRange(0, phoneholderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"PingFangSC-Regular" size:15]
                  range:NSMakeRange(0, phoneholderText.length)];
    _phoneTF.attributedPlaceholder = placeholder;
    [phoneView addSubview:_phoneTF];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth-2*38, 1)];
    lineView.backgroundColor = RGBColor(230, 230, 230);
    [phoneView addSubview:lineView];
    
    // -----------
    UIView *verifiView = [[UIView alloc] initWithFrame:CGRectMake(38, 277, kScreenWidth-2*38, 33)];
    [self.view addSubview:verifiView];
    
    UILabel *verifilabel = [[UILabel alloc] init];
    verifilabel.frame = CGRectMake(0, 0, 45, 21);
    verifilabel.text = @"验证码";
    verifilabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    verifilabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1/1.0];
    [verifiView addSubview:verifilabel];
    
    _vertifiTF = [[UITextField alloc] initWithFrame:CGRectMake(64, 0, kScreenWidth-2*38-64, 21)];
    _vertifiTF.returnKeyType = UIReturnKeyDone;
    _vertifiTF.delegate = self;
    _vertifiTF.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:26];
    _vertifiTF.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    NSString *vertifierHolderText = @"请输入验证码";
    NSMutableAttributedString *vertifierplaceholder = [[NSMutableAttributedString alloc] initWithString:vertifierHolderText];
    [vertifierplaceholder addAttribute:NSForegroundColorAttributeName
                  value: [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1/1.0]
                  range:NSMakeRange(0, vertifierHolderText.length)];
    [vertifierplaceholder addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"PingFangSC-Regular" size:15]
                  range:NSMakeRange(0, vertifierHolderText.length)];
    _vertifiTF.attributedPlaceholder = vertifierplaceholder;
    [verifiView addSubview:_vertifiTF];
    
    _getVerifiBtn = [[UIButton alloc] init];
    _getVerifiBtn.frame = CGRectMake(kScreenWidth-2*38-80, 0, 80, 21);
    [_getVerifiBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifiBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    _getVerifiBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [_getVerifiBtn addTarget:self action:@selector(getVerifiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _getVerifiBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [verifiView addSubview:_getVerifiBtn];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 32, kScreenWidth-2*38, 1)];
    lineView1.backgroundColor = RGBColor(230, 230, 230);
    [verifiView addSubview:lineView1];
    
    [self.view addSubview:verifiView];
    
    // ------------
    
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = CGRectMake(38, 350, kScreenWidth-38*2, 45);
    [loginBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [loginBtn addTarget:self action:@selector(brindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
   
}

@end
