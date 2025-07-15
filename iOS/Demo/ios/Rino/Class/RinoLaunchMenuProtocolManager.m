//
//  RinoLaunchMenuProtocolManager.m
//  Rino
//
//  Created by zhangstar on 2024/3/19.
//

#import "RinoLaunchMenuProtocolManager.h"
#import <MJExtension/MJExtension.h>
#import <RinoActivatorDefaultUISkin/RinoActivatorDefaultUISkin.h>
#import <RinoBizCore/RinoBizCore.h>
#import <RinoBusinessLibraryModule/RinoBusinessLibraryModule.h>
#import <RinoDebugKit/RinoDebugKit.h>
#import <RinoDeviceDetailDefaultUISkin/RinoDeviceDetailDefaultUISkin.h>
#import <RinoFoundationKit/RinoFoundationKit.h>
#import <RinoHomeDefaultUISkin/RinoHomeDefaultUISkin.h>
#import <RinoIPCKit/RinoIPCKit.h>
#import <RinoLibraryModule/RinoLibraryModule.h>
#import <RinoMessageDefaultUISKin/RinoMessageDefaultUISKin.h>
#import <RinoNFCKit/RinoNFCKit.h>
#import <RinoPanelKit/RinoPanelKit.h>
#import <RinoPanelContainerModule/RinoPanelContainerModule.h>
#import <RinoPanelContainerModule/RinoPanelDeviceViewController.h>
#import <RinoPanelContainerModule/RinoPanelGroupViewController.h>
#import <RinoProgressHUD/RinoProgressHUD.h>
#import <RinoScanBusinessKit/RinoScanBusinessKit.h>
#import <RinoSceneDefaultUISkin/RinoSceneDefaultUISkin.h>
#import <RinoUserSettingsDefaultUISkin/RinoUserSettingsDefaultUISkin.h>
#import <RinoUIKit/RinoUIKit.h>
#import <RinoWebViewKit/RinoWebViewKit.h>
#import <RinoScanBusinessKit/RinoScanBusinessManager.h>

@interface RinoLaunchMenuProtocolManager ()
<
RinoActivatorProtocol, 
RinoDeviceHomeProtocol,
RinoDeviceProtocol,
RinoLaunchMenuDefaultUISkinProtocol,
RinoLaunchMenuProtocol,
RinoMessageDefaultUISKinProtocol,
RinoMQTTProtocol,
RinoNFCProtocol,
RinoPanelProtocol,
RinoReceiveNotificationProtocol,
RinoThirdPartyVoiceProtocol,
RinoVoipPushProtocol,
RinoWebViewProtocol
>


@property (nonatomic, strong) NSString *homeId;

/// 常用功能View
@property (nonatomic, strong) RinoPanelOperationView *panelView;

//@property (nonatomic, strong) RinoLaunchMenuManager *manager;
/// 面板类
@property (nonatomic, strong) RinoPanelManager *panelManager;
/// 设备Model，配网成功后自动进入面板
@property (nonatomic, strong) RinoDeviceModel *deviceModel;
/// 群组Model，创建成功后自动进入面板
@property (nonatomic, strong) RinoGroupModel *groupModel;

//@property (nonatomic, strong) RinoLaunchMenuFileCache *fileCache;

@end

@implementation RinoLaunchMenuProtocolManager

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
        [sharedInstance registerProtocol];
        [sharedInstance registerNotification];
        [sharedInstance initBusinessMonitor];
    });
    return sharedInstance;
}
///更新家庭 id
-(void)updateHomeId:(NSString *)homeId{
    
    _homeId = homeId;
    
}
- (void)registerProtocol {
    RinoBizCore *bizCore = [RinoBizCore sharedInstance];
    [bizCore registerService:@protocol(RinoActivatorProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoDeviceHomeProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoDeviceProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoLaunchMenuDefaultUISkinProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoLaunchMenuProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoMessageDefaultUISKinProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoMQTTProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoNFCProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoPanelProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoReceiveNotificationProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoThirdPartyVoiceProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoVoipPushProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoWebViewProtocol) withInstance:self];
}

- (void)registerNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(gotoRnDistributionNetworkNoti:) name:@"RinoPushToRNDistributionNetworkNoti" object:nil];
}

- (void)initBusinessMonitor {
    [RinoReactNativeModuleManager sharedInstance];
    [RinoRNP2PBridgingModule sharedInstance];
    [RinoRNP2PBridgingModule_V2 sharedInstance];
    [RinoRNWebRTCBridgingModule sharedInstance];
}

