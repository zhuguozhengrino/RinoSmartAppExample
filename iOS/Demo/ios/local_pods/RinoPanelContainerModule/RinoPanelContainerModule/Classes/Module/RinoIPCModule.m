//
//  RinoIPCModule.m
//  Rino
//
//  Created by super on 2023/5/25.
//

#import "RinoIPCModule.h"
#import "RinoIPCPlay.h"
#import <RinoPanelKit/RinoPanelShareAndDownloadManager.h>
#import <RinoPanelKit/RinoPanelMessageVideoManager.h>
#import <RinoIPCKit/RinoIpcCloudStorgeRecordingManager.h>
#import "RinoRCTVideoManager.h"
#import "RinoRCTVideo.h"
@interface RinoIPCModule ()

@property (nonatomic, assign) BOOL isPULL;

@property (nonatomic, copy)NSString *recordPath;

@end

@implementation RinoIPCModule

RCT_EXPORT_MODULE();

#pragma mark - 初始化IPC SDK
RCT_EXPORT_METHOD(initIPC:(NSString *)ID map:(NSDictionary *)map
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] initIPC:ID map:map resolve:^(BOOL result) {
            if(resolve){
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            
        }];
        
    });
    
}

RCT_EXPORT_METHOD(setParameters:(NSString *)ID parameters:(NSString *)parameters
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] setParameters:ID parameters:parameters resolve:^{
            if (resolve) {
                resolve([NSNumber numberWithBool:YES]);
            }
        } reject:^(NSError *error) {
            
        }];
    });
}

#pragma mark - 连接频道或会话
RCT_EXPORT_METHOD(connect:(NSString *)ID map:(NSDictionary *)map
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance]connect:ID map:map resolve:^(BOOL result) {
            if(resolve){
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            
        }];
    });
    
}

#pragma mark - 拉流
RCT_EXPORT_METHOD(pullStream:(NSString *)ID jsonValue:(NSString *)jsonValue resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] pullStream:ID jsonValue:jsonValue];
        
    });
    
    
}

#pragma mark - 设置音量
RCT_EXPORT_METHOD(muteRemote:(NSString *)ID map:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] muteRemote:ID map:map resolve:^(BOOL result) {
            if(resolve){
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            
        }];
        
    });
    
}

#pragma mark - 是否开启对讲
RCT_EXPORT_METHOD(enableTalk:(NSString *)ID enable:(BOOL)enable
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] enableTalk:ID enable:enable resolve:^(BOOL result) {
            if(resolve){
                resolve([NSNumber numberWithBool:YES]);
            }
        } reject:^(NSError *error) {
            
        }];
        
        
    });
}

#pragma mark - 发送控制命令
RCT_EXPORT_METHOD(putDeviceData:(NSString *)ID jsonValue:(NSString *)jsonValue resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] putDeviceData:ID jsonValue:jsonValue resolve:^(BOOL result) {
            if(resolve){
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
                
            }
        }];
    });
}

#pragma mark - 打开云存储支付H5
RCT_EXPORT_METHOD(openCloudStorage:(NSString *)url
                  map:(NSDictionary *)map
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] openCloudStorage:url
                                                              map:map
                                                          resolve:^{
            if (resolve) {
                resolve([NSNumber numberWithBool:YES]);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

-(void)snapshot{
    RinoAgoraRtcEngineManager *manager = [RinoAgoraRtcEngineManager sharedInstance];
    for (RinoAgoraRtcEngineDataModel *model in manager.ipcModelArr) {
        for (RinoIPCPlay *ipcView in model.videoViewArr) {
            NSString *role = ipcView.role;
            NSString *ipcPath = [[RinoIpcSnapShootManger sharedInstance] shootSavedAtPathWithDeviceId:model.viewId];
            NSString *filePath = [NSString stringWithFormat:@"%@_%@.png",ipcPath,role];
            NSDictionary *map = @{@"filePath":filePath,@"uid":role};
            [[RinoIpcRNFunctionModul sharedInstance] snapshot:model.viewId map:map resolve:^(NSDictionary *data) {
                
               
            } reject:^(NSError *error) {
                
            }];
        }
    }
}

#pragma mark - 视频截图
RCT_EXPORT_METHOD(snapshot:(NSString *)ID map:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [RinoIpcRNFunctionModul sharedInstance].snapDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
        NSString *path = [map StringForKey:@"filePath"];
        if([path containsString:@"Documents/ipc/meida"]){
            [[RinoIpcRNFunctionModul sharedInstance] snapshot:ID map:map resolve:^(NSDictionary *data) {
                if(resolve){
                    resolve(data);
                }
            } reject:^(NSError *error) {
                if (reject) {
                    reject([self rejectCode:error], [self rejectMessage:error], error);
                }
            }];
        }else{
            NSString *role = @"0";
            NSString *deviceId = @"";
            NSArray *tempArr = [path componentsSeparatedByString:@"lastFrame/"];
            if(tempArr.count >= 2){
                NSString *tempStr = tempArr[1];
                NSArray *array = [tempStr componentsSeparatedByString:@"/"];
                if(array.count >= 2){
                    deviceId = array[0];
                    NSString *roleStr = array[1];
                    role = [roleStr stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                }
            }
            NSString *ipcPath = [[RinoIpcSnapShootManger sharedInstance] shootSavedAtPathWithDeviceId:deviceId];
            NSString *filePath = [NSString stringWithFormat:@"%@_%@.png",ipcPath,role];
            NSDictionary *map = @{@"filePath":filePath,@"uid":role};
            [[RinoIpcRNFunctionModul sharedInstance] snapshot:deviceId map:map resolve:^(NSDictionary *data) {
                
               
            } reject:^(NSError *error) {
                
            }];
        }
        
        
    });
}




#pragma mark - 视频开始录制
RCT_EXPORT_METHOD(startRecording:(NSString *)ID map:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [RinoIpcRNFunctionModul sharedInstance].snapDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
        [[RinoIpcRNFunctionModul sharedInstance] startRecording:ID map:map resolve:^(BOOL result) {
            if(resolve){
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
        
    });
}

#pragma mark - 视频停止录制
RCT_EXPORT_METHOD(stopRecording:(NSString *)ID resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--Engine--stopRecording");
        [[RinoIpcRNFunctionModul sharedInstance] stopRecording:ID resolve:^(NSDictionary *data) {
            if(resolve){
                resolve(data);
            }
        } reject:^(NSError *error) {
            
        }];
    });
}

