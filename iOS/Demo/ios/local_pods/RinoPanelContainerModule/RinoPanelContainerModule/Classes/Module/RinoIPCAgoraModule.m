//
//  RinoIPCV2Module.m
//  Rino
//
//  Created by super on 2023/12/29.
//

#import "RinoIPCAgoraModule.h"
#import "RinoIPCPlay.h"

@interface RinoIPCAgoraModule ()

@property (nonatomic, assign) BOOL isPULL;

@property (nonatomic, copy) NSString *recordPath;

@end

@implementation RinoIPCAgoraModule

RCT_EXPORT_MODULE();

#pragma mark - 初始化声网引擎
RCT_EXPORT_METHOD(initEngine:(NSString *)engineId agoraConfig:(NSString *)agoraConfig
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] initEngine:engineId agoraConfig:agoraConfig resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}

#pragma mark - 设置声网参数
RCT_EXPORT_METHOD(setParameters:(NSString *)engineId parameters:(NSString *)parameters
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] setParameters:engineId parameters:parameters resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
        
        
    });
}

#pragma mark - 设置声网参数
RCT_EXPORT_METHOD(setClientRole:(NSString *)engineId role:(NSInteger)role
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] setClientRole:engineId role:role resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
        
    });
}

#pragma mark - 设置视频编码属性--单频道
RCT_EXPORT_METHOD(setVideoEncoderConfiguration:(NSString *)engineId parameters:(NSString *)parameters
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] setVideoEncoderConfiguration:engineId parameters:parameters resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
    
}

