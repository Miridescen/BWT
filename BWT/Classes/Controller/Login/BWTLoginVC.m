//
//  BWTLoginVC.m
//  BWT
//
//  Created by Miridescent on 2019/10/21.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTLoginVC.h"

#import "BWTUserModel.h"
#import "BWTUserTool.h"

#import "BWTXieyiVC.h"
#import "BWTYinshiVC.h"

#import "WXApi.h"

#import "BWTBrandPhoneVC.h"

@interface BWTLoginVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *vertifiTF;
@property (nonatomic, strong) UIButton *getVerifiBtn;

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *vertifi;

@property (nonatomic, strong) UIView *bgView;

@end


@implementation BWTLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BWTWhiteColor;
    self.navigationController.navigationBar.hidden = YES;
    [self addTopView];
    [self addBottomView];
    [self addxieyiView];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeixinLoginNotifiction:) name:BWTWeixinLoginNotifiction object:nil];
}

- (void)WeixinLoginNotifiction:(NSNotification *)notifiction{
    NSDictionary *dic = notifiction.object;
    BWTBrandPhoneVC *brandPhone = [[BWTBrandPhoneVC alloc] init];
    brandPhone.headPortrait = [NSString stringWithFormat:@"%@", dic[@"headPortrait"]];
    brandPhone.nickName = [NSString stringWithFormat:@"%@", dic[@"nickName"]];
    brandPhone.appletUnid = [NSString stringWithFormat:@"%@", dic[@"appletUnid"]];
    [self.navigationController pushViewController:brandPhone animated:YES];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addxieyiView{
    
    NSDate *saveDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:BWTPushUserAggree];
    
    NSDate *nowDate = [NSDate date];
    long long sevenDay = 604800;
    NSDate *expiresTime = [saveDate dateByAddingTimeInterval:sevenDay];
    NSComparisonResult result = [expiresTime compare:nowDate];
    if (result != NSOrderedDescending) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
        [window addSubview:self.bgView];
    }
   
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

