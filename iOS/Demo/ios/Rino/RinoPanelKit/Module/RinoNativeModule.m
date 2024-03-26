//
//  RinoNativeModule.m
//  Rino
//
//  Created by zhangstar on 2022/9/14.
//

#import "RinoNativeModule.h"
#import "RinoRNP2PBridgingModule.h"

#import <NetworkExtension/NetworkExtension.h>
#import <RinoAppConfigModule/RinoAppConfigModule.h>
#import <RinoBaseKit/RinoBaseKit.h>
#import <RinoBusinessLibraryModule/RinoPermissionKit.h>
#import <RinoLanguageKit/RinoLanguageKit.h>
#import <RinoPanelKit/RinoPanelKit.h>
#import <RinoPanelKit/RinoReactNativeModuleManager.h>
#import <RinoLaunchMenuKit/RinoLaunchMenuKit.h>
#import <RinoIPCKit/RinoIpcRNFunctionModul.h>
@implementation RinoNativeModule

RCT_EXPORT_MODULE();

/// 5. 常量（Constants）
- (NSDictionary *)constantsToExport {
    RinoUser *user = [RinoUser sharedInstance];

    RinoConfigManager *config = [RinoConfigManager sharedInstance];
    NSString *appVersion = AppVersion()?:@"";
    NSString *rnVersion = @"0.70";
    NSString *language = [RinoLanguageManager sharedInatance].lang?:@"";
    NSString *tempUnit = @"";
    NSString *timezoneId = user.timeZone;
    NSString *countryCode = @"";
    NSString *themeColor = config.theme?:@"";
    if (timezoneId.length == 0) {
        timezoneId = [NSTimeZone systemTimeZone].name?:@"";
    }
    for (RinoCountryModel *countryModel in [RinoCountry sharedInstance].countryList) {
        if ([countryModel.countryCode isEqualToString:user.countryCode]) {
            countryCode = countryModel.dataCenterCode?:@"";
            break;
        }
    }
    
    NSDictionary *theme = @{@"primary":themeColor};
    return @{@"appVersion" :appVersion,
             @"rnVersion"  :rnVersion,
             @"language"   :language,
             @"tempUnit"   :tempUnit,
             @"timezoneId" :timezoneId,
             @"countryCode":countryCode,
             @"theme":[theme mj_JSONString]
    };
}

/// 1. 容器返回上一界面
RCT_EXPORT_METHOD(back:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
                         
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel backPreviousView];
    });
}

/// 2. 跳转设备详情页
RCT_EXPORT_METHOD(showDeviceDetail:(RCTPromiseResolveBlock)resolve
                            reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel didDeviceDetail];
    });
}

/// 3. 启用左滑返回
RCT_EXPORT_METHOD(enablePopGesture:(RCTPromiseResolveBlock)resolve
                            reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel enablePopGesture:YES];
    });
}

/// 4. 禁用左滑返回
RCT_EXPORT_METHOD(disablePopGesture:(RCTPromiseResolveBlock)resolve
                             reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel enablePopGesture:NO];
    });
}

/// 6. 跳转子面板--网关设备面板跳转网关子设备面板
RCT_EXPORT_METHOD(openSubPanel:(NSString *)deviceId
                       resolve:(RCTPromiseResolveBlock)resolve
                        reject:(RCTPromiseRejectBlock)reject) {

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel openSubPanelWithDeviceId:deviceId];
    });
}

/// 7. 跳转设备配网说明
RCT_EXPORT_METHOD(openDeviceActivatorDescribe:(RCTPromiseResolveBlock)resolve
                                       reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel openDeviceActivatorDescribe];
    });
}

/// 8. 面板跳转原生App页面
RCT_EXPORT_METHOD(openAppBusinessPage:(NSString *)page
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    __block RCTPromiseResolveBlock bResolve = resolve;
    __block RCTPromiseRejectBlock bReject = reject;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([RinoFamilyPermissionManager sharedInstance].checkFamilyRole == YES) {
            [[RinoReactNativeModuleManager sharedInstance] openAppBusinessPage:page
                                                                       success:^{
                if (bResolve) {
                    bResolve(@"");
                    bResolve = nil;
                }
            } failure:^{
                if (bReject) {
                    bReject(@"", @"", [NSError new]);
                    bReject = nil;
                }
            }];
        } else {
            [[RinoFamilyPermissionManager sharedInstance] showFamilyPermissionTipsView];
        }
    });
}

/// 9. 设置屏幕方向
RCT_EXPORT_METHOD(setOrientation:(NSString *)orientation
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:RinoSetScreenDirectionChangeNoti object:nil userInfo:@{@"Orentation":orientation}];
    });
}

/// 10. Wifi系统设置
RCT_EXPORT_METHOD(goToSystemWifi:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:@"APP-Prefs:root=WIFI"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    });
}

/// 11. 获取当前WIFI名称
RCT_EXPORT_METHOD(getWifiSSID:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *ssid = [[RinoPermissionManager sharedInstance] currentWifiSSID]?:@"";
         if (resolve) {
             resolve(ssid);
         }
    });
}

