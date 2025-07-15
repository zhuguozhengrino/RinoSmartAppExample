//
//  RinoDeviceModule.m
//  Rino
//
//  Created by zhangstar on 2022/9/7.
//

#import "RinoDeviceModule.h"
#import <RinoFileUploadKit/RinoFileUploadManager.h>
#import "RinoCustomDrawView.h"
//#import <RinoLaunchMenuKit/RinoLaunchMenuKit.h>
#import <RinoUIKit/HierarchyManager.h>
@interface RinoDeviceModule()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
@implementation RinoDeviceModule

RCT_EXPORT_MODULE();

/// 1. 下发数据
RCT_EXPORT_METHOD(devicePublish:(NSArray *)data
                        resolve:(RCTPromiseResolveBlock)resolve
                         reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self publishDps:data resolve:resolve reject:reject];
    });
}

/// 2. 下发数据
RCT_EXPORT_METHOD(devicePublishV2:(NSDictionary *)data
                          resolve:(RCTPromiseResolveBlock)resolve
                           reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self publishDps:data resolve:resolve reject:reject];
    });
}

/// 5. 设备连云激活
RCT_EXPORT_METHOD(deviceActivatorConnectCloud:(NSString *)deviceId
                                      resolve:(RCTPromiseResolveBlock)resolve
                                       reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel deviceActivatorConnectCloud:deviceId];
    });
}

/// 6. 设备蓝牙连接
RCT_EXPORT_METHOD(deviceBleConnect:(NSString *)deviceId
                           resolve:(RCTPromiseResolveBlock)resolve
                            reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel deviceBleConnect:deviceId];
    });
}

/// 7. 设备固件升级
RCT_EXPORT_METHOD(deviceOTAUpgrade:(NSString *)deviceId
                           resolve:(RCTPromiseResolveBlock)resolve
                            reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel deviceOTAUpgrade:deviceId];
    });
}

/// 8. 网关开始/停止搜索子设备
RCT_EXPORT_METHOD(gatewayDeviceScan:(NSDictionary *)data
                            resolve:(RCTPromiseResolveBlock)resolve
                             reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel gatewayDeviceScan:data success:^{
            if (resolve) {
                resolve([NSNumber numberWithBool:YES]);
            }
        } failure:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

/// 9. 网关批量添加子设备
RCT_EXPORT_METHOD(gatewayDeviceBatchAdd:(NSDictionary *)data
                                resolve:(RCTPromiseResolveBlock)resolve
                                 reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel gatewayDeviceBatchAdd:data success:^{
            if (resolve) {
                resolve([NSNumber numberWithBool:YES]);
            }
        } failure:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

/// 10. 批量移除设备/移除并初始化设备
RCT_EXPORT_METHOD(deviceBatchUnbind:(NSDictionary *)data
                            resolve:(RCTPromiseResolveBlock)resolve
                             reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel deviceBatchUnbind:data success:^{
            if (resolve) {
                resolve([NSNumber numberWithBool:YES]);
            }
        } failure:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

/// 11. 获取网关子设备列表
RCT_EXPORT_METHOD(getListByGatewayId:(NSDictionary *)data
                             resolve:(RCTPromiseResolveBlock)resolve
                              reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel getListByGatewayId:data success:^(NSArray *data) {
            if (resolve) {
                resolve([data mj_JSONString]);
            }
        } failure:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

/// 12. 根据UUID和PID获取简单设备信息
RCT_EXPORT_METHOD(getSimpleDevicelnfo:(NSDictionary *)data
                              resolve:(RCTPromiseResolveBlock)resolve
                               reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel getSimpleDevicelnfo:data success:^(NSDictionary *data) {
            if (resolve) {
                resolve([data mj_JSONString]);
            }
        } failure:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

/// 13. 获取群组设备子设备列表
RCT_EXPORT_METHOD(getGroupDevices:(NSString *)groupId
                          resolve:(RCTPromiseResolveBlock)resolve
                           reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RinoGroup *group = [RinoGroup groupWithGroupId:groupId];
        RinoGroupModel *groupModel = group.groupModel;
        NSArray *deviceList = groupModel.deviceList;
        NSMutableArray *devices = [NSMutableArray array];
        for (RinoDeviceModel *deviceModel in deviceList) {
            RinoDeviceModel *detailDeviceModel = [RinoDevice deviceWithDeviceId:deviceModel.deviceId].deviceModel;
            NSDictionary *dict = [detailDeviceModel mj_JSONObject];;
            NSMutableDictionary *deviceDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [deviceDict setValue:detailDeviceModel.deviceId forKey:@"id"];
            [deviceDict setValue:@(detailDeviceModel.ipcCameraNum) forKey:@"ipcCameraNum"];
            [deviceDict setValue:@(detailDeviceModel.isOnline) forKey:@"isOnline"];
            [devices addObject:deviceDict];
        }
        
        if (resolve) {
            resolve(@{@"devices":devices});
        }
    });
}

/// 14. 获取资产下的设备列表
RCT_EXPORT_METHOD(getDevicesUnderCurAssets:(NSString *)filter
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = @"";
        RinoPanelManager *panelManager = [RinoPanelManager sharedInstance];
        if (panelManager.deviceModel) {
            homeId = panelManager.deviceModel.homeId;
        } else if (panelManager.groupModel) {
            homeId = panelManager.groupModel.homeId;
        }
        RinoHome *home = [RinoHome homeWithHomeId:homeId];
        NSDictionary *data = [self getHomeDevicesAndGroupsWithHome:home filter:filter];
        
        if (resolve) {
            resolve([data.copy mj_JSONString]);
        }
    });
}

/// 获取设备的uuid
RCT_EXPORT_METHOD(getDeviceUUID:(NSString *)deviceId
                        resolve:(RCTPromiseResolveBlock)resolve
                         reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
        if (resolve) {
            resolve(device.deviceModel.uuid);
        }
    });
}

