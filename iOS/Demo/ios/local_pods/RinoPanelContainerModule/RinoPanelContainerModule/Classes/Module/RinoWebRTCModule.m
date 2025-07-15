//
//  RinoWebRTCModule.m
//  Rino
//
//  Created by 2bit on 2024/7/2.
//

#import "RinoWebRTCModule.h"
#import <RinoIPCKit/RinoWebRTCManager.h>

@implementation RinoWebRTCModule

RCT_EXPORT_MODULE();

- (void)successWithInteger:(NSInteger)integer resolve:(RCTPromiseResolveBlock)resolve {
    if (resolve) {
        if (integer == 0) {
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
}

- (void)fail:(NSError *)error reject:(RCTPromiseRejectBlock)reject {
    if (reject) {
        reject([self rejectCode:error], [self rejectMessage:error], error);
    }
}

#pragma mark - 创建底层webRTC连接对象
RCT_EXPORT_METHOD(createWebRTC:(NSString *)devId
                  channelCount:(NSInteger)channelCount
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 创建webRTC");
        [[RinoWebRTCManager sharedInstance] createWebRTC:devId channelCount:channelCount resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 关闭 webrtc 通道
RCT_EXPORT_METHOD(close:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    __block RCTPromiseResolveBlock blockResolve = resolve;
    __block RCTPromiseRejectBlock blockReject = reject;
    NSLog(@"--webrtc-- rn-- 关闭 webrtc");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoWebRTCManager sharedInstance] close:peerClientId resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:blockResolve];
        } reject:^(NSError *error) {
            [self fail:error reject:blockReject];
        }];
    });
}

