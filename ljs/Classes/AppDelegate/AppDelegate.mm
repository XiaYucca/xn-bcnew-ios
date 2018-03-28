//
//  AppDelegate.m
//  ljs
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

//Manager
#import "AppConfig.h"
#import "TLUser.h"
#import "QQManager.h"
#import "TLWXManager.h"
//Macro
//Framework
//Category
//Extension
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "IQKeyboardManager.h"
//M
//V
//C
#import "NavigationController.h"
#import "TabbarViewController.h"
#import "InfoDetailVC.h"
#import "TLUserLoginVC.h"
#import "TLUpdateVC.h"

//#import "AppDelegate+Launch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //配置QQ
    [self configQQ];
    //配置微信
    [self configWeChat];
    //服务器环境
    [self configServiceAddress];
    //获取七牛云域名
//    [[TLUser user] requestQiniuDomain];
    //键盘
    [self configIQKeyboard];
    //配置地图
//    [self configMapKit];
    //配置极光
//    [self configJPushWithOptions:launchOptions];
    //配置根控制器
    [self configRootViewController];
    
    return YES;
}

// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    BOOL isQQ = [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];
    
    if ([url.host containsString:@"qq"]) {
        
        return  [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];
//        [TencentOAuth HandleOpenURL:url];
        
    } else {

        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
    }
    
    return YES;
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    BOOL isQQ = [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];

    if ([url.host containsString:@"qq"]) {

        return [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];
//        [TencentOAuth HandleOpenURL:url];

    } else {

        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];

    }
    return YES;
}

#pragma mark - Config
- (void)configQQ {
    
    [[QQManager manager] registerApp];
}

- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvRelease;
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[InfoDetailVC class]];
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[SendCommentVC class]];
    
}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (1) {
        //先配置到，检查更新的VC,开启更新检查
        TLUpdateVC *updateVC = [[TLUpdateVC alloc] init];
        self.window.rootViewController = updateVC;
        
    } else {
    
        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
        self.window.rootViewController = tabbarCtrl;
    }
    //重新登录
    if([TLUser user].checkLogin) {
        
        [[TLUser user] updateUserInfo];
        // 登录时间变更到，didBecomeActive中
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification
                                                            object:nil];
        
    };
    
    //登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kIMLoginNotification object:nil];
}

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    TLUserLoginVC *loginVC = [TLUserLoginVC new];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
    
    [vc presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 用户登录
- (void)userLogin {
    
}


@end