#pragma mark - RinoActivatorProtocol

- (void)openScanWithHomeId:(NSString *)homeId {
    [[RinoScanBusinessManager sharedInstance] openScanViewControllerWithHomeId:self.homeId];
}

/// 跳转配网业务包
- (void)gotoActivatorBizWithHomeId:(NSString *)homeId {
    if (homeId.length == 0) return;
    
    [[RinoActivatorDefaultUISkinManager sharedInstance] gotoActivatorHomepageViewControllerWithHomeId:homeId];
}

/// 解析二维码数据
- (void)scanParsingQRCodeData:(NSString *)result homeId:(NSString *)homeId {
    [[RinoScanBusinessManager sharedInstance] scanParsingQRCodeData:result homeId:homeId];
}

#pragma mark - RinoDeviceHomeProtocol

/// 跳转设备面板
- (void)gotoDeviceViewControllerWithDeviceModel:(RinoDeviceModel * _Nonnull)deviceModel completion:(nullable void (^)(UIViewController * _Nullable panelViewController))completion {
    
    [self.panelManager getDevicePanelViewControllerWithDeviceModel:deviceModel
                                                        completion:^(__kindof UIViewController * _Nullable panelViewController) {
        if (completion) {
            completion(panelViewController);
        } else {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }
    }];
}

/// 跳转IPC分屏面板
- (void)gotoDeviceSplitScreenViewControllerWithParam:(NSDictionary *)param {
    [self.panelManager getFunctionPanelViewControllerWithParam:param completion:^(__kindof UIViewController * _Nullable panelViewController) {
        if (panelViewController) {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
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
            if ([vc isKindOfClass:[panelViewController class]]) break;
            
            [temp Rino_SafeAddObject:vc];
        }
        [temp Rino_SafeAddObject:panelViewController];
        [TopViewController().navigationController setViewControllers:temp.copy animated:YES];
    }];
}

/// 跳转群组面板
- (void)gotoGroupViewControllerWithGroupModel:(RinoGroupModel * _Nonnull)groupModel completion:(nullable void (^)(UIViewController * _Nullable panelViewController))completion {
    
    [self.panelManager getGrouopPanelViewControllerWithGroupModel:groupModel
                                                       completion:^(__kindof UIViewController * _Nullable panelViewController) {
        if (completion) {
            completion(panelViewController);
        } else {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }
    }];
}

/// 跳转消息播放视频面板
- (void)gotoMessagePalyVideoViewControllerWithDeviceModel:(RinoDeviceModel * _Nonnull)deviceModel messageModel:(RinoMessageModel * _Nonnull)messageModel completion:(nullable void (^)(UIViewController * _Nullable panelViewController))completion {
    NSDictionary *dict = [messageModel mj_JSONObject];
    [RinoPanelManager sharedInstance].parmStr = [dict mj_JSONString];
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeIpcMessagePlayback;
    [self gotoPanelViewController:deviceModel completion:completion];
}

