//
//  RinoBluetoothModule.m
//  Rino
//
//  Created by zhangstar on 2023/12/14.
//

#import "RinoBluetoothModule.h"

@interface RinoBluetoothModule ()<RinoPanelBLEManagerDelegate>

@property (nonatomic, strong) RinoPanelBLEManager *bleManager;

@property (nonatomic, assign) BOOL isNotBound;

@end

@implementation RinoBluetoothModule

RCT_EXPORT_MODULE();

/// 2. 开始蓝牙扫描
/// param->
/// @param isBind: 是否被绑定
/// @param isActive: 是否可配网
/// @param clearCache: 是否清楚缓存
RCT_EXPORT_METHOD(startBleScan:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        [self.bleManager startBleScan:data];
        [self resolveHandle:resolve result:YES];
    });
}

/// 3. 停止蓝牙扫描
/// param->
/// @param clearCache: 是否清楚缓存
RCT_EXPORT_METHOD(stopBleScan:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        [self.bleManager stopBleScan:data];
        [self resolveHandle:resolve result:YES];
    });
}

/// 4. 连接蓝牙设备
/// param->
/// @param uuid: 设备uuid
/// @param mac: 设备mac
RCT_EXPORT_METHOD(connectBleDevice:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        [self.bleManager connectBleDevice:data];
    });
}

/// 5. 断开与蓝牙设备的连接
/// param->
/// @param uuid: 设备uuid
/// @param mac: 设备mac
RCT_EXPORT_METHOD(disconnectBleDevice:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        [self.bleManager disconnectBleDevice:data];
    });
}

/// 6. 单蓝牙配网
/// param->
/// @param uuid: 设备uuid
/// @param mac: 设备mac
/// @param rootAssetId: 资产Id
RCT_EXPORT_METHOD(blePairing:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        [self.bleManager pairBleDevice:data
                               success:^{
            [self resolveHandle:resolve result:YES];
        } failure:^(NSError *error) {
            [self rejectHandle:reject error:error];
        }];
    });
}

/// 7. 蓝牙WIFI配网
/// param->
/// @param uuid: 设备uuid
/// @param mac: 设备mac
/// @param encryptType: 加密类型
/// @param data: {"bid":"绑定的资产id", "mq":"mqtt服务器ip", "port":"mqtt服务器端口", "sid":"wifi名", "pw":"wifi密码", "tz":"时区", "force_bind":"是否强绑", "userId":"用户id", "contry":"国家码"}
RCT_EXPORT_METHOD(bleWifiPairing:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        [self.bleManager pairBleWifiDevice:data
                                   success:^{
            [self resolveHandle:resolve result:YES];
        } failure:^(NSError *error) {
            [self rejectHandle:reject error:error];
        }];
    });
}

/// 8. 发送指令给蓝牙设备
/// param->
/// @param uuid: 设备uuid
/// @param mac: 设备mac
/// @param bleMsg: 传输数据
RCT_EXPORT_METHOD(sendBleMessage:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        [self.bleManager sendBleMessage:data];
        [self resolveHandle:resolve result:YES];
    });
}

/// 9. 蓝牙直连控制设备
RCT_EXPORT_METHOD(controlDeviceByBle:(NSString *)devId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel checkDeviceBLEConnectStatus];
        [self resolveHandle:resolve result:YES];
    });
}

/// 10.开始音乐律动
RCT_EXPORT_METHOD(musicStartListening:(NSString *)deviceId 
                  dpId:(NSString *)dpId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

/// 11.停止音乐律动
RCT_EXPORT_METHOD(musicStopListening:(NSString *)deviceId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

/// 12. 蓝牙设备OTA
RCT_EXPORT_METHOD(otaByBle:(NSString *)param 
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        NSString *deviceId = [data StringForKey:@"deviceId"];
        NSString *version = [data StringForKey:@"version"];
        __block NSDictionary *dict;
        [self.bleManager otaBLEDeviceWithParam:data
                            progressCompletion:^(NSInteger progressType, NSInteger progress) {
            
            if (progressType == 1) {
                dict = @{@"type"    :@"downloadToApp",
                         @"percent" :@(progress),
                         @"version" :version,
                         @"resCode" :@"0",
                         @"resMsg"  :@"",
                         @"deviceId":deviceId};
            } else {
                dict = @{@"type"    :@"downloading",
                         @"percent" :@(progress),
                         @"version" :version,
                         @"resCode" :@"0",
                         @"resMsg"  :@"",
                         @"deviceId":deviceId};
            }
            [self sendOTAData:dict];
        } success:^{
            dict = @{@"type"    :@"done",
                     @"percent" :@(0),
                     @"version" :version,
                     @"resCode" :@"0",
                     @"resMsg"  :@"",
                     @"deviceId":deviceId};
            [self sendOTAData:dict];
        } failure:^(NSError *error) {
            dict = @{@"type"    :@"fail",
                     @"percent" :@(0),
                     @"version" :version,
                     @"resCode" :@(error.code),
                     @"resMsg"  :[error.userInfo StringForKey:NSLocalizedDescriptionKey],
                     @"deviceId":deviceId};
            [self sendOTAData:dict];
        }];
    });
}