#pragma mark - 是否开启视频
RCT_EXPORT_METHOD(enableVideo:(NSString *)ID enable:(BOOL)enable
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] enableVideo:ID enable:enable resolve:^(BOOL result) {
            
        } reject:^(NSError *error) {
            
        }];
    });
}

#pragma mark -  静音
RCT_EXPORT_METHOD(enableMute:(NSString *)ID enable:(BOOL)enable
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] enableMute:ID enable:enable resolve:^(BOOL result) {
            
        } reject:^(NSError *error) {
            
        }];
    });
}

#pragma mark - 销毁 view
RCT_EXPORT_METHOD(releasePlayView:(NSString *)ID role:(NSString *)role resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    NSLog(@"--Engine-----releasePlayView-----");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] releasePlayView:ID role:role resolve:^(BOOL result) {
            if (resolve) {
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            
        }];
        
    });
}

RCT_EXPORT_METHOD(enableVideoWithParams:(NSString *)ID map:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    NSLog(@"--Engine-----enableVideoWithParams-----");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul sharedInstance] enableVideoWithParams:ID map:map resolve:^(BOOL result) {
            if (resolve) {
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            
        }];
        
    });
}

RCT_EXPORT_METHOD(shareVideo:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoPanelMessageVideoManager sharedInstance] messageShare:map resolve:^(BOOL result) {
            if (resolve) {
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            
        }];
    });
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

#pragma mark - 截屏云存播放器视频
RCT_EXPORT_METHOD(snapshotRTCVideo:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcCloudStorgeRecordingManager sharedInstance] snapshotRTCVideo:map resolve:^(NSDictionary *data) {
            if(resolve){
                resolve(data);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}

#pragma mark - 开始录制云存播放器视频
RCT_EXPORT_METHOD(startRecordRTCVideo:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcCloudStorgeRecordingManager sharedInstance] startRecordRTCVideo:map resolve:^(NSDictionary *data) {
            if(resolve){
                resolve(data);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}

#pragma mark - 停止录制云存播放器视频
RCT_EXPORT_METHOD(stopRecordRTCVideo:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcCloudStorgeRecordingManager sharedInstance] stopRecordRTCVideo:map resolve:^(NSDictionary *data) {
            if(resolve){
                resolve(data);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}

#pragma mark - 生成图片或视频缩略图
RCT_EXPORT_METHOD(generateThumbnail:(NSString *)filePath
                  thumbnailPath:(NSString *)thumbnailPath
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpcRNFunctionModul_V2 sharedInstance] generateThumbnail:filePath thumbnailPath:thumbnailPath resolve:^(NSInteger integer) {
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
#pragma mark - 释放RTCVideo
RCT_EXPORT_METHOD(releaseRTCVideo:(NSString *)playerID
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--RCTVideo-------releaseRTCVideo------销毁 view:%@",playerID);
        NSArray *viewArr = [RinoRCTVideoManager sharedInstance].rctViewArr;
        BOOL isRelease = NO;
        for (RinoRCTVideo *rctView in viewArr) {
            if ([rctView.playerID isEqualToString:playerID]) {
                [rctView removePlayer];
                [[RinoRCTVideoManager sharedInstance].rctViewArr removeObject:rctView];
                isRelease = YES;
                return;
            }
        }
        if (!isRelease) {
            [[RinoRCTVideoManager sharedInstance].releaseIdArr addObject:playerID];
        }
    });
    
}

//RCT_EXPORT_METHOD(downloadVideo:(NSDictionary *)map resolve:(RCTPromiseResolveBlock)resolve
//                  reject:(RCTPromiseRejectBlock)reject) {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[RinoPanelMessageVideoManager sharedInstance] messageDownload:map resolve:^(BOOL result) {
//            if (resolve) {
//                resolve([NSNumber numberWithBool:result]);
//            }
//        } reject:^(NSError *error) {
//            
//        }];
//    });
//}


@end