/// 跳转消息播放视频面板（带跳转sd或者cloud标识）
- (void)gotoMessagePalyVideoViewControllerWithDeviceModel:(RinoDeviceModel * _Nonnull)deviceModel messageModel:(RinoMessageModel * _Nonnull)messageModel skipLocal:(BOOL)skipLocal completion:(nullable void (^)(UIViewController * _Nullable panelViewController))completion {
    NSDictionary *dict = [messageModel mj_JSONObject];
    [RinoPanelManager sharedInstance].parmStr = [dict mj_JSONString];
    if (skipLocal) {
        self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeSdMessage;
    }else{
        self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeCouldMessage;
    }
    [self gotoPanelViewController:deviceModel completion:completion];
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

-(void)gotoPanelMessageBackPlayViewControllerWithModel:(RinoDeviceModel *)deviceModel completion:(void (^)(UIViewController * _Nullable))completion{
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeIpcMessagePlayback;
    [self gotoPanelViewController:deviceModel completion:completion];
}

-(void)gotoPanelTodayBackPlayViewControllerWithModel:(RinoDeviceModel *)deviceModel completion:(void (^)(UIViewController * _Nullable))completion{
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeIpcTodayPlayback;
    [self gotoPanelViewController:deviceModel completion:completion];
}



/// 跳转面板sd卡消息
- (void)gotoIPCPanelSdMessgeView:(id)model callback:(nullable void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeSdMessage;
    [self gotoPanelViewController:model completion:callback];
}

/// 跳转面板来自他人分享
- (void)gotoIPCPanelShareFromView:(id)model callback:(void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeShareFrom;
    [self gotoPanelViewController:model completion:callback];
}
/// 跳转面板区域筛选
- (void)gotoIPCPanelAreaView:(id)model callback:(nullable void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeArea;
    [self gotoPanelViewController:model completion:callback];
}
/// 跳转IPC面板设备详情
- (void)gotoIPCPanelDeviceInfo:(id)model callback:(nullable void (^)(UIViewController * _Nullable))callback {
    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeDeviceInfo;
    [self gotoPanelViewController:model completion:callback];
}


#pragma mark - RinoLaunchMenuProtocol
/// 回到首页自动跳转设备面板
- (void)goBackHomepageAutoOpenDevicePanelWithDeviceId:(NSString *)deviceId {
    if (deviceId.length == 0) return;
    
    RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
    [self devicePairFinishedWithDeviceModel:device.deviceModel];
}

- (NSString *)getCurrenHomeId {
    return self.homeId;
}

///跳转到客户定制的页面（比如 eco的分享页面，跳转到 app 相册页面），直接在lauchch 实现跳转
-(void)gotoUserShareDeviceWithPage:(NSString *)page data:(id)data{
    if ([page isEqualToString:@"share_device"]) {
        //[[RinoLaunchMenuManager sharedInstance] gotoUserDeviceShare];
    }else if([page isEqualToString:@"device_album"]){
        NSArray *array = [data componentsSeparatedByString:@"?"];
        if (array.count >= 2) {
            NSString *arrayStr = [array Rino_SafeObjectAtIndex:1];
            NSArray *deviceIdArr = [arrayStr componentsSeparatedByString:@"="];
            if (deviceIdArr.count >= 2) {
                NSString *deviceId = [deviceIdArr Rino_SafeObjectAtIndex:1];
                RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
                [[RinoDeviceDetailManager sharedInstance] gotoDevicePhotoAlbumWithModel:device.deviceModel];
            }
            
        }
        
    }
    
    
}

#pragma mark - RinoMessageDefaultUISKinProtocol

- (void)messageProcessShareHomeWithShareId:(NSString *)shareId {
    if ([[RinoHomeDefaultUISkinManager sharedInstance] respondsToSelector:@selector(joinFamilyWithShareId:completion:)]) {
        [[RinoHomeDefaultUISkinManager sharedInstance] joinFamilyWithShareId:shareId
                                                                  completion:^(RinoHomeModel * _Nullable homeModel, RinoHomeStatus status, NSError * _Nullable error) {
            BOOL accept = NO;
            if (status == RinoHomeStatusAccept) {
                accept = YES;
            }
            
            id<RinoMessageDefaultUISKinReceiveProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoMessageDefaultUISKinReceiveProtocol)];
            [impl messageProcessShareDataWithReceive:accept error:error];
        }];
    }
}

- (void)messageProcessShareDeviceWithShareId:(NSString *)shareId {
    if ([[RinoDeviceDetailDefaultUISkinManager sharedInstance] respondsToSelector:@selector(showAddShareDeviceViewWithShareId:completion:)]) {
        [[RinoDeviceDetailDefaultUISkinManager sharedInstance] showAddShareDeviceViewWithShareId:shareId
                                                                                      completion:^(RinoDeviceModel * _Nullable deviceModel, RinoHomeStatus status, NSError * _Nullable error) {
            BOOL accept = NO;
            if (status == RinoHomeStatusAccept) {
                accept = YES;
            }
            
            id<RinoMessageDefaultUISKinReceiveProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoMessageDefaultUISKinReceiveProtocol)];
            [impl messageProcessShareDataWithReceive:accept error:error];
        }];
    }
}

- (void)messageProcessShareGroupWithShareId:(NSString *)shareId {
    if ([[RinoDeviceDetailDefaultUISkinManager sharedInstance] respondsToSelector:@selector(showAddShareGroupViewWithShareId:completion:)]) {
        [[RinoDeviceDetailDefaultUISkinManager sharedInstance] showAddShareGroupViewWithShareId:shareId
                                                                                     completion:^(RinoGroupModel * _Nullable groupModel, RinoHomeStatus status, NSError * _Nullable error) {
            BOOL accept = NO;
            if (status == RinoHomeStatusAccept) {
                accept = YES;
            }
            
            id<RinoMessageDefaultUISKinReceiveProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoMessageDefaultUISKinReceiveProtocol)];
            [impl messageProcessShareDataWithReceive:accept error:error];
        }];        
    }
}