/// 12. 获取手机信息
RCT_EXPORT_METHOD(getMobileInfo:(RCTPromiseResolveBlock)resolve
                         reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [self.panelViewModel getMobileInfo];
        NSString *dataJsonString = [data mj_JSONString];
        if (resolve) {
            resolve(dataJsonString);
        }
    });
}

/// 13. 获取手机系统属性
RCT_EXPORT_METHOD(getSystemProperties:(NSString *)key
                                param:(NSString *)param
                              resolve:(RCTPromiseResolveBlock)resolve
                               reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"[Rino_Panel]获取系统设置:%@ %@",key ,param);
        NSDictionary *dict = [param mj_JSONObject];
        NSDictionary *data = [self.panelViewModel getSystemProperties:key param:dict];
        NSString *dataJsonString = [data mj_JSONString];
        if (resolve) {
            resolve(dataJsonString);
        }
    });
}

/// 14. 设置手机系统属性
RCT_EXPORT_METHOD(setSystemProperties:(NSString *)key
                                param:(NSString *)param
                              resolve:(RCTPromiseResolveBlock)resolve
                               reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"[Rino_Panel]系统设置:%@ %@",key ,param);
        NSDictionary *data = [param mj_JSONObject];
        [self.panelViewModel setSystemProperties:key param:data success:^{
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

/// 15. 获取预加载参数
RCT_EXPORT_METHOD(getPreloadParams:(RCTPromiseResolveBlock)resolve
                            reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RinoPanelManager *panelManager = [RinoPanelManager sharedInstance];
        RinoDeviceModel *deviceModel = panelManager.deviceModel;
        if (deviceModel) {
            NSString *deviceId = deviceModel.deviceId;
            NSDictionary *ipcToken = [[RinoReactNativeModuleManager sharedInstance].ipcToken SafeObjectForKey:deviceId]?:@{};
            NSDictionary *dps = deviceModel.dataPointValue?:@{};
            NSDictionary *param = @{@"agoraToken":ipcToken,
                                    @"dpState"   :dps};
            NSString *jsonString = [param mj_JSONString];
            if (resolve) {
                resolve(jsonString);
            }
        }
    });
}

/// 16. App主动链接wifi
RCT_EXPORT_METHOD(connectWifi:(NSString *)info
                      resolve:(RCTPromiseResolveBlock)resolve
                       reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [info mj_JSONObject];
        NSString *ssid = [data StringForKey:@"ssid"];
        NSString *password = [data StringForKey:@"password"];
        NSString *securityType = [data StringForKey:@"securityType"];
        
        NEHotspotConfiguration *configuration;
        // 无加密
        if (securityType.length == 0) {
            configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid];
        } else {
            configuration = [[NEHotspotConfiguration alloc] initWithSSID:ssid passphrase:password isWEP:NO];
        }
        
        NEHotspotConfigurationManager *manager = [NEHotspotConfigurationManager sharedManager];
        [manager applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
            NSLog(@"[Rino_Hot]:%@", error);
            NSString *currentSSID = [[RinoPermissionManager sharedInstance] currentWifiSSID];
            if (![ssid isEqualToString:currentSSID] && !error) { // 当前连接WiFi与目标WiFi不一致，失败回调
                error = [NSError rinoError:2 message:@""];
            }
            NSDictionary *result;
            if (!error) { // 成功
                result = @{@"msg" :@"",
                           @"code":@(0)};
            } else {
                NSString *errorMsg = [error.userInfo StringForKey:NSLocalizedDescriptionKey]?:@"";
                if (error.code == 7) {
                    result = @{@"msg" :errorMsg,
                               @"code":@(4)};
                } else {
                    result = @{@"msg" :errorMsg,
                               @"code":@(2)};
                }
            }
            
            if (resolve) {
                resolve([result mj_JSONString]);
            }
        }];
    });
}

/// 17. 返回到原生顶层路由
RCT_EXPORT_METHOD(popToTopRoute:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (RinoTopViewController().navigationController.viewControllers.count > 0) {
            [RinoTopViewController().navigationController popToRootViewControllerAnimated:YES];
        }
    });
}

/// 18. 增加Mqtt监听
RCT_EXPORT_METHOD(addMqttListener:(NSString *)filterRegex
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *data = [filterRegex mj_JSONObject];
        [[RinoReactNativeModuleManager sharedInstance] addPanelMQTTListener:data];
    });
}

/// 19. 释放Mqtt监听
RCT_EXPORT_METHOD(removeMqttListener:(NSString *)ids
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *data = @[];
        if (ids.length > 0) {
            data = [ids mj_JSONObject];
        }
        
        [[RinoReactNativeModuleManager sharedInstance] removePanelMQTTListener:data];
    });
}

/// 获取MQTT地址
RCT_EXPORT_METHOD(getMqttServer:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *mqtt = [RinoConfigManager sharedInstance].mqtt?:@"";
         if (resolve) {
             resolve(mqtt);
         }
    });
}

///设置是否在视频或者语音中
RCT_EXPORT_METHOD(setIntercomLock:(BOOL)lock resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [RinoIpcRNFunctionModul sharedInstance].inVideoVoice = lock;
    });
}

@end