/// 15. 获取资产下同一产品的设备列表
RCT_EXPORT_METHOD(photoFrameGetDeviceListWithPid:(NSString *)pid
                          resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = [RinoPanelManager sharedInstance].homeId?:@"";
        RinoHome *home = [RinoHome homeWithHomeId:homeId];
        NSArray *deviceList = home.deviceList;
        NSMutableArray *deviceArr = [NSMutableArray array];
        for (RinoDeviceModel *deivceModel in deviceList) {
            if([deivceModel.productId isEqualToString:pid]){
                NSDictionary *deviceDict = [deivceModel mj_JSONObject];
                [deviceArr addObject:deviceDict];
            }
            
        }
        NSString *deviceJson = [deviceArr mj_JSONString];
        if (resolve) {
            resolve(deviceJson);
        }
    });
}

/// 16. 上传图片或者视频（相框）
RCT_EXPORT_METHOD(photoFrameStartUploadImagesvideos:(NSArray *)urlArr
                  deviceIdArr:(NSArray *)deviceIdArr
                  isVideo:(BOOL)isVideo
                  uploadId:(NSString *)uploadId
                  title:(NSString *)title
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *sourceDeviceId = [RinoPanelManager sharedInstance].deviceModel.deviceId;
        [[RinoIpfFrameFileUpdateTool sharedInstance] photoFrameStartUploadImagesvideos:urlArr deviceIdArr:deviceIdArr isVideo:isVideo uploadId:uploadId title:title sourceDeviceId:sourceDeviceId resolve:^(NSDictionary * _Nonnull result) {
            if (resolve) {
                resolve(result);
            }
        } reject:^(NSError * _Nonnull error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

/// 17. 停止上传图片或者视频（相框）
RCT_EXPORT_METHOD(photoFrameStopUploadImageVideos:(NSString *)deviceId
                  uploadId:(NSString *)uploadId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoIpfFrameFileUpdateTool sharedInstance] photoFrameStopUploadImageVideos:deviceId uploadId:uploadId resolve:^(BOOL result) {
            if (resolve) {
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError * _Nonnull error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
        
    });
}

///18. 上传图片或者视频返回一个路径
RCT_EXPORT_METHOD(uploadImagesvideos:(NSArray *)urlArr
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[RinoFileUploadManager sharedInstance] uploadLoadImageVideoWithUrlArr:urlArr fileType:RinoUploadFileTypeImage Resolve:^(NSArray * _Nonnull result) {
            if (resolve) {
                resolve(result);
            }
        } reject:^(NSError * _Nonnull error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}
///根据设备ID获取设备信息和状态
RCT_EXPORT_METHOD(getDevInfo:(NSString *)devId
                              resolve:(RCTPromiseResolveBlock)resolve
                               reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RinoDevice *device = [RinoDevice deviceWithDeviceId:devId];
        RinoDeviceModel *deviceModel = device.deviceModel;
        NSDictionary *deviceDict = [deviceModel mj_JSONObject];
        if (resolve) {
            resolve([deviceDict mj_JSONString]);
        }
    });
}
///播放本地音频
RCT_EXPORT_METHOD(playRawAudio:(NSString *)name
                              resolve:(RCTPromiseResolveBlock)resolve
                               reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *audioName = @"";
        if (name.length>0) {
            audioName = name;
        } else {
            NSLog(@"-------%@------%@--------%@",[RinoLanguageManager sharedInatance].customLanguage, [RinoLanguageManager sharedInatance].language, [RinoLanguageManager sharedInatance].lang);
            NSString *language = [RinoLanguageManager sharedInatance].customLanguage;
            if (language.length==0) {
                language = [RinoLanguageManager sharedInatance].language;
            }
            audioName = [NSString stringWithFormat:@"%@%@",@"wait_for_wifi_config_",[language isEqualToString:@"zh-Hans"] ? @"cn" : @"en"];
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:audioName ofType:@"wav"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        // 初始化音频播放器
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        if (error) {
            NSLog(@"音频播放器初始化失败: %@", error.localizedDescription);
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        } else {
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
            if (resolve) {
                resolve(@(YES));
            }
        }
    });
}