- (void)backBtnClick{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getVerifiBtnClick{
    
    NSString *optStr = @"【发送手机验证码】取到的验证码";
    self.phone = self.phoneTF.text;
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
        BWTLog(@"%@", responseObject);
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
- (void)loginBtnClick{
    
    
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
    [param setValue:self.phone forKey:@"mobile"];
    [param setValue:@"noOther" forKey:@"origin"];
    [param setValue:self.vertifi forKey:@"otp"];
    [param setValue:@"lease" forKey:@"productCode"];
    @weakify(self);
    [AFNetworkTool postJSONWithUrl:User_register_and_login parameters:param success:^(id responseObject) {
        @strongify(self);
        if (!self) return;
        BWTLog(@"%@", responseObject);
        
        BWTUserModel *model = [BWTUserModel yy_modelWithJSON:responseObject];
        [BWTUserTool loginWithUserModel:model];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BWTUserLoginNotifiction object:nil];
        
        if (self.loginSuccessBlock) {
            self.loginSuccessBlock();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSError *error) {
            
    }];
     
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)weixinBtnClick{
    
    if ([WXApi isWXAppInstalled]) {
        if ([WXApi isWXAppSupportApi]) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            [WXApi sendReq:req completion:^(BOOL success) {
                
            }];
        } else {
            [MSTipView showWithMessage:@"微信版本过低"];
        }
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:actionConfirm];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (void)xieyiTouchUpInside{
    self.navigationController.navigationBar.hidden = NO;
    BWTXieyiVC *xieyi = [[BWTXieyiVC alloc] init];
    [self.navigationController pushViewController:xieyi animated:YES];
}

- (void)zhengceTouchUpInside{
    self.navigationController.navigationBar.hidden = NO;
    BWTYinshiVC *xinsi = [[BWTYinshiVC alloc] init];
    [self.navigationController pushViewController:xinsi animated:YES];
}

- (void)aggreeBtnClick{

    NSDate *nowDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setValue:nowDate forKey:BWTPushUserAggree];
    [self.bgView removeFromSuperview];
    
}
- (void)unaggreeBtnClick{
    [self.bgView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTopView{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, kStatusBarHeight+15, 20, 20)];
    [backBtn setImage:[UIImage imageNamed:@"img_close"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(36, kStatusBarHeight+80, 109, 37);
    titleLabel.text = @"账号登录";
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
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
   
}


- (void)addBottomView{
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(38, kScreenHeight-kTabBarHeight-100, kScreenWidth-38*2, 1)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
    [self.view addSubview:lineView1];
    
    UILabel *otherlabel = [[UILabel alloc] init];
    otherlabel.frame = CGRectMake((kScreenWidth-88)/2, kScreenHeight-kTabBarHeight-90-20, 88, 20);
    otherlabel.text = @"其他方式登录";
    otherlabel.textAlignment = NSTextAlignmentCenter;
    otherlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    otherlabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    otherlabel.backgroundColor = BWTWhiteColor;
    [self.view addSubview:otherlabel];
    
    UIButton *weixinBtn = [[UIButton alloc] init];
    weixinBtn.frame = CGRectMake((kScreenWidth-50)/2, VIEW_BY(otherlabel)+21, 50, 50);

    [weixinBtn addTarget:self action:@selector(weixinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [weixinBtn setImage:[UIImage imageNamed:@"img_weixin.png"] forState:UIControlStateNormal];
    weixinBtn.layer.cornerRadius = 25;
    weixinBtn.layer.masksToBounds = YES;
    [self.view addSubview:weixinBtn];
    
    if (![WXApi isWXAppInstalled]) {
        lineView1.hidden = YES;
        otherlabel.hidden = YES;
        weixinBtn.hidden = YES;
        
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(38, kScreenHeight-kTabBarHeight+50-38, kScreenWidth-38*2, 17)];
//    bottomView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:bottomView];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(0, 0, 60, 17);
    label1.text = @"登录即同意";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label1.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [bottomView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(VIEW_BX(label1)+6, 0, 48, 17);
    label2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    label2.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    NSDictionary *attribtDic1 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString:@"用户协议" attributes:attribtDic1];
    label2.attributedText = attribtStr1;
    [bottomView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.frame = CGRectMake(VIEW_BX(label2)+6, 0, 12, 17);
    label3.text = @"和";
    label3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label3.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [bottomView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.frame = CGRectMake(VIEW_BX(label3)+6, 0, 48, 17);
    NSDictionary *attribtDic2 = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr2 = [[NSMutableAttributedString alloc]initWithString:@"隐私政策" attributes:attribtDic2];
    label4.attributedText = attribtStr2;
    label4.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    label4.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [bottomView addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.frame = CGRectMake(VIEW_BX(label4)+6, 0, 108, 17);
    label5.text = @"首次登录将自动注册";
    label5.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label5.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [bottomView addSubview:label5];
    
    bottomView.width = VIEW_BX(label4)+6+108;
    bottomView.left = (kScreenWidth-bottomView.width)/2;
    
    
    label2.userInteractionEnabled=YES;
    UITapGestureRecognizer *label2TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiTouchUpInside)];
    [label2 addGestureRecognizer:label2TapGestureRecognizer];
    
    label4.userInteractionEnabled=YES;
    UITapGestureRecognizer *label4TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhengceTouchUpInside)];
    [label4 addGestureRecognizer:label4TapGestureRecognizer];
    
    
    
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = RGBAColor(0, 0, 0, 0.6);
        
        
        UIView *view1 = [[UIView alloc] init];
        view1.frame = CGRectMake((kScreenWidth-270)/2, 146, 270, 350);
        view1.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
        view1.layer.cornerRadius = 12;
        view1.layer.masksToBounds = YES;
        [_bgView addSubview:view1];
        
        UILabel *titlelabel = [[UILabel alloc] init];
        titlelabel.frame = CGRectMake(53, 24, 164, 25);
        titlelabel.text = @"用户协议及隐私政策";
        titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        titlelabel.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1/1.0];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        [view1 addSubview:titlelabel];
        
        UILabel *detaillabel = [[UILabel alloc] init];
        detaillabel.frame = CGRectMake(20, 78, 231, 204);
        detaillabel.text = @"         亲爱的别无他店用户，感谢您使用杭州福贵商务科技有限公司产品【别无他店】！我们非常重视您的个人信息和隐私保护。为了更好地保障您的个人权益，在您使用我们的产品前，请您认真阅读：《用户协议》和《隐私政策》的全部内容，同意并接受全部条款后开始使用我们的产品和服务。我们会严格按照政策内容使用和保护您的个人信息，感谢您的信任！";
        detaillabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        detaillabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
        detaillabel.numberOfLines = 0;
        [view1 addSubview:detaillabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_BY(detaillabel)+24, 270, 1)];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#DEDEDE"];
        [view1 addSubview:lineView];
        
        UIButton *unaggreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, VIEW_BY(lineView), 135, 44)];
        [unaggreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [unaggreeBtn setTitleColor:BWTFontBlackColor forState:UIControlStateNormal];
        unaggreeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        [unaggreeBtn addTarget:self action:@selector(unaggreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:unaggreeBtn];
        
        UIButton *aggreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(135, VIEW_BY(lineView), 135, 44)];
        [aggreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [aggreeBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        aggreeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        [aggreeBtn addTarget:self action:@selector(aggreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:aggreeBtn];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(135, VIEW_BY(lineView), 1, 44)];
        lineView1.backgroundColor =[UIColor colorWithHexString:@"#DEDEDE"];
        [view1 addSubview:lineView1];
    }
    
    return _bgView;
}


@end
