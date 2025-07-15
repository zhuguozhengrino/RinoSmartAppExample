//
//  RinoBasicPanelViewController.m
//  Rino
//
//  Created by zhangstar on 2024/1/17.
//

#import "RinoBasicPanelViewController.h"
#import "RinoIPCModule.h"

#import <RinoBizCore/RinoBizCore.h>
#import <RinoBusinessLibraryModule/RinoPermissionKit.h>
#import <RinoIPCKit/RinoIPCKit.h>

NSString *RinoPanelModuleNameDevicePanel    = @"RinoRCTApp";
NSString *RinoPanelModuleNameActivatorPanel = @"RinoRCTConfigNetwork";
NSString *RinoPanelModuleNameVestPanel      = @"RinoRCTVestApp";

@interface RinoBasicPanelViewController ()<RCTBridgeDelegate>

@property (nonatomic, strong) NSString *moduleName;
@property (nonatomic, strong) NSDictionary *properties;
@property (nonatomic, assign) BOOL landscape;
@property (nonatomic, assign) BOOL needReloadJS;

@end

@implementation RinoBasicPanelViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.panelManager.deviceModel.isIpc) {
        self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeNone;
        
        [[RinoIpcRNFunctionModul sharedInstance] destructionInstance];
        [RinoIpcRNFunctionModul sharedInstance].inVideoVoice = NO;
    }
    
    [[RinoPanelViewModel sharedInstance] leavePanel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (self.needReloadJS) {
        self.needReloadJS = NO;
        
        if (![self.bridge isBatchActive]) {
            [self.bridge onFastRefresh];
        }
    }
    
    [self.emitter sendPanelNotify:RinoPanelEmitterRNContainerFocusChange data:@{@"type":@"viewWillAppear"}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.enablePopGesture = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.emitter sendPanelNotify:RinoPanelEmitterRNContainerFocusChange data:@{@"type":@"viewDidDisappear"}];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSInteger count = 0;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[RinoBasicPanelViewController class]]) {
            count++;
        }
    }
    if (count == 2) {
        self.needReloadJS = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initUI];
    [self setData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Public

- (void)initPanelWithModuleName:(NSString *)moduleName properties:(NSDictionary *)properties {
    if (!moduleName) {
        moduleName = @"";
    }
    if (!properties) {
        properties = @{};
    }
    self.moduleName = moduleName;
    self.properties = properties;
    
    [self registerNotification];
    [self initPanelUI];
}

- (void)sendPanelNotify:(NSString *)notifyName data:(id)data {
    [self.emitter sendPanelNotify:notifyName data:data];
}

- (void)hideLoadingView {
    [UIView animateWithDuration:0.5
                     animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        self.loadingView.hidden = YES;
    }];
}

#pragma mark - Private

- (void)initUI {
    if (Theme().styleMode == RinoStyleModeLight) {
        self.view.backgroundColor = Theme().B2;
    } else {
        self.view.backgroundColor = HexString(@"#010101");
    }
    
    self.loadingView = [[RinoBasicPanelLoadingView alloc] init];
    self.loadingView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.loadingView];
}

- (void)initPanelUI {
    self.bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    self.rootView = [[RCTRootView alloc] initWithBridge:self.bridge
                                             moduleName:self.moduleName
                                      initialProperties:self.properties];
    self.rootView.backgroundColor = self.view.backgroundColor;
    [self.view insertSubview:self.rootView belowSubview:self.loadingView];
    
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setData {
    [RinoPanelManager sharedInstance].autoJoinPanel = NO;
    
    id<RinoPanelProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoPanelProtocol)];
    if (impl && [impl respondsToSelector:@selector(deallocPanelOperationView)]) {
        [impl deallocPanelOperationView];
    }
}

/// 注册通知
- (void)registerNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 监听屏幕横竖屏
    [center addObserver:self selector:@selector(rinoPanelScreenChange:) name:RinoSetScreenDirectionChangeNoti object:nil];
    [center addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [center addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    if ([self.moduleName isEqualToString:RinoPanelModuleNameActivatorPanel]) { // 配网面板
        [center addObserver:self selector:@selector(setWiFiInfo) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}

- (void)setWiFiInfo {
    NSString *ssid = [[RinoPermissionManager sharedInstance] currentWifiSSID]?:@"";
    [self.emitter sendPanelNotify:RinoPanelEmitterSystemWifiChange data:ssid];
}

#pragma mark - Notification Method

- (void)rinoPanelScreenChange:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *orentation = [notification.userInfo StringForKey:@"Orentation"];
        if ([orentation isEqualToString:RinoSetScreenDirectionPortrait]) {
            [self setScreenOrentationType:1];
        } else if ([orentation isEqualToString:RinoSetScreenDirectionReverse_Portrait]) {
            [self setScreenOrentationType:1];
        } else if ([orentation isEqualToString:RinoSetScreenDirectionLandscape]) {
            [self setScreenOrentationType:2];
        } else if ([orentation isEqualToString:RinoSetScreenDirectionReverse_Landscape]) {
            [self setScreenOrentationType:2];
        } else if ([orentation isEqualToString:RinoSetScreenDirectionAuto_rotate]) {
            
        }
    });
}