///画一张点连线的透明图
RCT_EXPORT_METHOD(getPictureMask:(NSString *)pointsStr
                              resolve:(RCTPromiseResolveBlock)resolve
                               reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RinoCustomDrawView *drawView = [[RinoCustomDrawView alloc] initWithFrame:CGRectZero];
//        drawView.backgroundColor = [UIColor whiteColor];
        [drawView drawWithJSONString:pointsStr];
        UIImage *image = [drawView captureImage];
        [drawView saveImageToSandbox:image withFileName:@"rino_draw_area_temp.jpg" finish:^(NSString * _Nonnull path, NSError * _Nonnull error) {
            if (error) {
                if (reject) {
                    reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
                }
                return;
            }
            if (resolve) {
                resolve(path);
            }
        }];
    });
}

#pragma mark - Private

- (void)publishDps:(id)dps resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    __block RCTPromiseResolveBlock bResolve = resolve;
    __block RCTPromiseRejectBlock bReject = reject;
    
    RinoPanelManager *panelManager = [RinoPanelManager sharedInstance];
    if (panelManager.deviceModel) {
        RinoDevice *device = [RinoDevice deviceWithDeviceId:panelManager.deviceModel.deviceId];
        [device publishDataPoint:dps
                         success:^{
            if (bResolve) {
                bResolve([NSNumber numberWithBool:true]);
                bResolve = nil;
            }
        } failure:^(NSError *error) {
            [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
            if (bReject) {
                bReject([self rejectCode:error], [self rejectMessage:error], error);
                bReject = nil;
            }
        }];
    } else if (panelManager.groupModel) {
        RinoGroup *group = [RinoGroup groupWithGroupId:panelManager.groupModel.groupId];
        [group publishDataPoint:dps
                        success:^{
            if (bResolve) {
                bResolve([NSNumber numberWithBool:true]);
                bResolve = nil;
            }
        } failure:^(NSError *error) {
            [RinoToast showMessage:[error.userInfo StringForKey:NSLocalizedDescriptionKey]];
            if (bReject) {
                bReject([self rejectCode:error], [self rejectMessage:error], error);
                bReject = nil;
            }
        }];
    }
}

/// 根据过滤条件获取资产下的设备或群组列表
- (NSMutableDictionary *)getHomeDevicesAndGroupsWithHome:(RinoHome *)home filter:(NSString *)filter {
    NSArray *filterList = [filter mj_JSONObject];
    NSDictionary *data = [NSDictionary dictionary];
    if (filterList.count == 0) {
        data = [self getHomeDevicesAndGroupsWithHome:home key:@""];
    } else {
        data = [NSDictionary dictionary];
        for (NSString *key in filterList) {
            NSDictionary *dict = [self getHomeDevicesAndGroupsWithHome:home key:key];
            [data dictionaryAddOtherDictionary:dict];
        }
    }
    return data.copy;
}

- (NSDictionary *)getHomeDevicesAndGroupsWithHome:(RinoHome *)home key:(NSString *)key {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if ([key isEqualToString:@"deviceList"] || [key isEqualToString:@""]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (RinoDeviceModel *deviceModel in home.deviceList) {
            [temp Rino_SafeAddObject:deviceModel.data];
        }
        [data Rino_SafeSetObject:temp.copy forKey:@"deviceList"];
    }
    if ([key isEqualToString:@"groupList"] || [key isEqualToString:@""]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (RinoGroupModel *groupModel in home.groupList) {
            [temp Rino_SafeAddObject:groupModel.data];
        }
        [data Rino_SafeSetObject:temp.copy forKey:@"groupList"];
    }
    if ([key isEqualToString:@"shareList"] || [key isEqualToString:@""]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (RinoDeviceModel *deviceModel in home.shareDeviceList) {
            [temp Rino_SafeAddObject:deviceModel.data];
        }
        [data Rino_SafeSetObject:temp.copy forKey:@"shareList"];
    }
    if ([key isEqualToString:@"shareGroupList"] || [key isEqualToString:@""]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (RinoGroupModel *groupModel in home.shareGroupList) {
            [temp Rino_SafeAddObject:groupModel.data];
        }
        [data Rino_SafeSetObject:temp.copy forKey:@"shareGroupList"];
    }
    return data.copy;
}

@end
