//
//  RinoNativeModule.m
//  Rino
//
//  Created by zhangstar on 2022/9/14.
//

#import "RinoNativeModule.h"

#import <NetworkExtension/NetworkExtension.h>
#import <RinoBusinessLibraryModule/RinoPermissionManager.h>

@implementation RinoNativeModule

RCT_EXPORT_MODULE();

/// 5. 常量（Constants）
- (NSDictionary *)constantsToExport {
    RinoUser *user = [RinoUser sharedInstance];
    RinoConfigManager *config = [RinoConfigManager sharedInstance];
    
    NSString *appVersion = Rino_AppVersion()?:@"";
    NSString *rnVersion = @"0.70";
    NSString *language = [RinoLanguageManager sharedInatance].lang?:@"";
    NSString *tempUnit = user.tempUnit == RinoTemperatureUnitCelsius ? @"C" : @"F";
    NSString *timezoneId = user.timeZone;
    NSString *countryCode = @"";
    NSString *themeColor = [UIColor hexFromColor:Theme().themeColor]?:@"";
    if (timezoneId.length == 0) {
        timezoneId = [NSTimeZone systemTimeZone].name?:@"";
    }
    for (RinoCountryModel *countryModel in [RinoCountry sharedInstance].countryList) {
        if ([countryModel.countryCode isEqualToString:user.countryCode]) {
            countryCode = countryModel.dataCenterCode?:@"";
            break;
        }
    }
    NSString *themeType;
    if (Theme().styleMode == RinoStyleModeDark) {
        themeType = @"dark";
    } else {
        themeType = @"light";
    }
    NSString *pageLinearGradient = config.oemConfigModel.pageLinearGradient;
    NSDictionary *theme = @{@"primary":themeColor,@"pageLinearGradient":pageLinearGradient?:@""};
    
    NSString *osVersion = [UIDevice deviceSystemVersion]?:@"";
    NSString *mqttServerIp = config.mqtt?:@"";
    NSInteger mqttServerPort = config.port;
    NSString *bundleId = Rino_MainBundleId()?:@"";
    
    return @{@"appVersion"     :appVersion,
             @"rnVersion"      :rnVersion,
             @"language"       :language,
             @"tempUnit"       :tempUnit,
             @"timezoneId"     :timezoneId,
             @"countryCode"    :countryCode,
             @"rn_core_version":@"1.0.1",
             @"theme"          :[theme mj_JSONString],
             @"themeType"      :themeType,
             @"osVersion"      :osVersion,
             @"mqttServerIp"   :mqttServerIp,
             @"mqttServerPort" :@(mqttServerPort),
             @"appPackageName" :bundleId};
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
        [[RinoReactNativeModuleManager sharedInstance] openAppBusinessPage:page 
                                                                   success:^(NSString * _Nonnull result) {
            if (bResolve) {
                bResolve(result);
                bResolve = nil;
            }
        } failure:^(NSError * _Nonnull error) {
            if (bReject) {
                bReject(@"", @"", error);
                bReject = nil;
            }
        }];
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

/// 15. 开启或关闭系统属性监听
RCT_EXPORT_METHOD(toggleSystemPropertiesListen:(NSString *)property
                  enableListen:(BOOL)enableListen
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.panelViewModel toggleSystemPropertiesListen:property enableListen:enableListen];
    });
}

/// 16. 获取预加载参数
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

/// 17. App主动链接wifi
RCT_EXPORT_METHOD(connectWifi:(NSString *)info
                      resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoPermissionManager sharedInstance] locationPermission:^(BOOL isPermission) {
            if (isPermission) {
                [self connectWifiWithInfo:info resolve:resolve reject:reject];
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"rino_system_permissions_location_title".localized message:@"rino_system_permissions_location_decs".localized preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"rino_common_cancel".localized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [RinoTopViewController().navigationController popViewControllerAnimated:YES];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"rino_common_go_setting".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [RinoTopViewController().navigationController popViewControllerAnimated:YES];
                    });
                    
                }]];
                [RinoTopViewController() presentViewController:alertController animated:YES completion:nil];
            }
        }];
        
    });
}

-(void)connectWifiWithInfo:(NSString *)info resolve:(RCTPromiseResolveBlock)resolve
                    reject:(RCTPromiseRejectBlock)reject{
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSError *tempError = error;
            if (error.code == 13) {
                tempError = nil;
            }
            NSDictionary *result;
            NSString *currentSSID = [[RinoPermissionManager sharedInstance] currentWifiSSID];
            if ([ssid isEqualToString:currentSSID]) { // 当前连接WiFi与目标WiFi一致，回调
                result = @{@"msg" :@"",
                           @"code":@(0)};
                
            }else{
                NSString *errorMsg;
                if (!error) {
                    tempError = [NSError rinoError:2 message:@""];
                    errorMsg = [tempError.userInfo StringForKey:NSLocalizedDescriptionKey]?:@"";
                }else{
                    errorMsg = [error.userInfo StringForKey:NSLocalizedDescriptionKey]?:@"";
                }
                if (error.code == 7) {
                    result = @{@"msg" :errorMsg,
                               @"code":@(4)};
                } else {
                    result = @{@"msg" :errorMsg,
                               @"code":@(2)};
                }
            }
            
            NSLog(@"result:%@--currentSSID:%@",[result mj_JSONString],currentSSID);
            if (resolve) {
                resolve([result mj_JSONString]);
            }
        });
        
    }];
}

/// 18. 返回到原生顶层路由
RCT_EXPORT_METHOD(popToTopRoute:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (RinoTopViewController().navigationController.viewControllers.count > 0) {
            [RinoTopViewController().navigationController popToRootViewControllerAnimated:YES];
        }
    });
}

/// 19. 增加Mqtt监听
RCT_EXPORT_METHOD(addMqttListener:(NSString *)filterRegex
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *data = [filterRegex mj_JSONObject];
        [[RinoReactNativeModuleManager sharedInstance] addPanelMQTTListener:data];
    });
}

/// 20. 释放Mqtt监听
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
///跳转到权限的系统设置页面
RCT_EXPORT_METHOD(jumpToSystemPage:(NSString *)systemPage
                  params:(NSString *)params
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([systemPage containsString:@"APPPermissionList"]) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }else if ([systemPage containsString:@"APPDetail"]){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }
        
    });
}

///tabbar 是否显示
RCT_EXPORT_METHOD(showTabBarEnabled:(BOOL)enabled
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.panelViewModel rinoShowTabBarEnabled:enabled];
    });
}

/// 面板跳h5页面
RCT_EXPORT_METHOD(openH5Page:(NSString *)url map:(NSDictionary *)map
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[RinoWebViewManager sharedInstance] gotoUniversalLinkWithUrl:url title:@""];
    });
}

/// 面板跳相册
RCT_EXPORT_METHOD(goAlbum:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:@"photos-redirect://"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            NSLog(@"无法打开相册");
        }
    });
}

/// 面板跳相册
RCT_EXPORT_METHOD(hasInitPanel:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoPanelViewModel sharedInstance] upgradeDeviceContentStatusToNative];
    });
}
/// 23. 跳转第三方导航APP
RCT_EXPORT_METHOD(jumpToTriNavigationAPP:(NSString *)params
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoReactNativeModuleManager sharedInstance] jumpToTriNavigationAPP:params success:^(NSString * _Nonnull result) {
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    });
}

@end
