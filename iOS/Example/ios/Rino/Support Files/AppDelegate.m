//
//  AppDelegate.m
//  Rino
//
//  Created by zhangstar on 2022/8/15.
//

#import "AppDelegate.h"
#import "RinoSmartBusinessManager.h"

#import <UserNotifications/UserNotifications.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <RinoAppConfigModule/RinoAppConfigModule.h>
#import <RinoBaseKit/RinoBaseKit.h>
#import <RinoCommonDefineKit/RinoCommonDefineKit.h>
#import <RinoLaunchMenuKit/RinoLaunchMenuKit.h>
#import <RinoNFCKit/RinoNFCKit.h>
#import <RinoProgressHUD/RinoProgressHUD.h>
#import <RinoThirdPartyVoiceKit/RinoThirdPartyVoiceKit.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RinoSmartBusinessManager sharedInstance] registerProtocol];
    [[RinoSmartBusinessManager sharedInstance] initBusinessMonitor];
        
    [self initThirdPartyLibrary:application didFinishLaunchingWithOptions:launchOptions];
    [self registerNotification];
    [self addNotification];
    [self initRootView];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [RinoSDK sharedInstance].deviceToken = deviceToken;
    [[RinoSDK sharedInstance] setDebugMode:YES];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler API_AVAILABLE(ios(8.0)) {
    
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSString *urlString = userActivity.webpageURL.absoluteString;
        if ([urlString containsString:@"download"] || [urlString containsString:@"nfc-control"]) {
            if ([RinoUser sharedInstance].isLogin) {
                [[RinoNFCManager sharedInstance] setUserActivity:userActivity];
                [[RinoNFCManager sharedInstance] startBLEListening];
            }
        } else if ([urlString containsString:@"alexa"] || [urlString containsString:@"google?"]) {
            [[RinoThirdPartyVoiceManager sharedInstance] rino_application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
        }
    }
    
    restorationHandler(nil);
  
    return YES;
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)) {

    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
 
}

#pragma mark - Public
/// 初始化根视图
- (void)initRootView {
    self.window.rootViewController = [[RinoLaunchMenuManager sharedInstance] getWindowRootViewController];
    [self.window makeKeyAndVisible];
}

#pragma mark - Private

/// 初始化第三方配置
- (void)initThirdPartyLibrary:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RinoSDK sharedInstance] rino_application:application didFinishLaunchingWithOptions:launchOptions];
    
    RinoConfigManager *config = [RinoConfigManager sharedInstance];
    if (config.AMapKey.length > 0) {
        [[AMapServices sharedServices] setEnableHTTPS:YES];
        [AMapServices sharedServices].apiKey = config.AMapKey;
    }
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
}

/// 取消注册推送
- (void)removeNotification {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

/// 用户凭证已过期，弹出提示框并重新初始化根视图
- (void)userSessionInvalid {
    [RinoProgressHUD hideHUDView];
    [self initRootView];
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
