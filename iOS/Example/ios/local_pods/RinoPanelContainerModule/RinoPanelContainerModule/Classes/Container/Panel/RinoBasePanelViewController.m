//
//  RinoBasePanelViewController.m
//  Rino
//
//  Created by zhangstar on 2022/11/15.
//

#import "RinoBasePanelViewController.h"

#import <Masonry/Masonry.h>
#import <RinoBizCore/RinoBizCore.h>
#import <RinoDebugKit/RinoDebugKit.h>

#import "RinoIPCModule.h"

@interface RinoBasePanelViewController ()<RCTBridgeDelegate>

@property (nonatomic, assign) BOOL landscape;

@end

@implementation RinoBasePanelViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[RinoPanelViewModel sharedInstance] leavePanel];
    [[RinoIpcRNFunctionModul sharedInstance] destructionInstance];
    [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeNone;
    [RinoIpcRNFunctionModul sharedInstance].inVideoVoice = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [RinoReactNativeModuleManager sharedInstance];
    
    [self.emitter sendPanelNotify:RinoPanelEmitterRNContainerFocusChange data:@{@"type":@"viewWillAppear"}];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.enablePopGesture = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[RinoIPCModule new] snapshot];
    
    [self.emitter sendPanelNotify:RinoPanelEmitterRNContainerFocusChange data:@{@"type":@"viewDidDisappear"}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (Theme().styleMode == RinoStyleModeLight) {
        self.view.backgroundColor = Theme().B2;
    } else {
        self.view.backgroundColor = Theme().B1;
    }

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

#pragma mark - Public

- (void)initUIWithProperties:(NSDictionary *)properties {
    [self registerNotification];
    self.bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    self.rootView = [[RCTRootView alloc] initWithBridge:self.bridge
                                             moduleName:@"RinoRCTApp"
                                      initialProperties:properties];
    self.rootView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.rootView];
}

#pragma mark - Private

- (void)registerNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    ///监听屏幕横竖屏
    [center addObserver:self selector:@selector(rinoPanelScreenChange:) name:RinoSetScreenDirectionChangeNoti object:nil];
    [center addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [center addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // 添加方向变化的通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(orientationDidChange:)
                                                        name:UIDeviceOrientationDidChangeNotification
                                                      object:nil];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenChangeSuccessNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionPortrait}];
            [self orientationChange:NO];
        } else if (type == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenChangeSuccessNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionLandscape}];
            [self orientationChange:YES];
        }
    }
}

- (void)orientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSDictionary *orientationDict ;
    switch (orientation) {
        case UIDeviceOrientationUnknown:
            NSLog(@"设备方向未知");
            break;
        case UIDeviceOrientationPortrait:
            NSLog(@"设备直立，Home 按钮在下");
//            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenDirectionChangeNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionPortrait}];
            orientationDict = @{@"key" :@"gyroDirection",
                                   @"data":@{@"orientation":@(0)}};
            [[RinoEmitterModule new] sendPanelNotify:RinoPanelEmitterCommonBusiness data:[orientationDict mj_JSONString]];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"设备直立，Home 按钮在上");
//            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenDirectionChangeNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionPortrait}];
            orientationDict = @{@"key" :@"gyroDirection",
                                   @"data":@{@"orientation":@(0)}};
            [[RinoEmitterModule new] sendPanelNotify:RinoPanelEmitterCommonBusiness data:[orientationDict mj_JSONString]];
            break;
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"设备横向，Home 按钮在右");
//            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenDirectionChangeNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionLandscape}];
            orientationDict = @{@"key" :@"gyroDirection",
                                   @"data":@{@"orientation":@(1)}};
            [[RinoEmitterModule new] sendPanelNotify:RinoPanelEmitterCommonBusiness data:[orientationDict mj_JSONString]];
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"设备横向，Home 按钮在左");
//            [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenDirectionChangeNoti object:nil userInfo:@{@"Orentation" : RinoSetScreenDirectionLandscape}];
            orientationDict = @{@"key" :@"gyroDirection",
                                   @"data":@{@"orientation":@(1)}};
            [[RinoEmitterModule new] sendPanelNotify:RinoPanelEmitterCommonBusiness data:[orientationDict mj_JSONString]];
            break;
        case UIDeviceOrientationFaceUp:
            NSLog(@"设备平放，屏幕朝上");
            break;
        case UIDeviceOrientationFaceDown:
            NSLog(@"设备平放，屏幕朝下");
            break;
        default:
            break;
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

#pragma mark - Lazy Load

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        _emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}

@end
