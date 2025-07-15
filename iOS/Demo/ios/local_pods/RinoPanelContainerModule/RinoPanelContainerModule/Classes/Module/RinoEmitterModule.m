//
//  RinoEmitterModule.m
//  Rino
//
//  Created by zhangstar on 2022/9/7.
//

#import "RinoEmitterModule.h"

@implementation RinoEmitterModule

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
        [sharedInstance registerNofitication];
    });
    return sharedInstance;
}

- (void)registerNofitication {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(deviceShortcutDataNotify:) name:RinoNotificationPanelDeviceShortcut object:nil];
    [center addObserver:self selector:@selector(setScreenChangeSuccessNoti:) name:RinoSetScreenChangeSuccessNoti object:nil];
    [center addObserver:self selector:@selector(deviceCommonCmdResp:) name:RinoNotificationDeviceCommonCmdResp object:nil];
    [center addObserver:self selector:@selector(deviceIPCTokenUse:) name:RinoNotificationDeviceIPCTokenUse object:nil];
    [center addObserver:self selector:@selector(deviceGatWayFind:) name:RinoNotificationDeviceGatWayFind object:nil];
    [center addObserver:self selector:@selector(deviceSendMqttToRn:) name:RinoNotificationDeviceMqttMsgSendRN object:nil];
    [center addObserver:self selector:@selector(commonBusinessSendToRn:) name:RinoNotificationCommonBusinessSendRN object:nil];
}

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return [self emitterNotifyWhiteList];
}

#pragma mark - Public

/// 设备dp点发生改变
- (void)deviceDataPointUpdate:(NSArray *)data {
    NSLog(@"面板收到设备DP点发生改变:\n%@", data);
    [self panelDeviceDataPointUpdate:data];
    [self panelDeviceDataPointUpdateV2:data];
}

/// 设备属性发生改变
- (void)deviceInfoUpdate:(NSDictionary *)data {
    if ([self canSendEvents_DEPRECATED] && data.count > 0) {
        NSLog(@"面板收到设备属性发生改变:%@", data);
        [self sendEventWithName:RinoPanelEmitterDeviceInfoUpdate body:data];
    }
}

/// 设备绑定消息
- (void)gatewayDeviceBindData:(NSArray *)data {
    NSLog(@"面板收到设备绑定结果:\n%@", data);
    
    NSMutableArray *devices = [NSMutableArray array];
    for (NSDictionary *device in data) {
        NSString *type = [device StringForKey:@"type"];
        // 过滤，只筛选绑定成功的数据
        if ([type isEqualToString:@"add"]) {
            [devices Rino_SafeAddObject:device];
        }
    }
    
    if (devices.count > 0) {
        [self panelGatewayBindData:devices];
        [self panelGatewayBindDataV2:devices];
    }
}

/// 给面板发送通知
- (void)sendPanelNotify:(NSString *)notifyName data:(id)data {
    if (!notifyName) return;
    
    // 白名单过滤
    if ([[self emitterNotifyWhiteList] containsObject:notifyName]) {
        if ([self canSendEvents_DEPRECATED]) {
            NSLog(@"给面板发送通知，名称:%@ \n数据:%@", notifyName, data);
            [self sendEventWithName:notifyName body:data];
        }
    }
}

///ipc p2p连接状态改变
- (void)sendP2pConenctChangeStatus:(NSString *)status {
    NSLog(@"status:%@",status);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            [self sendEventWithName:RinoPanelEmitterShortcutData body:@{@"status":status}];
        }
    });
}

/// 收到 udp广播
- (void)ReceiveUdpData:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            [self sendEventWithName:RinoPanelEmitterBroadcastChange body:data];
        }
    });
}

/// 收到 udp单波数据
- (void)ReceiveUdpUnicastData:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            [self sendEventWithName:RinoPanelEmitterUnicastChange body:data];
        }
    });
}

///ipc设备录制视频变化
- (void)ipcRecordStateChange:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED] ) {
            [self sendEventWithName:RinoPanelEmitterRecordStateChange body:data];
        }
    });
}