#pragma mark - RinoMQTTProtocol

- (void)receiveMQTTWithData:(NSDictionary *)data topic:(NSString *)topic {
    NSString *code = [data StringForKey:@"code"];
    NSDictionary *dict = [data DictionaryForKey:@"data"];
    if ([code isEqualToString:@"sys_notice"]) {
        NSString *type = [dict StringForKey:@"type"];
        if ([type isEqualToString:@"homeShare"] || [type isEqualToString:@"deviceShare"]) {
            [[RinoMessageDefaultUISKinManager sharedInstance] gotoMessageViewControllerByShareType];
        }
    }
    
    id<RinoWebViewMQTTProtocol> impl1 = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoWebViewMQTTProtocol)];
    [impl1 receiveMQTTWithData:data topic:topic];
    
    id<RinoPanelMQTTProtocol> impl2 = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoPanelMQTTProtocol)];
    [impl2 receiveMQTTDataSendPanel:data];
}

#pragma mark - RinoNFCProtocol

- (void)startNFCWithUserActivity:(NSUserActivity *)userActivity {
    [[RinoNFCManager sharedInstance] setUserActivity:userActivity];
    [[RinoNFCManager sharedInstance] startBLEListening];
}

- (void)quickIconAwakeAppWithParam:(NSDictionary *)param {
    [[RinoNFCManager sharedInstance] setHomeScreenWithParam:param];
}

#pragma mark - RinoPanelProtocol

/// 获取面板配网控制器
- (__kindof UIViewController *)getPanelActivatorViewController {
    return [[RinoPanelContainerManager sharedInstance] getPanelActivatorViewController];
}

/// 获取设备面板控制器
- (__kindof UIViewController *)getPanelDeviceViewController {
    return [[RinoPanelContainerManager sharedInstance] getPanelDeviceViewController];
}

/// 获取设备功能面板控制器
- (__kindof UIViewController *)getFunctionPanelViewController {
    return [[RinoPanelContainerManager sharedInstance] getFunctionPanelViewController];
}

/// 获取群组面板控制器
- (__kindof UIViewController *)getPanelGroupViewController {
    return [[RinoPanelContainerManager sharedInstance] getPanelGroupViewController];
}

/// 获取Vest面板控制器
- (__kindof UIViewController *)getPanelVestViewController {
    return [[RinoPanelContainerManager sharedInstance] getPanelVestViewController];
}

/// 获取协同布防消息播放控制器
- (__kindof UIViewController *_Nullable)getPanelMessageVideoViewController {
    return [[RinoPanelContainerManager sharedInstance] getPanelMessageVideoViewController];
}

/// 获取设备面板名称
- (NSString *)getDevicePanelViewControllerClassName {
    return NSStringFromClass([RinoPanelDeviceViewController class]);
}

/// 获取设备详情控制器名称
- (NSString *)getDeviceDetailsViewControllerClassName {
    return [self.panelManager getDeviceDetailsViewControllerClassName];
}

/// 获取群组面板名称
- (NSString *)getGroupPanelViewControllerClassName {
    return NSStringFromClass([RinoPanelGroupViewController class]);
}

/// 获取群组详情控制器名称
- (NSString *)getGroupDetailsViewControllerClassName {
    return [self.panelManager getGroupDetailsViewControllerClassName];
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
    [[RinoPanelContainerManager sharedInstance] sendPanelNotify:notifyName data:data];
    if([notifyName isEqualToString:RinoPanelEmitterSystemPropertiesChange]){
        [[RinoWebRTCManager sharedInstance] networksChangesWithData:data];
    }
}

/// 设备信息发生改变
- (void)panelDeviceInfoUpdate:(NSDictionary *)data {
    [[RinoPanelContainerManager sharedInstance] deviceInfoUpdate:data];
}

/// 设备功能点发生改变
- (void)panelDeviceDpsUpdate:(NSArray *)dps {
    [[RinoPanelContainerManager sharedInstance] deviceDataPointUpdate:dps];
}

/// 网关子设备绑定结果通知
- (void)panelDeviceGatewayDeviceBindData:(NSArray *)devices {
    [[RinoPanelContainerManager sharedInstance] gatewayDeviceBindData:devices];
}

