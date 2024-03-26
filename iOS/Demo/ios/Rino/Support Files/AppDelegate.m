//
//  AppDelegate.m
//  Rino
//
//  Created by zhangstar on 2022/8/15.
//

#import "AppDelegate.h"
#import "RinoSmartBusinessManager.h"

#import <RinoBaseKit/RinoBaseKit.h>
#import "RinoDemoLoginController.h"
#import "RinoHomeTestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RinoSmartBusinessManager sharedInstance] registerProtocol];
    [[RinoSmartBusinessManager sharedInstance] initBusinessMonitor];
    
    [[RinoSDK sharedInstance] rino_application:application didFinishLaunchingWithOptions:launchOptions];
    [self initRootView];
    return YES;
}

/// 初始化根视图
- (void)initRootView {
    if ([RinoUser sharedInstance].isLogin) {
        RinoHomeTestViewController *loginvc = [[RinoHomeTestViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginvc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    } else {
        RinoDemoLoginController *loginvc = [[RinoDemoLoginController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginvc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
   
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [RinoSDK sharedInstance].deviceToken = deviceToken;
    [[RinoSDK sharedInstance] setDebugMode:YES];
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
