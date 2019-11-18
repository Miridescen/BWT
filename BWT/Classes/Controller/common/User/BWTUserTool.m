//
//  BWTUserTool.m
//  BWT
//
//  Created by Miridescent on 2019/10/24.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "BWTUserTool.h"

#import "BWTUserModel.h"
#import "BWTLoginVC.h"

@interface BWTUserTool ()

@property (nonatomic, strong) BWTUserModel *userModel;

@end

@implementation BWTUserTool

+ (instancetype)sharedSingleton {
    static BWTUserTool *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//        selector:@selector(needLogin)
//            name:
//          object:nil];
    }
    return self;
}
- (void)needLogin{
//    UIView *window =[[[UIApplication sharedApplication] windows] lastObject];
//    UIViewController *rootVC = window.viewController;
//    rootVC presentViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>
}

- (BOOL)login{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BWTUserModel *userModel = [[BWTUserModel alloc] init];
    userModel.nickName = [userDefault objectForKey:@"nickName"];
    userModel.mobile = [userDefault objectForKey:@"mobile"];
    userModel.headPortrait = [userDefault objectForKey:@"headPortrait"];
    userModel.userToken = [userDefault objectForKey:@"userToken"];
    userModel.userId = [[userDefault objectForKey:@"userId"] integerValue];

    if (userModel.userId && userModel.userToken) {
        return YES;
    }
    
    return NO;
}
- (void)setUserModel:(BWTUserModel *)userModel{
    _userModel = [userModel copy];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (void)changeUserPhone:(NSString *)phone{
    if (!phone) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:phone forKey:@"mobile"];
}
+ (void)loginWithUserModel:(BWTUserModel *)model{
    if (!model) {
        return;
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:[NSNumber numberWithInteger:model.userId] forKey:@"userId"];
    [userDefault setValue:[NSString stringWithFormat:@"%@", model.userToken] forKey:@"userToken"];
    [userDefault setValue:[NSString stringWithFormat:@"%@", model.mobile] forKey:@"mobile"];
    [userDefault setValue:[NSString stringWithFormat:@"%@", model.nickName] forKey:@"nickName"];
    [userDefault setValue:[NSString stringWithFormat:@"%@", model.headPortrait] forKey:@"headPortrait"];
    [userDefault synchronize];
}

+ (BWTUserModel *)userModel{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BWTUserModel *userModel = [[BWTUserModel alloc] init];
    userModel.nickName = [userDefault objectForKey:@"nickName"];
    userModel.mobile = [userDefault objectForKey:@"mobile"];
    userModel.headPortrait = [userDefault objectForKey:@"headPortrait"];
    userModel.userToken = [userDefault objectForKey:@"userToken"];
    userModel.userId = [[userDefault objectForKey:@"userId"] integerValue];
    return userModel;
}
+ (BOOL)isLogin{
    BWTUserTool *tool = [[self alloc] init];
    return [tool login];
}

+ (NSString *)userToken{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BWTUserTool *tool = [[self alloc] init];
    if ([tool login]) {
        return [NSString stringWithFormat:@"%@", [userDefault objectForKey:@"userToken"]];
    }
    return nil;
    
}
+ (NSInteger)userId{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BWTUserTool *tool = [[self alloc] init];
    if ([tool login]) {
        return [[userDefault objectForKey:@"userId"] integerValue];
    }
    return 0;

}

+ (void)logout{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"userId"];
    [userDefault removeObjectForKey:@"userToken"];
    [userDefault removeObjectForKey:@"mobile"];
    [userDefault removeObjectForKey:@"nickName"];
    [userDefault removeObjectForKey:@"headPortrait"];
    [userDefault synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BWTUserLogoutNotifiction object:nil];
}

+ (void)presentLoginVC{
    BWTUserTool *tool = [[self alloc] init];
    if (![tool login]) {
        
        UIViewController *currentVC = [[UIApplication sharedApplication] windows].lastObject.rootViewController;
        
        BWTLoginVC *login = [[BWTLoginVC alloc] init];
        [[UINavigationController currentNC] pushViewController:login animated:YES];
        
        
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"用户没有登录，请先登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }]];
//        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//        }]];
//        [currentVC presentViewController:alertC animated:YES completion:nil];
    }
}
@end
