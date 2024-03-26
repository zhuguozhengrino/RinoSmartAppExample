//
//  RinoSmartBusinessManager.m
//  Rino
//
//  Created by zhangstar on 2023/7/11.
//

#import "RinoSmartBusinessManager.h"
#import "RinoRNP2PBridgingModule.h"
#import "RinoEmitterModule.h"

#import "RinoActivatorPanelViewController.h"
#import "RinoPanelDeviceViewController.h"
#import "RinoPanelGroupViewController.h"
#import "RinoPanelOperationView.h"

#import <RinoBizCore/RinoBizCore.h>
#import <RinoDebugKit/RinoDebugKit.h>
#import <RinoLaunchMenuKit/RinoLaunchMenuKit.h>
#import <RinoNFCKit/RinoNFCKit.h>
#import <RinoProgressHUD/RinoProgressHUD.h>
#import <RinoPanelKit/RinoPanelKit.h>

@interface RinoSmartBusinessManager ()<RinoDeviceHomeProtocol, RinoDeviceProtocol, RinoNFCProtocol, RinoPanelProtocol>

/// 常用功能View
@property (nonatomic, strong) RinoPanelOperationView *panelView;

/// 面板类
@property (nonatomic, strong) RinoPanelManager *panelManager;
/// 面板通知类
@property (nonatomic, strong) RinoEmitterModule *emitter;
/// 设备Model，配网成功后自动进入面板
@property (nonatomic, strong) RinoDeviceModel *deviceModel;
/// 群组Model，创建成功后自动进入面板
@property (nonatomic, strong) RinoGroupModel *groupModel;

@end

@implementation RinoSmartBusinessManager

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        [sharedInstance registerNotification];
    });
    return sharedInstance;
}

#pragma mark - Init

- (void)registerNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(gotoRnDistributionNetworkNoti:) name:@"RinoPushToRNDistributionNetworkNoti" object:nil];
}

#pragma mark - Public

- (void)registerProtocol {
    RinoBizCore *bizCore = [RinoBizCore sharedInstance];
    [bizCore registerService:@protocol(RinoDeviceHomeProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoDeviceProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoNFCProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoPanelProtocol) withInstance:self];
}

/// 初始化监听
- (void)initBusinessMonitor {
    [RinoRNP2PBridgingModule sharedInstance];
}

#pragma mark - RinoDeviceHomeProtocol