///ipc 群组设备列表发生变化的通知
- (void)ipcGroupDeviceListUpdate:(NSDictionary *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED] ) {
            [self sendEventWithName:RinoPanelEmitterJumpToAppPageBack body:data];
        }
    });
}

/// 发现蓝牙设备
- (void)bleDeviceFound:(NSDictionary *)data {
    if ([self canSendEvents_DEPRECATED] && data.count > 0) {
        NSString *jsonStr = [data mj_JSONString];
        [self sendEventWithName:RinoPanelEmitterBLEDeviceFound body:jsonStr];
    }
}

/// 收到蓝牙数据
- (void)bleMessage:(NSDictionary *)data {
    if ([self canSendEvents_DEPRECATED] && data.count > 0) {
        NSString *jsonStr = [data mj_JSONString];
        [self sendEventWithName:RinoPanelEmitterBLEMessage body:jsonStr];
    }
}

/// 蓝牙设备状态改变
- (void)bleDeviceStateChange:(NSDictionary *)data {
    if ([self canSendEvents_DEPRECATED] && data.count > 0) {
        NSString *jsonStr = [data mj_JSONString];
        [self sendEventWithName:RinoPanelEmitterBLEDeviceStateChange body:jsonStr];
    }
}

/// 蓝牙权限状态改变
- (void)bleStateChange:(NSDictionary *)data {
    if ([self canSendEvents_DEPRECATED] && data.count > 0) {
        NSString *jsonStr = [data mj_JSONString];
        [self sendEventWithName:RinoPanelEmitterPermissionStateChange body:jsonStr];
    }
}

#pragma mark - Private

/// 设备dp点发生改变
- (void)panelDeviceDataPointUpdate:(NSArray *)data {
    RinoPanelManager *panelManager = [RinoPanelManager sharedInstance];
        
    NSMutableArray *temp = [NSMutableArray array];
    if (panelManager.deviceModel) {
        NSString *panelDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
        for (NSDictionary *device in data) {
            NSString *deviceId = [device StringForKey:@"deviceId"];
            NSString *gatewayId = [device StringForKey:@"gatewayId"];
            if ([panelDeviceId isEqualToString:deviceId] || [panelDeviceId isEqualToString:gatewayId]) {
                NSDictionary *deviceDps = [self dpUpdateV2ConvertDpUpdateV1:device];
                [temp Rino_SafeAddObject:deviceDps];
            }
        }
    } else if (panelManager.groupModel) {
        RinoGroupModel *groupModel = panelManager.groupModel;
        NSString *panelGroupId = groupModel.groupId?:@"";
        for (RinoDeviceModel *deviceModel in groupModel.deviceList) {
            NSString *panelDeviceId = deviceModel.deviceId?:@"";
            for (NSDictionary *device in data) {
                NSString *deviceId = [device StringForKey:@"deviceId"];
                NSString *gatewayId = [device StringForKey:@"gatewayId"];
                if ([panelDeviceId isEqualToString:deviceId] || [panelDeviceId isEqualToString:gatewayId]) {
                    NSDictionary *deviceDps = [self dpUpdateV2ConvertDpUpdateV1:device];
                    [temp Rino_SafeAddObject:deviceDps];
                }
            }
        }
        for (NSDictionary *group in data) {
            NSString *groupId = [group StringForKey:@"groupId"];
            NSString *gatewayId = [group StringForKey:@"gatewayId"];
            if ([panelGroupId isEqualToString:groupId] || [panelGroupId isEqualToString:gatewayId]) {
                NSDictionary *groupDps = [self dpUpdateV2ConvertDpUpdateV1:group];
                [temp Rino_SafeAddObject:groupDps];
            }
        }
    }
    
    if ([self canSendEvents_DEPRECATED] && temp.count > 0) {
        NSLog(@"传给面板的数据:%@", temp);
        [self sendEventWithName:RinoPanelEmitterDeviceDataPointUpdate body:temp];
    }
}