- (void)willEnterForeground:(NSNotification *)notification {
    NSDictionary *data = @{@"key" :@"appInFocused",
                           @"data":@{@"isFocused":[NSNumber numberWithBool:YES],
                                     @"reason"   :@(0)}};
    [self.emitter sendPanelNotify:RinoPanelEmitterCommonBusiness data:[data mj_JSONString]];
}

- (void)didEnterBackground:(NSNotification *)notification {
    NSDictionary *data = @{@"key" :@"appInFocused",
                           @"data":@{@"isFocused":[NSNumber numberWithBool:NO],
                                     @"reason"   :@(1)}};
    [self.emitter sendPanelNotify:RinoPanelEmitterCommonBusiness data:[data mj_JSONString]];
}

#pragma mark - RCTBridgeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    NSString *debugIPAddress = @"";
    NSString *filePath = @"";
    if ([self.moduleName isEqualToString:RinoPanelModuleNameDevicePanel]) {
        if (self.debugManager.debugPanel) {
            debugIPAddress = self.debugManager.debugPanelIP?:@"";
        } else {
            filePath = [self.panelManager getPanelFilePath];
        }
    } else if ([self.moduleName isEqualToString:RinoPanelModuleNameActivatorPanel]) {
        if (self.debugManager.debugPanel) {
            debugIPAddress = self.debugManager.debugPanelIP?:@"";
        } else {
            filePath = [self.panelManager getActivatorPanelFilePath];
        }
    } else if ([self.moduleName isEqualToString:RinoPanelModuleNameVestPanel]) {
//        if (self.debugManager.debugPanel) {
//            debugIPAddress = self.debugManager.debugPanelIP?:@"";
//        } else {
            filePath = [self.panelManager getVestPanelFilePath];
//        }
    }
    NSURL *url;
    if (filePath.length > 0) {
        url = [NSURL fileURLWithPath:filePath];
    } else if (debugIPAddress.length > 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index.bundle?platform=ios&dev=true", debugIPAddress]];
    }
    return url;
}

#pragma mark - Screen Orentation

- (void)setScreenOrentationType:(NSInteger)type {
    if (@available(iOS 16.0, *)) {
        if (type == 1) {
            self.landscape = NO;
            [self setNeedsUpdateOfSupportedInterfaceOrientations];
        } else if (type == 2) {
            self.landscape = YES;
            [self setNeedsUpdateOfSupportedInterfaceOrientations];
        }
    } else {
        if (type == 1) {
            [self sendOrientationNotify:RinoSetScreenDirectionPortrait];
            [self orientationChange:NO];
        } else if (type == 2) {
            [self sendOrientationNotify:RinoSetScreenDirectionLandscape];
            [self orientationChange:YES];
        }
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (@available(iOS 16.0, *)) {
        if (self.landscape) {
            [self sendOrientationNotify:RinoSetScreenDirectionLandscape];
            return UIInterfaceOrientationMaskLandscape;
        } else {
            [self sendOrientationNotify:RinoSetScreenDirectionPortrait];
            return UIInterfaceOrientationMaskPortrait;
        }
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)orientationChange:(BOOL)landscapeRight {
    if (landscapeRight) {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.bounds = CGRectMake(0, 0, kScreenWidth(), kScreenHeight());
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            self.view.bounds = CGRectMake(0, 0, kScreenWidth(), kScreenHeight());
        }];
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)sendOrientationNotify:(NSString *)orentation {
    [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenChangeSuccessNoti object:nil userInfo:@{@"Orentation":orentation?:@""}];
}

#pragma mark - Lazy Load

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageStr;
        if (Theme().styleMode == RinoStyleModeDark) {
            imageStr = @"rino_icon_back_dark";
        }else{
            imageStr = @"rino_icon_back_light";
        }
        [_backBtn setImage:[UIImage RinoPanelContainerImageNamed:imageStr] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden = YES;
        [self.view addSubview:_backBtn];
        
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.top.equalTo(self.view).offset(kStatusBarHeight());
        }];
    }
    return _backBtn;
}

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        _emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}

- (RinoDebugManager *)debugManager {
    _debugManager = [RinoDebugManager sharedInstance];
    return _debugManager;
}

- (RinoPanelManager *)panelManager {
    _panelManager = [RinoPanelManager sharedInstance];
    return _panelManager;
}

@end
