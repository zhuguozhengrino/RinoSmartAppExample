//
//  RinoBasePanelViewController.m
//  Rino
//
//  Created by zhangstar on 2022/11/15.
//

#import "RinoBasePanelViewController.h"

#import <RinoBizCore/RinoBizCore.h>
#import <RinoDebugKit/RinoDebugKit.h>
#import <RinoIPCKit/RinoIPCKit.h>
#import "RCTVLCVideoManager.h"
#import "RinoIPCModule.h"
#import "RinoRNP2PBridgingModule.h"
@interface RinoBasePanelViewController ()<RCTBridgeDelegate>

@property (nonatomic, assign) BOOL landscape;

@end

@implementation RinoBasePanelViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[RCTVLCVideoManager sharedInstance] removePlayer];
    [[RinoPanelViewModel sharedInstance] leavePanel];
    [[RinoIpcRNFunctionModul sharedInstance] destructionInstance];
    [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeNone;
    [RinoIpcRNFunctionModul sharedInstance].inVideoVoice = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [RinoReactNativeModuleManager sharedInstance];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[RinoIPCModule new] snapshot];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///监听屏幕横竖屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rinoPanelScreenChange:) name:RinoSetScreenDirectionChangeNoti object:nil];

    [RinoPanelManager sharedInstance].autoJoinPanel = NO;
    
    id<RinoPanelProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoPanelProtocol)];
    [impl deallocPanelOperationView];
        
    [self getData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initUIWithProperties:(NSDictionary *)properties {
    self.bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    self.rootView = [[RCTRootView alloc] initWithBridge:self.bridge
                                             moduleName:@"RinoRCTApp"
                                      initialProperties:properties];
    self.rootView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rootView];
}

- (void)getData {
    RinoDeviceModel *deviceModel = [RinoPanelManager sharedInstance].deviceModel;
    if (deviceModel) {
        RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceModel.deviceId];
        [device getDeviceDpList:^(RinoDeviceModel * _Nonnull deviceModel) {
            NSDictionary *dps = deviceModel.dataPointValue;
            if (dps.count > 0) {
                NSArray *data = @[@{@"deviceId"  :deviceModel.deviceId?:@"",
                                    @"properties":dps}];
                [self.emitter deviceDataPointUpdate:data];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - RCTBridgeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    // 加载项目本地面板
//    NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"index.ios" ofType:@"bundle"]];
//    return url;
    if ([RinoDebugManager sharedInstance].debugPanel == YES) {
        NSString *ip = [RinoDebugManager sharedInstance].debugPanelIP?:@"";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index.bundle?platform=ios&dev=true", ip]];
        return url;
    } else {
        NSString *filePath = [[RinoPanelManager sharedInstance] getPanelFilePath];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        return url;
    }
}

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
            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenChangeSuccessNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionPortrait}];
            [self orientationChange:NO];
        } else if (type == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenChangeSuccessNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionLandscape}];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenChangeSuccessNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionLandscape}];
            return UIInterfaceOrientationMaskLandscape;
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenChangeSuccessNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionPortrait}];
            return UIInterfaceOrientationMaskPortrait;
        }
    } else {
        
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

#pragma mark - Lazy Load

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        _emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}

@end
