//
//  AppDelegate.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 gengliming. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "XGPush.h"
#import "XGSetting.h"

#define _IPHONE80_ 80000

#define AppId 2200176610
#define AppKey @"IS9W73XQJ51J"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (HNATabBarController *)tabBarController {
    if (_tabBarController == nil) {
        _tabBarController = [MainStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    }
    return _tabBarController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 修改状态栏字体为白色
    [SharedApplication setStatusBarStyle: UIStatusBarStyleLightContent];
    
    // 设置推送
    [self setupPush:launchOptions];
    
    // 网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                HNALog(@"没有网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                HNALog(@"WiFi网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                HNALog(@"无线网络");
                break;
            }
            default:
                break;
        }
    }];
    
    return YES;
}

- (void)setupPush:(NSDictionary *)launchOptions {
    [XGPush startApp:AppId appKey:AppKey];
    
    void (^successCallback)(void) = ^(void){
        if (![XGPush isUnRegisterStatus]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];

}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    // 注册设备
    XGSetting *setting = (XGSetting *)[XGSetting getInstance];
    [setting setChannel:@"appstore"];
    [setting setGameServer:@"巨神峰"];
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
