//
//  AppDelegate.m
//  Rino
//
//  Created by zhangstar on 2022/8/15.
//

#import "AppDelegate.h"

#import <RinoBaseKit/RinoBaseKit.h>
#import "RinoDemoLoginController.h"
#import "RinoHomeTestViewController.h"
#import <RinoBusinessLibraryModule/RinoRootNavigationController.h>
#import <UserNotifications/UserNotifications.h>
#import <RinoIPCKit/RinoIPCKit.h>
#import <RinoLog/RinoLog.h>
#import <RinoProgressHUD/RinoProgressHUD.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initThirdPartyLibrary:application didFinishLaunchingWithOptions:launchOptions];
    [self registerNotification];
    [self addNotification];
    [self initRootView];
    return YES;
}
///杀掉 app
- (void)applicationWillTerminate:(UIApplication *)application {
    [[RinoSDK sharedInstance] rinoSdkApplicationWillTerminate:application];
}

///app 进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[RinoSDK sharedInstance] rinoSdkApplicationDidBecomeActive:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [RinoSDK sharedInstance].deviceToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    [RinoToast showMessage:[NSString stringWithFormat:@"%@", error]];
    RinoLog(@"%@", error);
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler API_AVAILABLE(ios(8.0)) {
    
    return [[RinoSDK sharedInstance] rino_application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[RinoSDK sharedInstance] rino_application:app openURL:url options:options];
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [[RinoIpcVideoOrVoicePushTool sharedInstance] pushIpcVideoOrVoiceMessageWithData:userInfo];
//    } else {

    }
    
    [[RinoSDK sharedInstance] rino_userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
 
    NSDictionary* userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [[RinoIpcVideoOrVoicePushTool sharedInstance] pushIpcVideoOrVoiceMessageWithData:userInfo];
//    } else {
//        // 应用处于后台时的本地推送接受
    }
    
    [[RinoSDK sharedInstance] rino_userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}


/// 初始化根视图
- (void)initRootView {
    if ([RinoUser sharedInstance].isLogin) {
        RinoHomeTestViewController *loginvc = [[RinoHomeTestViewController alloc]init];
        RinoRootNavigationController *nav = [[RinoRootNavigationController alloc]initWithRootViewController:loginvc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    } else {
        RinoDemoLoginController *loginvc = [[RinoDemoLoginController alloc]init];
        RinoRootNavigationController *nav = [[RinoRootNavigationController alloc]initWithRootViewController:loginvc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
   
}
#pragma mark - Private

/// 初始化第三方配置
- (void)initThirdPartyLibrary:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RinoSDK sharedInstance] rino_application:application didFinishLaunchingWithOptions:launchOptions];
    
#ifdef DEBUG
    [[RinoSDK sharedInstance] setDebugMode:YES];
#endif
}

/// 注册协议
- (void)registerNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(initRootView) name:RinoNotificationUserStateChange object:nil];
    [center addObserver:self selector:@selector(userSessionInvalid) name:RinoUserNotificationUserSessionInvalid object:nil];
}

/// 注册App推送
- (void)addNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                    });
                }
            }];
        }
    }];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

/// 用户凭证已过期，弹出提示框并重新初始化根视图
- (void)userSessionInvalid {
    [RinoProgressHUD hideHUDView];
//    [RinoAlertView showAlertTitle:@"rino_user_login_security_expored".localized
//                    selectedBlock:^{
        [self initRootView];
//    }];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}



#pragma mark - Lazy Load

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

@end