/// 跳转设备面板
- (void)gotoDeviceViewControllerWithDeviceModel:(RinoDeviceModel * _Nonnull)deviceModel completion:(nullable void (^)(UIViewController * _Nullable panelViewController))completion {
    
    [self.panelManager getPanelViewControllerWithDeviceModel:deviceModel
                                           completionHandler:^(__kindof UIViewController * _Nullable panelViewController, NSError * _Nullable error) {
        [RinoProgressHUD hideHUDView];
        if (completion) {
            completion(panelViewController);
        } else {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }

        if (error) {
            [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
        }
    }];
}

/// 跳转设备详情
- (void)gotoDeviceDetailsViewControllerWithDeviceModel:(RinoDeviceModel * _Nonnull)deviceModel {
    [self.panelManager getPanelDetailsViewControllerWithDeviceModel:deviceModel
                                                  completionHandler:^(__kindof UIViewController * _Nullable panelViewController) {
        NSArray *vcs = TopViewController().navigationController.viewControllers;
        NSMutableArray *temp = [NSMutableArray array];
        for (id vc in vcs) {
            if ([vc isKindOfClass:[panelViewController class]]) {
                break;
            }

            [temp SafeAddObject:vc];
        }
        [temp SafeAddObject:panelViewController];

        [TopViewController().navigationController setViewControllers:temp.copy animated:YES];
    }];
}

/// 跳转群组面板
- (void)gotoGroupViewControllerWithGroupModel:(RinoGroupModel * _Nonnull)groupModel completion:(nullable void (^)(UIViewController * _Nullable panelViewController))completion {
    [RinoProgressHUD showHUDView];
    [self.panelManager getPanelViewControllerWithGroupModel:groupModel
                                          completionHandler:^(__kindof UIViewController * _Nullable panelViewController, NSError * _Nullable error) {
        [RinoProgressHUD hideHUDView];

        if (completion) {
            completion(panelViewController);
        } else {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }

        if (error) {
            [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
        }
    }];
}

/// 将要执行NFC
- (void)willStartNFCWithHomeId:(NSString *)homeId deviceList:(NSArray<RinoDeviceModel *> *)deviceList {
    // 检测NFC状态
    RinoNFCManager *nfcManager = [RinoNFCManager sharedInstance];
    if (nfcManager.state == RinoNFCStateStartNFC) {
        nfcManager.homeId = homeId;
        nfcManager.deviceList = deviceList;
        [nfcManager startNFC];
    }
}

/// 编辑群组信息后，面板信息将要更新
- (void)editGroupModelInfoWithGroupModel:(RinoGroupModel * _Nonnull)groupModel {
    self.panelManager.groupModel = groupModel;
}

/// 创建群组
- (void)createGroupWithGroupModel:(RinoGroupModel * _Nonnull)groupModel {
    self.panelManager.autoJoinPanel = YES;
    self.panelManager.groupModel = groupModel;
}

/// 跳转面板的ipc相册
- (void)gotoIPCPanelAlbumView:(id)model callback:(void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeAlbum;
    [self gotoPanelViewController:model completion:callback];
}

/// 跳转面板的ipc回放
- (void)gotoIPCPanelPlayBackView:(id)model callback:(void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypePlayback;
    [self gotoPanelViewController:model completion:callback];
}

/// 跳转面板的ipc回放
- (void)gotoIPCPanelMessageView:(id)model callback:(void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeMessage;
    [self gotoPanelViewController:model completion:callback];
}

/// 跳转面板的ipc视频接听
- (void)gotoIPCPanelListeningVideoView:(id)model callback:(void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeListenVideo;
    [self gotoPanelViewController:model completion:callback];
}

/// 跳转面板的ipc语音接听
- (void)gotoIPCPanelListeningVoiceView:(id)model callback:(void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeListenVoice;
    [self gotoPanelViewController:model completion:callback];
}

/// 跳转面板的设置页面
- (void)gotoIPCPanelSettingView:(id)model callback:(void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeSetting;
    [self gotoPanelViewController:model completion:callback];
}

#pragma mark - RinoDeviceProtocol

- (void)getDeviceGroupListWithHomeId:(NSString *)homeId viewControllerClassName:(NSString *)viewControllerClassName {
    if (homeId.length == 0) return;
    
    NSString *topViewControllerClassName = NSStringFromClass([[TopViewController().navigationController.viewControllers lastObject] class]);
    if ([topViewControllerClassName isEqualToString:viewControllerClassName]) {
        RinoHome *home = [RinoHome homeWithHomeId:homeId];
        id model;
        if (self.deviceModel) {
            for (RinoDeviceModel *deviceModel in home.deviceList) {
                if ([self.deviceModel.deviceId isEqualToString:deviceModel.deviceId]) {
                    model = deviceModel;
                    break;
                }
            }
        } else if (self.groupModel) {
            for (RinoGroupModel *groupModel in home.groupList) {
                if ([self.groupModel.groupId isEqualToString:groupModel.groupId]) {
                    model = groupModel;
                    break;
                }
            }
        }
        
        if (model) {
            [self gotoPanelViewController:model
                               completion:^(UIViewController * _Nonnull viewController) {
                self.deviceModel = nil;
                self.groupModel = nil;

                if (viewController) {
                    [TopViewController().navigationController pushViewController:viewController animated:YES];
                }
            }];
        }
    }
}

/// 设备配网成功
- (void)devicePairFinishedWithDeviceModel:(RinoDeviceModel *)deviceModel {
    if (!self.deviceModel) {
        self.deviceModel = deviceModel;
        self.groupModel = nil;
    }
}

/// 设备群组创建成功
- (void)devicePairFinishedWithGroupModel:(RinoGroupModel *)groupModel {
    if (!self.groupModel) {
        self.deviceModel = nil;
        self.groupModel = groupModel;
    }
}

#pragma mark - RinoPanelProtocol

/// 获取面板配网控制器
- (__kindof UIViewController *)getPanelActivatorViewController {
    RinoActivatorPanelViewController *panelActivatorVC = [[RinoActivatorPanelViewController alloc] init];
    return panelActivatorVC;
}

/// 获取设备面板控制器
- (__kindof UIViewController *)getPanelDeviceViewController {
    RinoPanelDeviceViewController *panelVC = [[RinoPanelDeviceViewController alloc] init];
    return panelVC;
}

/// 获取群组面板控制器
- (__kindof UIViewController *)getPanelGroupViewController {
    RinoPanelGroupViewController *panelVC = [[RinoPanelGroupViewController alloc] init];
    return panelVC;
}

/// 获取设备面板名称
- (NSString *)getDevicePanelViewControllerClassName {
    return NSStringFromClass([RinoPanelDeviceViewController class]);
}

/// 获取群组面板名称
- (NSString *)getGroupPanelViewControllerClassName {
    return NSStringFromClass([RinoPanelGroupViewController class]);
}

/// 获取当前面板设备Model
- (RinoDeviceModel *)getCurrentPanelDeviceModel {
    return self.panelManager.deviceModel;
}

- (RinoGroupModel *)getCurrentPanelGroupModel {
    return self.panelManager.groupModel;
}

/// 发送面板通知
- (void)sendPanelNotify:(NSString *)notifyName data:(id)data {
    [self.emitter sendPanelNotify:notifyName data:data];
}

/// 设备信息发生改变
- (void)panelDeviceInfoUpdate:(NSDictionary *)data {
    [self.emitter deviceInfoUpdate:data];
}

/// 设备功能点发生改变
- (void)panelDeviceDpsUpdate:(NSArray *)dps {
    [self.emitter deviceDataPointUpdate:dps];
}

/// 网关子设备绑定结果通知
- (void)panelDeviceGatewayDeviceBindData:(NSArray *)devices {
    [self.emitter gatewayDeviceBindData:devices];
}

/// 初始化常用功能面板
- (void)initPanelOperationView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![RinoDebugManager sharedInstance].debugPanel) {
            BOOL isExist = NO;
            for (id vc in TopViewController().navigationController.viewControllers) {
                if ([vc isKindOfClass:[RinoBasePanelViewController class]]) {
                    isExist = YES;
                    break;
                }
            }
            
            if (!self.panelView && isExist == NO) {
                self.panelView = [[RinoPanelOperationView alloc] init];
            }
        }
    });
}