/// 初始化常用功能面板
- (void)initPanelOperationView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![RinoDebugManager sharedInstance].debugPanel) {
            BOOL isExist = NO;
            for (UIViewController *vc in TopViewController().navigationController.viewControllers) {
                NSString *vcName = NSStringFromClass([vc class]);
                if ([vcName isEqualToString:[self getDevicePanelViewControllerClassName]] ||
                    [vcName isEqualToString:[self getGroupPanelViewControllerClassName]]) {
                    isExist = YES;
                    break;
                }
            }
            
            if (!self.panelView && !isExist) {
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.panelView show];
            
            NSDictionary *data = @{@"id"           :deviceId?:@"",
                                   @"dataPointJson":deviceModel.stockDataPointData?:@[]};
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RinoNotificationPanelDeviceShortcut object:nil userInfo:data];
            });
        });
    }
}

/// 扫描二维码进入配网页
- (void)scanQRCodoOpenActivatorPanelViewControllerWithQRCodeResult:(NSString *)qrCodeResult productId:(NSString *)productId {
    [self.panelManager getActivatorPanelViewControllerWithQRCodeResult:qrCodeResult
                                                             productId:productId
                                                            completion:^(__kindof UIViewController * _Nullable panelViewController) {
        if (panelViewController) {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }
    }];
}

/// 手动配网进入配网页
- (void)openActivatorPanelViewControllerWithParam:(NSDictionary *)param {
    [self.panelManager getActivatorPanelViewControllerWithParam:param
                                                     completion:^(__kindof UIViewController * _Nullable panelViewController) {
        if (panelViewController) {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }
    }];
}

#pragma mark - RinoReceiveNotificationProtocol

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
//    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSDictionary *userInfo = notification.request.content.userInfo;
//        NSString *params = [userInfo StringForKey:@"params"];
//        NSDictionary *paramsDict = [params mj_JSONObject];
//        if (paramsDict.allKeys.count == 0) return;
//        
//        [self userNotificationWithParam:paramsDict];
//    }
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        NSString *params = [userInfo StringForKey:@"params"];
        NSDictionary *paramsDict = [params mj_JSONObject];
        if (paramsDict.allKeys.count == 0) return;
        [self userNotificationWithParam:paramsDict];
    }
}

-(void)userRemotePushNotiWithDict:(NSDictionary *)parm delay:(int)seconds{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((seconds ? : 0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self userNotificationWithParam:parm];
    });
}

#pragma mark Private

- (void)userNotificationWithParam:(NSDictionary *)param {
    NSString *position = [param StringForKey:@"position"];
    NSString *paramType = [param StringForKey:@"paramType"];
    if ([position isEqualToString:@"home"]) { // 首页
        UITabBarController *tabBarController = TopViewController().tabBarController;
        NSArray *vcs = tabBarController.viewControllers;
        NSInteger index = 0;
        for (NSInteger i = 0; i < vcs.count; i++) {
            RinoRootNavigationController *navController = (RinoRootNavigationController *)[vcs Rino_SafeObjectAtIndex:i];
            UIViewController *vc = [navController.viewControllers Rino_SafeObjectAtIndex:0];
            NSString *vcName = NSStringFromClass([vc class]);
            if ([[vcName lowercaseString] containsString:@"device"]) {
                index = i;
                break;
            }
        }
        tabBarController.selectedIndex = index;

        if ([paramType isEqualToString:@"device_call"]) {
            NSString *deviceId = [param StringForKey:@"deviceId"];
            RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
            if (device.deviceModel.uuid.length > 0) {
                [self gotoDevicePushNotiWithParam:param];
            }
        }
    } else if ([position isEqualToString:@"scene"]) { // 场景
        UITabBarController *tabBarController = TopViewController().tabBarController;
        NSArray *vcs = tabBarController.viewControllers;
        NSInteger index = 0;
        for (NSInteger i = 0; i < vcs.count; i++) {
            RinoRootNavigationController *navController = (RinoRootNavigationController *)[vcs Rino_SafeObjectAtIndex:i];
            UIViewController *vc = [navController.viewControllers Rino_SafeObjectAtIndex:0];
            NSString *vcName = NSStringFromClass([vc class]);
            if ([[vcName lowercaseString] containsString:@"scene"]) {
                index = i;
                break;
            }
        }
        tabBarController.selectedIndex = index;
    } else if ([position isEqualToString:@"event"]) { // 事件
        
    } else if ([position isEqualToString:@"cloud"]) { // 云存储
        
    } else if ([position isEqualToString:@"shop"]) { // 商城
        
    } else if ([position isEqualToString:@"customer"]) { // 客服
        
    } else if ([position isEqualToString:@"message"]) { // 消息中心
        [[RinoMessageDefaultUISKinManager sharedInstance] gotoMessageViewController];
    } else if ([position isEqualToString:@"device_panel"]) { // 设备面板
        NSString *deviceId = [param StringForKey:@"deviceId"];
        NSString *homeId = [param StringForKey:@"rootAssetId"];
        RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
        if (device.deviceModel.uuid.length > 0) {
            [self gotoDevicePushNotiWithParam:param];
        }
    } else if ([position isEqualToString:@"scan"]) { // 扫一扫
        [[RinoScanBusinessManager sharedInstance] openScanViewControllerWithHomeId:self.homeId];
    } else if ([position containsString:@"https://"] || [position containsString:@"http://"]) { // 自定义网址
        [[RinoWebViewManager sharedInstance] gotoUniversalLinkWithUrl:position title:@""];
    } else if ([position isEqualToString:@"share_message"]) { // 分享消息
        [[RinoMessageDefaultUISKinManager sharedInstance] gotoMessageViewControllerByShareType];
    } else {
        
    }
}

