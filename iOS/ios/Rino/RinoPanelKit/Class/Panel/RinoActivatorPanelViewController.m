//
//  RinoActivatorPanelViewController.m
//  Rino
//
//  Created by zhangstar on 2023/7/5.
//

#import "RinoActivatorPanelViewController.h"
#if __has_include(<React/RCTRootView.h>)
#import <React/RCTRootView.h>
#else
#import "RCTRootView.h"
#endif

#if __has_include(<React/RCTAssert.h>)
#import <React/RCTEventDispatcher.h>
#import <React/RCTDevSettings.h>
#import <React/RCTPerformanceLogger.h>
#import <React/RCTAssert.h>
#import <React/RCTBridge+Private.h>
#else
#import "RCTEventDispatcher.h"
#import "RCTDevSettings.h"
#import "RCTPerformanceLogger.h"
#import "RCTAssert.h"
#endif

#import "RinoEmitterModule.h"
#import <RinoBizCore/RinoBizCore.h>
#import <RinoBusinessLibraryModule/RinoPermissionKit.h>
#import <RinoDebugKit/RinoDebugKit.h>
#import <RinoPanelKit/RinoPanelKit.h>

@interface RinoActivatorPanelViewController ()<RCTBridgeDelegate>

@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, strong) RCTRootView *rootView;
@property (nonatomic, strong) RinoEmitterModule *emitter;

@end

@implementation RinoActivatorPanelViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setWiFiInfo) name:UIApplicationDidBecomeActiveNotification object:nil];
    NSDictionary *properties = @{};
    if (self.activatorData.allKeys.count > 0) {
        NSString *iosRnType = [self.activatorData StringForKey:@"iosRnType"];
        if ([iosRnType isEqualToString:@"itemClick"]) {
            properties = @{@"pairingDataFromProductType":[self.activatorData mj_JSONString]};
        } else if ([iosRnType isEqualToString:@"scan"]) {
            properties = @{@"deviceQRCodeInfo":[self.activatorData mj_JSONString]};
        }
    }
    self.bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    self.rootView = [[RCTRootView alloc] initWithBridge:self.bridge
                                             moduleName:@"RinoRCTConfigNetwork"
                                      initialProperties:properties];
    self.rootView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rootView];
    
    id<RinoPanelProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoPanelProtocol)];
    [impl deallocPanelOperationView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setWiFiInfo {
    NSString *ssid = [[RinoPermissionManager sharedInstance] currentWifiSSID]?:@"";
    [self.emitter sendPanelNotify:RinoPanelEmitterSystemWifiChange data:ssid];
}

#pragma mark - RCTBridgeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    if ([RinoDebugManager sharedInstance].debugPanel == YES) {
        NSString *ip = [RinoDebugManager sharedInstance].debugPanelIP?:@"";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index.bundle?platform=ios&dev=true", ip]];
        return url;
    } else {
        NSString *filePath = [[RinoPanelManager sharedInstance] getActivatorPanelFilePath];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        return url;
    }
}

#pragma mark - Lazy Load

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        self.emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}

@end