/// 设备dp点发生改变V2
- (void)panelDeviceDataPointUpdateV2:(NSArray *)data {
    RinoPanelManager *panelManager = [RinoPanelManager sharedInstance];
    
    NSMutableArray *temp = [NSMutableArray array];
    if (panelManager.deviceModel) {
        NSString *panelDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
        for (NSDictionary *device in data) {
            NSString *deviceId = [device StringForKey:@"deviceId"];
            NSString *gatewayId = [device StringForKey:@"gatewayId"];
            if ([deviceId isEqualToString:panelDeviceId] ||
                [gatewayId isEqualToString:panelDeviceId]) {
                [temp Rino_SafeAddObject:device];
            }
        }
    } else if (panelManager.groupModel) {
        RinoGroupModel *groupModel = panelManager.groupModel;
        NSString *panelGroupId = groupModel.groupId?:@"";
        for (RinoDeviceModel *deviceModel in groupModel.deviceList) {
            NSString *panelDeviceId = deviceModel.deviceId?:@"";
            for (NSDictionary *device in data) {
                NSString *deviceId = [device StringForKey:@"deviceId"];
                NSString *gatewayId = [device StringForKey:@"gatewayId"];
                if ([deviceId isEqualToString:panelDeviceId] ||
                    [gatewayId isEqualToString:panelDeviceId]) {
                    [temp Rino_SafeAddObject:device];
                }
            }
        }
        for (NSDictionary *group in data) {
            NSString *groupId = [group StringForKey:@"groupId"];
            NSString *gatewayId = [group StringForKey:@"gatewayId"];
            if ([panelGroupId isEqualToString:groupId] || [panelGroupId isEqualToString:gatewayId]) {
                [temp Rino_SafeAddObject:group];
            }
        }
    }
    
    if ([self canSendEvents_DEPRECATED] && temp.count > 0) {
        NSLog(@"传给面板的数据V2:%@", temp);
        [self sendEventWithName:RinoPanelEmitterDeviceDataPointUpdateV2 body:temp];
    }
}

/// 网关子设备绑定成功消息
- (void)panelGatewayBindData:(NSArray *)data {
    NSString *panelDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *device in data) {
        NSString *deviceId = [device StringForKey:@"deviceId"];
        NSString *gatewayId = [device StringForKey:@"gatewayId"];
        if ([panelDeviceId isEqualToString:deviceId] || [panelDeviceId isEqualToString:gatewayId]) {
            NSDictionary *bindData = @{@"deviceId" :deviceId,
                                       @"gatewayId":gatewayId,
                                       @"header"   :@{@"bind":@(true),
                                                      @"status":@"1"}};
            [temp Rino_SafeAddObject:bindData];
        }
    }
    
    if ([self canSendEvents_DEPRECATED] && temp.count > 0) {
        NSLog(@"网关子设备绑定成功消息:%@", temp);
        [self sendEventWithName:RinoPanelEmitterDeviceDataPointUpdate body:temp];
    }
}

/// 网关子设备绑定成功消息V2
- (void)panelGatewayBindDataV2:(NSArray *)data {
    NSString *panelDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *device in data) {
        NSString *deviceId = [device StringForKey:@"deviceId"];
        NSString *gatewayId = [device StringForKey:@"gatewayId"];
        if ([panelDeviceId isEqualToString:deviceId] || [panelDeviceId isEqualToString:gatewayId]) {
            [temp Rino_SafeAddObject:device];
        }
    }
    
    if ([self canSendEvents_DEPRECATED] && temp.count > 0) {
        NSLog(@"网关子设备绑定成功消息V2:%@", temp);
        [self sendEventWithName:RinoPanelEmitterDeviceGatewayBind body:temp];
    }
}

/// 设备dp点发生改变V2转化为V1数据结构
- (NSDictionary *)dpUpdateV2ConvertDpUpdateV1:(NSDictionary *)device {
    NSString *deviceId = [device StringForKey:@"deviceId"];
    NSString *groupId = [device StringForKey:@"groupId"];
    NSString *gatewayId = [device StringForKey:@"gatewayId"];
    NSDictionary *properties = [device DictionaryForKey:@"properties"];
    NSMutableArray *property = [NSMutableArray array];
    for (NSDictionary *key in properties) {
        id value = [properties SafeObjectForKey:key];
        if (value) {
            NSDictionary *dps = @{key:@{@"value":value,
                                        @"ts"   :[NSString getNowTimestamp10Digits]}};
            [property Rino_SafeAddObject:dps];
        }
    }
    NSDictionary *deviceDps = @{@"deviceId"  :deviceId,
                                @"groupId"   :groupId,
                                @"gatewayId" :gatewayId,
                                @"properties":property};
    return deviceDps;
}