- (void)getHomeDetailWithHome:(RinoHome *)home deviceId:(NSString *)deviceId messageDict:(NSDictionary *)messageDict{
    
    [home getHomeDeviceListWithSuccess:^(NSArray<RinoDeviceModel *> * _Nonnull deviceList) {
        RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
        if(device.deviceModel.uuid.length > 0 ){
            [self gotoDevicePushNotiWithParam:messageDict];
        }
        
    } failure:^(NSError *error) {
       
    }];
}

- (void)getHomeListHomeId:(NSString *)homeId deviceId:(NSString *)deviceId messageDict:(NSDictionary *)messageDict{
    RinoHomeManager *homeManager = [[RinoHomeManager alloc] init];
    [homeManager getHomeListWithSuccess:^(NSArray<RinoHomeModel *> * _Nonnull homes) {
        RinoHome *home = [RinoHome homeWithHomeId:homeId];
        if(home.homeModel){
            [self getHomeDetailWithHome:home deviceId:deviceId messageDict:messageDict];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)gotoDevicePushNotiWithParam:(NSDictionary *)param {
    NSString *deviceId = [param StringForKey:@"deviceId"];
    NSString *paramType = [param StringForKey:@"paramType"];
    RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
    if ([paramType isEqualToString:@"device_call"]) {//ipc设备的呼叫
        if (([RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypeListenVideo || [RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypeListenVideo) && [[RinoPanelManager sharedInstance].deviceModel.deviceId isEqualToString:deviceId]) {///当前设备正在语音通话
            
        }else{
            [TopViewController().navigationController popToRootViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeListenVideo;
                [[RinoIpcVideoOrVoicePushTool sharedInstance] rinoPushIpcVideoOrVoiceMessageWithData:param callblock:^(NSDictionary *data) {
                    [RinoPanelManager sharedInstance].parmStr = [data mj_JSONString];
                    self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeIpcMessagePlayback;
                    [self gotoPanelViewController:device.deviceModel completion:^(UIViewController * _Nonnull viewController) {
                        if (viewController) {
                            [TopViewController().navigationController pushViewController:viewController animated:YES];
                        }
                    }];
                    
                }];
            });
        }
        
    }else{
        [TopViewController().navigationController popToRootViewControllerAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self gotoPanelViewController:device.deviceModel completion:^(UIViewController * _Nonnull viewController) {
                if (viewController) {
                    [TopViewController().navigationController pushViewController:viewController animated:YES];
                }
            }];
        });
        
    }
}

#pragma mark - RinoWebViewProtocol

- (void)gotoWebViewControllerWithUrl:(NSString *)url {
    [[RinoWebViewManager sharedInstance] gotoUniversalLinkWithUrl:url title:@""];
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
    [[RinoBLEManager sharedInstance] stopListening:YES];
    [[RinoBLEManager sharedInstance] setDelegate:nil];
    
    NSDictionary *dict = noti.userInfo;
    [[RinoPanelManager sharedInstance] getActivatorPanelViewControllerWithData:dict
                                                             completionHandler:^(__kindof UIViewController * _Nullable panelViewController, NSError * _Nullable error) {
        [RinoProgressHUD hideHUDView];
        
        if (error) {
            [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
        } else {
            [TopViewController().navigationController pushViewController:panelViewController animated:YES];
        }
    }];
}




- (RinoPanelManager *)panelManager {
    _panelManager = [RinoPanelManager sharedInstance];
    return _panelManager;
}

@end
