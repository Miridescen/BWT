//
//  AppDelegate.m
//  BWT
//
//  Created by Miridescent on 2019/10/12.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "AppDelegate.h"
#import "BWTTabBarController.h"
#import <MeiQiaSDK/MQManager.h>

#import "BWTAppUpdateModel.h"
#import "BWTGuidePageVC.h"

#import "BWTUserModel.h"

// -------------------------------//
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, strong) UIView *bgView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:2];
    
    [self thirdPart];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    [self.window makeKeyAndVisible];
    [self judgeShowNewFeature];
    
    

    return YES;
}


- (void)thirdPart{
    // -------------客服------------
    [MQManager initWithAppkey:BWTMeiyiAPPKEY completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
    }];
    // -------------微信------------
    [WXApi registerApp:weixinAPPKEY universalLink:@"https://www.oneshoesapp.com/openbwtd-ios/"];
    
    // ------------支付宝----------
  
}
// 检测是否弹出引导页
- (void)judgeShowNewFeature
{
    NSString *lastVerson =  [[NSUserDefaults standardUserDefaults] objectForKey:@"CFBundleVersion"];
    NSString *currentVerson = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];// 获取当前版本号
    if ([lastVerson isEqualToString:currentVerson]) {
        BWTTabBarController *tabBar = [[BWTTabBarController alloc] init];
        self.window.rootViewController = tabBar;
        
    } else {
        BWTGuidePageVC *guidePageVC = [[BWTGuidePageVC alloc] init];
        self.window.rootViewController = guidePageVC;
        [[NSUserDefaults standardUserDefaults] setObject:currentVerson forKey:@"CFBundleVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    #pragma mark  集成第二步: 进入前台 打开meiqia服务
    [MQManager openMeiqiaService];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    #pragma mark  集成第三步: 进入后台 关闭美洽服务
    [MQManager closeMeiqiaService];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    #pragma mark  集成第四步: 上传设备deviceToken
    [MQManager registerDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    BWTLog(@"%@", url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"resultStatus"]];
            NSInteger statusCode = [resultStatus integerValue];

            switch (statusCode) {
                case 9000://成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:BWTAliPaySuccessNotifiction object:nil];
                    break;
                case 4000://失败
                    [[NSNotificationCenter defaultCenter] postNotificationName:BWTAliPayFailNotifiction object:nil];
                    break;
                default://其它
                    [[NSNotificationCenter defaultCenter] postNotificationName:BWTAliPayFailNotifiction object:nil];
                    break;
            }
        }];
    }
    if ([url.host isEqualToString:@"oauth"] || [url.host isEqualToString:@"pay"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}


- (void)onResp:(BaseResp*)resp{
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        
        switch (response.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:BWTWeixinPaySuccessNotifiction object:nil];
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:BWTWeixinPayFailNotifiction object:nil];
                break;
        }
    } else {
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSMutableDictionary *param3 = [[NSMutableDictionary alloc] init];
        [param3 setValue:temp.code forKey:@"authCode"];
        [param3 setValue:@"weixin" forKey:@"thirdPlatformType"];
        @weakify(self);
        [AFNetworkTool postJSONWithUrl:User_login_weixin parameters:param3 success:^(id responseObject) {
            @strongify(self);
            if (!self) return;
            BWTLog(@"%@", responseObject);
            if (responseObject) {
                
                NSDictionary *dic = responseObject;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BWTWeixinLoginNotifiction object:dic];
                
            }
            

        } fail:^(NSError *error) {

        }];
    }
    
    
}



@end