#pragma mark - Private

/// MQTT通知数据
- (void)deviceDataChange:(NSNotification *)notification {
    NSLog(@"进入面板收到设置上报通知:\n%@", notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    NSDictionary *data = [dict DictionaryForKey:@"data"];
    NSArray *devices = [data ArrayForKey:@"devices"];
    NSMutableArray *temp = [NSMutableArray array];
    
    RinoPanelManager *panelManager = [RinoPanelManager sharedInstance];
    if (panelManager.deviceModel) {
        NSString *panelDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
        for (NSDictionary *dict in devices) {
            NSString *deviceId = [dict StringForKey:@"deviceId"];
            NSString *gatewayId = [dict StringForKey:@"gatewayId"];
            if ([deviceId isEqualToString:panelDeviceId] ||
                [gatewayId isEqualToString:panelDeviceId]) {
                [temp Rino_SafeAddObject:dict];
            }
        }
    } else if (panelManager.groupModel) {
        RinoGroupModel *groupModel = panelManager.groupModel;
        for (RinoDeviceModel *deviceModel in groupModel.deviceList) {
            NSString *panelDeviceId = deviceModel.deviceId?:@"";
            for (NSDictionary *dict in devices) {
                NSString *deviceId = [dict StringForKey:@"deviceId"];
                NSString *gatewayId = [dict StringForKey:@"gatewayId"];
                if ([deviceId isEqualToString:panelDeviceId] ||
                    [gatewayId isEqualToString:panelDeviceId]) {
                    [temp Rino_SafeAddObject:dict];
                }
            }
        }
    }
    
    if ([self canSendEvents_DEPRECATED] && temp.count > 0) {
        NSLog(@"传给面板的数据:%@", temp);
        [self sendEventWithName:RinoPanelEmitterDeviceDataPointUpdate body:temp];
    } else {
        NSLog(@"面板数据传入失败:canSendEvents_DEPRECATED-%@, temp.count=%zd", [self canSendEvents_DEPRECATED]?@"YES":@"NO", temp.count);
    }
}

/// 单蓝牙通知数据
- (void)bleDeviceDataChange:(NSNotification *)notification {
    NSLog(@"单蓝牙收到设置上报通知:%@", notification.userInfo);
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *uuid = [userInfo.allKeys Rino_SafeObjectAtIndex:0];
    NSDictionary *data = [userInfo DictionaryForKey:uuid];
    NSArray *deviceList = [RinoHome homeWithHomeId:[RinoPanelManager sharedInstance].homeId].deviceList;
    RinoDeviceModel *deviceModel;
    for (RinoDeviceModel *model in deviceList) {
        if ([model.uuid isEqualToString:uuid]) {
            deviceModel = model;
            break;
        }
    }
    if (deviceModel) {
        NSDictionary *dict = @{@"deviceId"  :deviceModel.deviceId,
                               @"properties":@[[data DictionaryForKey:@"data"]]};
        NSArray *devices = @[dict];
        NSLog(@"单蓝牙传给面板的数据:%@", devices);
        
        if ([self canSendEvents_DEPRECATED] == YES && devices.count > 0) {
            [self sendEventWithName:RinoPanelEmitterDeviceDataPointUpdate body:devices];
        }
    }
}

/// 设备信息发生改变
- (void)deviceInfoChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"设备属性发生改变，通知面板:%@", userInfo);
    
    if ([self canSendEvents_DEPRECATED]) {
        NSLog(@"设备属性发生改变，通知面板，发送成功");
        [self sendEventWithName:RinoPanelEmitterDeviceInfoUpdate body:userInfo];
    }
}

/// 快捷开关发送数据
- (void)deviceShortcutDataNotify:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    if ([self canSendEvents_DEPRECATED]) {
        NSLog(@"快捷开关数据:%@", userInfo);
        [self sendEventWithName:RinoPanelEmitterShortcutData body:userInfo];
    }
}