/// 销毁常用功能面板
- (void)deallocPanelOperationView {
    if (self.panelView) {
        [self.panelView deallocPanelView];
        [self.panelView removeFromSuperview];
        self.panelView = nil;
    }
}

/// 展示常用功能面板
- (void)showPanelOperationViewWithDeviceId:(NSString *)deviceId {
    RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
    RinoDeviceModel *deviceModel = device.deviceModel;
    [RinoPanelManager sharedInstance].deviceModel = deviceModel;

    if (deviceModel) {
        if (!self.panelView) {
            self.panelView = [[RinoPanelOperationView alloc] init];
        }
        [self.panelView show];
        
        NSDictionary *data = @{@"id"           :deviceId,
                               @"dataPointJson":deviceModel.stockDpInfoVOList?:@[]};

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:RinoNotificationPanelDeviceShortcut object:nil userInfo:data];
        });
    }
}

#pragma mark - Private

/// 跳转面板
- (void)gotoPanelViewController:(id)model completion:(nullable void (^)(UIViewController * _Nonnull viewController))completion {
    if ([model isKindOfClass:[RinoDeviceModel class]]) {
        [self gotoDeviceViewControllerWithDeviceModel:model completion:completion];
    } else if ([model isKindOfClass:[RinoGroupModel class]]) {
        [self gotoGroupViewControllerWithGroupModel:model completion:completion];
    }
}

#pragma mark - Notification

- (void)gotoRnDistributionNetworkNoti:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    [[RinoPanelManager sharedInstance] getActivatorPanelViewControllerWithData:dict
                                                             completionHandler:^(__kindof UIViewController * _Nullable panelViewController, NSError * _Nullable error) {
        [RinoProgressHUD hideHUDView];
        
        if (error) {
            [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
        } else {
            NSString *viewControllerStr = NSStringFromClass([panelViewController class]);
            if ([viewControllerStr isEqualToString:@"RinoActivatorPanelViewController"]) {
                RinoActivatorPanelViewController *panelvc = (RinoActivatorPanelViewController *)panelViewController;
                panelvc.activatorData = dict;
                panelViewController = panelvc;
            }
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }
    }];
}

#pragma mark - Lazy Load

- (RinoPanelManager *)panelManager {
    _panelManager = [RinoPanelManager sharedInstance];
    return _panelManager;
}

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        _emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}

@end