#pragma mark - 开始对讲
RCT_EXPORT_METHOD(startPushVoice:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoWebRTCManager sharedInstance] startPushVoice:peerClientId resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 停止对讲
RCT_EXPORT_METHOD(stopPushVoice:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoWebRTCManager sharedInstance] stopVoice:peerClientId resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 通过DataChannel发送数据
RCT_EXPORT_METHOD(sendData:(NSString *)peerClientId
                  channelName:(NSString *)channelName
                  bytes:(NSArray *)bytes
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
//    NSLog(@"--webrtc-- rn-- 发送 channelName： data 数据");
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [[RinoWebRTCManager sharedInstance] sendData:peerClientId channelName:channelName bytes:bytes resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 将PlayView依附到已有视频轨道中
RCT_EXPORT_METHOD(attachRendererView:(NSString *)peerClientId
                  streamId:(NSString *)streamId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 将PlayView依附到已有视频轨道中");
        [[RinoWebRTCManager sharedInstance] attachRendererView:peerClientId streamId:streamId resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 依附到现有WebRtc连接, 依附后开始将此连接的通知通知给面板
RCT_EXPORT_METHOD(attachWebRTC:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"--webrtc-- rn-- 依附到现有WebRtc连接, 依附后开始将此连接的通知通知给面板");
        [[RinoWebRTCManager sharedInstance] attachWebRTC:peerClientId resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 检查现有WebRtc数据通道状态
RCT_EXPORT_METHOD(getDataChannelState:(NSString *)peerClientId
                  channelName:(NSString *)channelName
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 检查现有WebRtc数据通道状态");
        [[RinoWebRTCManager sharedInstance] getDataChannelState:peerClientId channelName:channelName resolve:^(NSString *result) {
            if (resolve) {
                resolve(result);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}
#pragma mark - 获取 datachannel 名称
RCT_EXPORT_METHOD(getDataChannelNames:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn--获取 datachannel 名称");
        [[RinoWebRTCManager sharedInstance] getDataChannelNames:peerClientId resolve:^(NSArray *data) {
            if (resolve) {
                resolve(data);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 依附到现有WebRtc数据通道, 依附后开始将此通道收到的数据通知给面板
RCT_EXPORT_METHOD(attachDataChannel:(NSString *)peerClientId
                  channelName:(NSString *)channelName
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"--webrtc-- rn--依附到现有WebRtc数据通道, 依附后开始将此通道收到的数据通知给面板");
        [[RinoWebRTCManager sharedInstance] attachDataChannel:peerClientId channelName:channelName resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 静音某个连接
RCT_EXPORT_METHOD(setAudioTrackEnable:(NSString *)peerClientId
                  streamId:(NSString *)streamId
                  enable:(BOOL)enable
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoWebRTCManager sharedInstance] setAudioTrackEnable:peerClientId streamId:streamId enable:enable resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 获取peerClientId
RCT_EXPORT_METHOD(getWebRTCPeerClientId:(NSString *)devId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn--获取peerClientId");
        [[RinoWebRTCManager sharedInstance] getWebRTCPeerClientId:devId resolve:^(NSString *result) {
            if (resolve) {
                resolve(result);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 支持查询当前webrtc的状态（如果有的话） 默认是new 当webrtc连接失败、关闭、断开连接，面板业务层可以自行重新创建连接
RCT_EXPORT_METHOD(getWebRTCState:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"--webrtc-- rn--支持查询当前webrtc的状态（如果有的话） 默认是new 当webrtc连接失败、关闭、断开连接，面板业务层可以自行重新创建连接");
        [[RinoWebRTCManager sharedInstance] getWebRTCState:peerClientId resolve:^(NSString *result) {
            if (resolve) {
                resolve(result);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 当前ice的状态（如果有的话） 默认是new 当webrtc连接失败、关闭、断开连接，面板业务层可以自行重新创建连接
RCT_EXPORT_METHOD(getWebRTCICEState:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn--当前ice的状态（如果有的话） 默认是new 当webrtc连接失败、关闭、断开连接，面板业务层可以自行重新创建连接");
        [[RinoWebRTCManager sharedInstance] getWebRTCICEState:peerClientId resolve:^(NSString *result) {
            if (resolve) {
                resolve(result);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}


#pragma mark - 获取设备webRTC错误码
RCT_EXPORT_METHOD(getDeviceErrorCode:(NSString *)devId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn--获取设备webRTC错误码");
        [[RinoWebRTCManager sharedInstance] getDeviceErrorCode:devId resolve:^(NSInteger integer) {
            if (resolve) {
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
    });
}

#pragma mark - 添加音频MiddleWare
RCT_EXPORT_METHOD(addAudioMiddleWare:(NSString *)peerClientId
                  middleCode:(NSString *)middleCode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 添加音频MiddleWare");
        [[RinoWebRTCManager sharedInstance] addAudioMiddleWare:peerClientId middleCode:middleCode resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}

#pragma mark - 移除音频MiddleWare
RCT_EXPORT_METHOD(removeAudioMiddleWare:(NSString *)peerClientId
                  middleCode:(NSString *)middleCode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 移除音频MiddleWare");
        [[RinoWebRTCManager sharedInstance] removeAudioMiddleWare:peerClientId middleCode:middleCode resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}


#pragma mark - 视频截图
RCT_EXPORT_METHOD(snapshot:(NSString *)json
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 视频截图");
        [[RinoWebRTCManager sharedInstance] snapshot:json resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}

#pragma mark - 视频开始录制
RCT_EXPORT_METHOD(startRecording:(NSString *)json
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 视频开始录制");
        [[RinoWebRTCManager sharedInstance] startRecording:json resolve:^(NSInteger integer) {
            [self successWithInteger:integer resolve:resolve];
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}

#pragma mark - 视频结束录制
RCT_EXPORT_METHOD(stopRecording:(NSString *)recorderKey
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--webrtc-- rn-- 视频结束录制");
        [[RinoWebRTCManager sharedInstance] stopRecording:recorderKey resolve:^(NSDictionary *data) {
            if (resolve) {
                resolve(data);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}

#pragma mark - 获取直播流的码率
RCT_EXPORT_METHOD(getVideoStats:(NSString *)peerClientId
                  streamId:(NSString *)streamId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoWebRTCManager sharedInstance] getVideoStats:peerClientId streamId:streamId resolve:^(NSDictionary *data) {
            if (resolve) {
                resolve(data);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}
#pragma mark - 获取ReceiverStats
RCT_EXPORT_METHOD(getReceiverStats:(NSString *)peerClientId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoWebRTCManager sharedInstance] getReceiverStats:peerClientId resolve:^(NSArray *data) {
            if (resolve) {
                resolve(data);
            }
        } reject:^(NSError *error) {
            [self fail:error reject:reject];
        }];
        
    });
}

@end