- (void)setScreenChangeSuccessNoti:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = noti.userInfo;
        NSString *orentation = [userInfo StringForKey:@"Orentation"];
        if ([self canSendEvents_DEPRECATED]) {
            [self sendEventWithName:RinoPanelEmitterScreenOrientationChange body:orentation];
        }
    });
}

#pragma mark - NSNotification

/// 设备指令下发
- (void)deviceCommonCmdResp:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            NSDictionary *data = notification.userInfo;
            [self sendEventWithName:RinoPanelEmitterDeviceCommonCmdChange body:data];
        }
    });
}

/// IPC Token使用通知
- (void)deviceIPCTokenUse:(NSNotification *)notification {
//    NSLog(@"给面板发送通知，名称:IPC Token \n数据:%@", notification.userInfo);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            NSDictionary *data = notification.userInfo?:@{};
            [self sendEventWithName:RinoPanelEmitterIPCTokenUseChange body:data];
        }
    });
}
///搜索到网关子设备
- (void)deviceGatWayFind:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            
            NSDictionary *data = notification.userInfo?:@{};
            NSArray *devices = [data ArrayForKey:@"devices"];
            NSMutableArray *deviceArr = [NSMutableArray array];
            for (NSDictionary *dict in devices) {
                NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [dataDict setValue:@"find" forKey:@"type"];
                [deviceArr addObject:dataDict];
            }
//            NSLog(@"给面板发送通知，名称:GatWayFind \n数据:%@", deviceArr);
            [self sendEventWithName:RinoPanelEmitterDeviceGatewayBind body:deviceArr];
        }
    });
}

#pragma mark - 把mqtt数据发给rn(没有经过处理和逻辑判断的)

- (void)deviceSendMqttToRn:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            NSDictionary *data = notification.userInfo?:@{};
            [self sendEventWithName:RinoPanelEmitterCommandMqttMsgSendRN body:data];
        }
    });
}

#pragma mark - 公共的通知，根据 key 去判断不同的业务
- (void)commonBusinessSendToRn:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self canSendEvents_DEPRECATED]) {
            NSDictionary *data = notification.userInfo?:@{};
            NSLog(@"通知面板进度：%@",[data mj_JSONString]);
            [self sendEventWithName:RinoPanelEmitterCommonBusiness body:data];
        }
    });
}

#pragma mark - Lazy Load

- (NSArray *)emitterNotifyWhiteList {
    return @[RinoPanelEmitterDeviceDataPointUpdate,
             RinoPanelEmitterDeviceDataPointUpdateV2,
             RinoPanelEmitterDeviceGatewayBind,
             RinoPanelEmitterDeviceInfoUpdate,
             RinoPanelEmitterShortcutData,
             RinoPanelEmitterNetworkStateUpdate,
             RinoPanelEmitterScreenOrientationChange,
             RinoPanelEmitterJumpToAppPageBack,
             RinoPanelEmitterSystemWifiChange,
             RinoPanelEmitterDevicePairChange,
             RinoPanelEmitterIPCTokenUseChange,
             RinoPanelEmitterBroadcastChange,
             RinoPanelEmitterUnicastChange,
             RinoPanelEmitterDeviceCommonCmdChange,
             RinoPanelEmitterRecordStateChange,
             RinoPanelEmitterPreloadParamsChange,
             RinoPanelEmitterCommandMqttMsgSendRN,
             RinoPanelEmitterMQTTThroughData,
             RinoPanelEmitterBLEDeviceFound,
             RinoPanelEmitterBLEMessage,
             RinoPanelEmitterBLEDeviceStateChange,
             RinoPanelEmitterPermissionStateChange,
             RinoPanelEmitterSystemPropertiesChange,
             RinoPanelEmitterCommonBusiness,
             RinoPanelEmitterIPCAgoraBusiness,
             RinoPanelEmitterRNContainerFocusChange,
             RinoPanelEmitterEventPageFocusChange,
             RinoPanelEmitterWebRTCNotify
    ];
}

@end
