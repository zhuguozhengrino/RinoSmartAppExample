//
//  RinoEmitterModule.h
//  Rino
//
//  Created by zhangstar on 2022/9/7.
//

#import <React/RCTEventEmitter.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoEmitterModule : RCTEventEmitter

/// 设备dp点发生改变
- (void)deviceDataPointUpdate:(NSArray *)data;

/// 设备属性发生改变
- (void)deviceInfoUpdate:(NSDictionary *)data;

/// 设备绑定结果
- (void)gatewayDeviceBindData:(NSArray *)data;

/// 给面板发送通知
- (void)sendPanelNotify:(NSString *)notifyName data:(id)data;

///ipc p2p连接状态改变
- (void)sendP2pConenctChangeStatus:(NSString *)status;

///收到 udp广播数据
- (void)ReceiveUdpData:(NSDictionary *)data;

///收到 udp单波数据
- (void)ReceiveUdpUnicastData:(NSDictionary *)data;

///ipc设备录制视频变化
- (void)ipcRecordStateChange:(NSDictionary *)data;

///ipc 群组设备列表发生变化的通知
- (void)ipcGroupDeviceListUpdate:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