#pragma mark - 设置视频编码属性--多频道
RCT_EXPORT_METHOD(setVideoEncoderConfigurationEx:(NSString *)engineId
                  parameters:(NSString *)parameters
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] setVideoEncoderConfigurationEx:engineId parameters:parameters connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 刷新token
RCT_EXPORT_METHOD(renewToken:(NSString *)engineId
                  token:(NSString *)token
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    
    [[RinoIpcRNFunctionModul_V2 sharedInstance] renewToken:engineId token:token resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 加入单频道
RCT_EXPORT_METHOD(joinChannel:(NSString *)engineId parameters:(NSString *)parameters
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] joinChannel:engineId parameters:parameters resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 加入多频道
RCT_EXPORT_METHOD(joinChannelEx:(NSString *)engineId parameters:(NSString *)parameters
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] joinChannelEx:engineId parameters:parameters resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 离开单频道
RCT_EXPORT_METHOD(leaveChannel:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] leaveChannel:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 离开多频道
RCT_EXPORT_METHOD(leaveChannelEx:(NSString *)engineId
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] leaveChannelEx:engineId connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 启用视频模块
RCT_EXPORT_METHOD(enableVideo:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] enableVideo:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 关闭视频模块
RCT_EXPORT_METHOD(disableVideo:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] disableVideo:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 启用音频模块
RCT_EXPORT_METHOD(enableAudio:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] enableAudio:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 关闭音频模块
RCT_EXPORT_METHOD(disableAudio:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] disableVideo:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 开关本地视频采集
RCT_EXPORT_METHOD(enableLocalVideo:(NSString *)engineId
                  enabled:(BOOL)enabled
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] enableLocalVideo:engineId enabled:enabled resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 开关本地音频采集
RCT_EXPORT_METHOD(enableLocalAudio:(NSString *)engineId
                  enabled:(BOOL)enabled
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] enableLocalAudio:engineId enabled:enabled resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 初始化本地视图
RCT_EXPORT_METHOD(setupLocalVideo:(NSString *)engineId
                  playViewId:(NSString *)playViewId
                  renderMode:(NSInteger)renderMode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] setupLocalVideo:engineId playViewId:playViewId renderMode:renderMode resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 初始化远端视图
RCT_EXPORT_METHOD(setupRemoteVideo:(NSString *)engineId
                  playViewId:(NSString *)playViewId
                  uid:(NSInteger)uid
                  renderMode:(NSInteger)renderMode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] setupRemoteVideo:engineId playViewId:playViewId uid:uid renderMode:renderMode resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 多频渲染远端视图
RCT_EXPORT_METHOD(setupRemoteVideoEx:(NSString *)engineId
                  playViewId:(NSString *)playViewId
                  remoteUid:(NSInteger)remoteUid
                  connection:(NSString *)connection
                  renderMode:(NSInteger)renderMode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    
    [[RinoIpcRNFunctionModul_V2 sharedInstance] setupRemoteVideoEx:engineId playViewId:playViewId remoteUid:remoteUid connection:connection renderMode:renderMode resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
    
}


#pragma mark - 获取视频截图-单频道
RCT_EXPORT_METHOD(takeSnapshot:(NSString *)engineId
                  uid:(NSInteger)uid
                  filePath:(NSString *)filePath
                  saveToGallery:(BOOL)saveToGallery
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] takeSnapshot:engineId uid:uid filePath:filePath saveToGallery:saveToGallery resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 获取视频截图-多频道
RCT_EXPORT_METHOD(takeSnapshotEx:(NSString *)engineId
                  connection:(NSString *)connection
                  uid:(NSInteger)uid
                  filePath:(NSString *)filePath
                  saveToGallery:(BOOL)saveToGallery
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] takeSnapshotEx:engineId connection:connection uid:uid filePath:filePath saveToGallery:saveToGallery resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}
#pragma mark - 获取视频截图-多频道-合并
RCT_EXPORT_METHOD(snapShotMultiple:(NSString *)engineId
                  param:(NSDictionary *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] snapShotMultiple:engineId param:param resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}





#pragma mark - 开始录屏
RCT_EXPORT_METHOD(startRecording:(NSString *)engineId
                  param:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] startRecording:engineId param:param resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 开始录屏-合屏
RCT_EXPORT_METHOD(startRecordMultiple:(NSString *)engineId
                  param:(NSDictionary *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] startRecordMultiple:engineId param:param resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 停止录屏
RCT_EXPORT_METHOD(stopRecording:(NSString *)engineId
                  recorderKey:(NSString *)recorderKey
                  channelName:(NSString *)channelName
                  uid:(NSInteger)uid
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] stopRecording:engineId recorderKey:recorderKey channelName:channelName uid:uid resolve:resolve reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
    
}



#pragma mark - 取消或恢复订阅所有远端用户的音频流
RCT_EXPORT_METHOD(muteAllRemoteAudioStreams:(NSString *)engineId
                  muted:(BOOL)muted
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteAllRemoteAudioStreams:engineId muted:muted resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 取消或恢复订阅所有远端用户的视频流
RCT_EXPORT_METHOD(muteAllRemoteVideoStreams:(NSString *)engineId
                  muted:(BOOL)muted
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteAllRemoteVideoStreams:engineId muted:muted resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 取消或恢复发布本地音频流
RCT_EXPORT_METHOD(muteLocalAudioStream:(NSString *)engineId
                  muted:(BOOL)muted
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteLocalAudioStream:engineId muted:muted resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 取消或恢复发布本地视频流
RCT_EXPORT_METHOD(muteLocalVideoStream:(NSString *)engineId
                  muted:(BOOL)muted
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteLocalVideoStream:engineId muted:muted resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 取消或恢复订阅指定远端用户的音频流
RCT_EXPORT_METHOD(muteRemoteAudioStream:(NSString *)engineId
                  uid:(NSInteger)uid
                  muted:(BOOL)muted
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteRemoteAudioStream:engineId uid:uid muted:muted resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}


#pragma mark - 取消或恢复订阅指定远端用户的视频流
RCT_EXPORT_METHOD(muteRemoteVideoStream:(NSString *)engineId
                  uid:(NSInteger)uid
                  muted:(BOOL)muted
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteRemoteVideoStream:engineId uid:uid muted:muted resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 取消或恢复订阅所有远端用户的音频流--多频道
RCT_EXPORT_METHOD(muteAllRemoteAudioStreamsEx:(NSString *)engineId
                  muted:(BOOL)muted
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance]muteAllRemoteAudioStreamsEx:engineId muted:muted connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 取消或恢复订阅所有远端用户的视频流--多频道
RCT_EXPORT_METHOD(muteAllRemoteVideoStreamsEx:(NSString *)engineId
                  muted:(BOOL)muted
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteAllRemoteVideoStreamsEx:engineId muted:muted connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark -取消或恢复发布本地音频流--多频道
RCT_EXPORT_METHOD(muteLocalAudioStreamEx:(NSString *)engineId
                  muted:(BOOL)muted
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteLocalAudioStreamEx:engineId muted:muted connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark -取消或恢复发布本地视频流--多频道
RCT_EXPORT_METHOD(muteLocalVideoStreamEx:(NSString *)engineId
                  muted:(BOOL)muted
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteLocalVideoStreamEx:engineId muted:muted connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark -取消或恢复订阅指定远端用户的音频流--多频道
RCT_EXPORT_METHOD(muteRemoteAudioStreamEx:(NSString *)engineId
                  uid:(NSInteger)uid
                  muted:(BOOL)muted
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteRemoteAudioStreamEx:engineId uid:uid muted:muted connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark -取消或恢复订阅指定远端用户的视频流--多频道
RCT_EXPORT_METHOD(muteRemoteVideoStreamEx:(NSString *)engineId
                  uid:(NSInteger)uid
                  muted:(BOOL)muted
                  connection:(NSString *)connection
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] muteRemoteVideoStreamEx:engineId uid:uid muted:muted connection:connection resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark -开启或关闭扬声器播放
RCT_EXPORT_METHOD(setEnableSpeakerphone:(NSString *)engineId
                  enabled:(BOOL)enabled
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] setEnableSpeakerphone:engineId enabled:enabled resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark -启用用户音量提示
RCT_EXPORT_METHOD(enableAudioVolumeIndication:(NSString *)engineId
                  interval:(NSInteger)interval
                  smooth:(NSInteger)smooth
                  reportVad:(BOOL)reportVad
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] enableAudioVolumeIndication:engineId interval:interval smooth:smooth reportVad:reportVad resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark -切换前置/后置摄像头
RCT_EXPORT_METHOD(switchCamera:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] switchCamera:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 加入频道后更新频道媒体选项
RCT_EXPORT_METHOD(updateChannelMediaOptionsEx:(NSString *)engineId
                  param:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] updateChannelMediaOptionsEx:engineId param:param resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 加入频道后更新频道媒体选项
RCT_EXPORT_METHOD(startPreview:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] startPreview:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 加入频道后更新频道媒体选项
RCT_EXPORT_METHOD(stopPreview:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance]  stopPreview:engineId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}

#pragma mark - 释放视图
RCT_EXPORT_METHOD(releasePlayView:(NSString *)playViewId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] releasePlayView:playViewId resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    
}
#pragma mark - 释放所有视图
RCT_EXPORT_METHOD(releaseAllPlayView:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    [[RinoIpcRNFunctionModul_V2 sharedInstance] releaseAllPlayView:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
    
    
}

#pragma mark - 释放引擎
RCT_EXPORT_METHOD(releaseEngine:(NSString *)engineId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    __block RCTPromiseResolveBlock blockResolve = resolve;
    __block RCTPromiseRejectBlock blockReject = reject;
    [[RinoIpcRNFunctionModul_V2 sharedInstance] releaseEngine:engineId resolve:^(NSInteger integer) {
        if(blockResolve){
            blockResolve(@(integer));
            blockResolve = nil;
        }
    } reject:^(NSError *error) {
        if (blockReject) {
            blockReject([self rejectCode:error], [self rejectMessage:error], error);
            blockReject = nil;
        }
    }];
    
}
#pragma mark - 打开云存储支付H5
RCT_EXPORT_METHOD(openCloudStorage:(NSString *)url
                  map:(NSDictionary *)map
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] openCloudStorage:url map:map resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}


#pragma mark - 设置音频的一些属性
RCT_EXPORT_METHOD(setLocalVoicePitch:(NSString *)engineId
                  pitch:(double)pitch
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] setLocalVoicePitch:engineId pitch:pitch resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}
RCT_EXPORT_METHOD(setVoiceConversionPreset:(NSString *)engineId
                  preset:(int)preset
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] setVoiceConversionPreset:engineId preset:preset resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}
RCT_EXPORT_METHOD(setAudioEffectPreset:(NSString *)engineId
                  preset:(int)preset
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] setAudioEffectPreset:engineId preset:preset resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}

RCT_EXPORT_METHOD(setAudioProfile:(NSString *)engineId
                  profile:(int)profile
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] setAudioProfile:engineId profile:profile resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}

RCT_EXPORT_METHOD(setAudioScenario:(NSString *)engineId
                  scenario:(int)scenario
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] setAudioScenario:engineId scenario:scenario resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}


RCT_EXPORT_METHOD(sendRdtMessage:(NSString *)engineId
                  uid:(NSInteger)uid
                  type:(NSInteger)type
                  message:(NSArray *)message
                  param:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    [[RinoIpcRNFunctionModul_V2 sharedInstance] sendRdtMessage:engineId uid:uid type:type message:message param:param resolve:^(NSInteger integer) {
            if(resolve){
                resolve(@(integer));
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
   
}

#pragma mark - 生成图片或视频缩略图
RCT_EXPORT_METHOD(generateThumbnail:(NSString *)filePath
                  thumbnailPath:(NSString *)thumbnailPath
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    [[RinoIpcRNFunctionModul_V2 sharedInstance] generateThumbnail:filePath thumbnailPath:thumbnailPath resolve:^(NSInteger integer) {
        if(resolve){
            resolve(@(integer));
        }
    } reject:^(NSError *error) {
        if (reject) {
            reject([self rejectCode:error], [self rejectMessage:error], error);
        }
    }];
}
#pragma mark - 视频下载
RCT_EXPORT_METHOD(downloadVideo:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    NSLog(@"--Engine-----downloadVideo-----");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] downloadVideo:map resolve:^(BOOL result) {
            if(resolve){
                if (result) {
                    resolve(@(0));
                }else{
                    resolve(@(-1));
                }
                
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}

@end