/// 13.解绑蓝牙设备
RCT_EXPORT_METHOD(unbind:(NSString *)uuid
                  clearData:(BOOL)clearData
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bleManager unbindDeviceWithUuid:uuid 
                                    clearData:clearData
                                      success:^{
            [self resolveHandle:resolve result:YES];
        } failure:^(NSError *error) {
            [self rejectHandle:reject error:error];
        }];
    });
}

/// 开启蓝牙位置服务状态监听(仅安卓端, ios默认支持监听)
RCT_EXPORT_METHOD(startBleLocationListener:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {

}

/// 停止蓝牙位置服务状态监听(仅安卓端, ios默认支持监听)
RCT_EXPORT_METHOD(stopBleLocationListener:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {

}

#pragma mark - RinoPanelBLEManagerDelegate

/// 蓝牙状态
- (void)bluetoothDidUpdateState:(BOOL)isPoweredOn {
    NSDictionary *data = @{@"state":[NSNumber numberWithBool:isPoweredOn],
                           @"type" :@"Ble"};
    [self.emitter bleStateChange:data];
}

/// 面板扫描设备回调
- (void)bleScanDeviceInfo:(NSDictionary *)deviceInfo {
    [self.emitter bleDeviceFound:deviceInfo];
}

/// 设备已连接
- (void)bleDeviceConnectFinished:(RinoBLEAdvModel *)advModel {
    NSDictionary *data = @{@"uuid" :advModel.uuid?:@"",
                           @"state":@(0)};
    
    [self.emitter bleDeviceStateChange:data];
}

/// 设备已断开
- (void)bleDeviceDisconnectFinished:(RinoBLEAdvModel *)advModel {
    NSDictionary *data = @{@"uuid" :advModel.uuid?:@"",
                           @"state":@(1)};
    
    [self.emitter bleDeviceStateChange:data];
}

/// 蓝牙指令响应
- (void)responseBLEDeviceData:(NSDictionary *)data advModel:(RinoBLEAdvModel *)advModel {
    NSDictionary *dict = @{@"uuid":advModel.uuid?:@"",
                           @"data":data};
    [self.emitter bleMessage:dict];
}

/// 连接未绑定设备错误回调
- (void)connectUnbindBLEDeviceFailure:(NSError *)error {
    if (!self.isNotBound) {
        self.isNotBound = YES;
        [RinoAlertView showAlertTitle:[error.userInfo StringForKey:NSLocalizedDescriptionKey]
                        selectedBlock:^{
            self.isNotBound = NO;
            [[RinoPanelViewModel sharedInstance] backPreviousPanelPage];
            RinoDeviceModel *deviceModel = [RinoPanelManager sharedInstance].deviceModel;
            RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceModel.deviceId];
            [device remove:^{
                
            } failure:^(NSError *error) {
                
            }];
        }];
    }
}

#pragma mark - Private

- (void)sendOTAData:(NSDictionary *)data {
    NSDictionary *dict = @{@"key" :@"bleOtaProgress",
                           @"data":data?:@{}};
    [self.emitter sendPanelNotify:RinoPanelEmitterCommonBusiness data:[dict mj_JSONString]];
}

#pragma mark - Lazy Load

- (RinoPanelBLEManager *)bleManager {
    _bleManager = [RinoPanelBLEManager sharedInstance];
    _bleManager.delegate = self;
    return _bleManager;
}

@end
