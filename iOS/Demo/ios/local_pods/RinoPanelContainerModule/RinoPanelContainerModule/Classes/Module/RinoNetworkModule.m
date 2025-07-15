//
//  RinoNetworkModule.m
//  Rino
//
//  Created by zhangstar on 2022/9/9.
//

#import "RinoNetworkModule.h"

#import <RinoActivatorKit/RinoActivatorKit.h>
#if __has_include(<RinoActivatorBizKit/RinoActivatorBizKit.h>)
#import <RinoActivatorBizKit/RinoActivatorBizKit.h>
#elif __has_include(<RinoActivatorDefaultUISkin/RinoActivatorDefaultUISkin.h>)
#import <RinoActivatorDefaultUISkin/RinoActivatorDefaultUISkin.h>
#endif

#import <RinoNetworkRequestKit/RinoNetworkRequestKit.h>
#import <RinoFileUploadKit/RinoFileUploadManager.h>

typedef enum : NSUInteger {
    RinoPanelRequestTypeJson,
    RinoPanelRequestTypeForm,
} RinoPanelRequestType;

@interface RinoNetworkModule ()<RinoAPManagerDelegate>

@end

@implementation RinoNetworkModule

RCT_EXPORT_MODULE();

/// 1.1 Rino服务API请求函数
RCT_EXPORT_METHOD(rinoApiRequest:(NSString *)url
                        postData:(NSDictionary *)postData
                         resolve:(RCTPromiseResolveBlock)resolve
                          reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestApiWithUrl:url postData:postData type:RinoPanelRequestTypeJson resolve:resolve reject:reject];
    });
}

/// 1.2 Rino服务API请求函数JSON
RCT_EXPORT_METHOD(rinoApiRequestWithJSON:(NSString *)url
                                postData:(NSString *)postData
                                 resolve:(RCTPromiseResolveBlock)resolve
                                 reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        id param = [postData mj_JSONObject];
        
        [self requestApiWithUrl:url postData:param type:RinoPanelRequestTypeJson resolve:resolve reject:reject];
    });
}

/// 1.3 AP配网，接收本地广播
RCT_EXPORT_METHOD(onBroadCastReceive:(int)broadcastPort
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [RinoAPManager sharedInstance].connectType = RinoUdpSocketConnectTypeHotspot;
//        [RinoAPManager sharedInstance].delegate = self;
        [[RinoAPManager sharedInstance] onBroadCastReceive:broadcastPort delegate:self];
    });
}

/// 1.4 停止监听广播端口
RCT_EXPORT_METHOD(offBroadCastReceive:(int)broadcastPort
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoAPManager sharedInstance] offBroadCastReceivePort:broadcastPort];
    });
}

/// 1.5 AP配网，发送单播数据给设备, 透传版
RCT_EXPORT_METHOD(uniCastSendThrough:(NSString *)udpIP
                  udpPort:(int)udpPort
                  postData:(NSString *)postData
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoAPManager sharedInstance] sendApThroughUdpIp:udpIP udpPort:udpPort postData:postData];
    });
}

/// 1.6 开始监听udp单播端口
RCT_EXPORT_METHOD(onUnicastReceive:(int)port
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoAPManager sharedInstance] onUnicastReceivePort:port];
    });
}

/// 1.7 停止监听udp单播端口
RCT_EXPORT_METHOD(offUnicastReceive:(int)port
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoAPManager sharedInstance] offUnicastReceivePort:port];
    });
}

/// 1.8 获取手机连接过的wifi列表
RCT_EXPORT_METHOD(getWifiHistory:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *history = [[RinoWiFiManager sharedInstance] getWiFiHistory];
        NSString *jsonString = [history mj_JSONString];
        if (resolve) {
            resolve(jsonString);
        }
    });
}

/// 1.9 存储配网使用的wifi密码
RCT_EXPORT_METHOD(savePairingWifiPassword:(NSString *)ssid
                  password:(NSString *)password
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoWiFiManager sharedInstance] saveWiFiWithSSID:ssid password:password];
    });
}

/// 1.10 通用请求方法
RCT_EXPORT_METHOD(apiRequest:(NSString *)param
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [param mj_JSONObject];
        NSString *method = [[data StringForKey:@"method"] lowercaseString];
        NSString *url = [data StringForKey:@"url"];
        NSString *contentType = [[data StringForKey:@"contentType"] lowercaseString];
        NSString *body = [data StringForKey:@"body"];
        id param = [body mj_JSONObject];
        
        RinoRequestMethod requestMethod = POST;
        RinoRequestParamType requestParamType = RinoRequestParamTypeJson;
        if ([method isEqualToString:@"post"]) {
            requestMethod = POST;
        } else if ([method isEqualToString:@"get"]) {
            requestMethod = GET;
        } else if ([method isEqualToString:@"put"]) {
            requestMethod = PUT;
        } else if ([method isEqualToString:@"delete"]) {
            requestMethod = DELETE;
        }
        if ([contentType containsString:@"application/json"]) {
            requestParamType = RinoRequestParamTypeJson;
        } else if ([contentType containsString:@"application/x-www-form-urlencoded"]) {
            requestParamType = RinoRequestParamTypeFormUrlencoded;
        }
        
        RinoRequest *request = [[RinoRequest alloc] init];
        [request requestWithApiName:url
                           postData:param
                             method:requestMethod
                          paramType:requestParamType
                            success:^(RinoRequestModel * _Nonnull requestModel) {
            id result = requestModel.data;
            NSString *resultJsonStr = @"";
            if ([result isKindOfClass:[NSArray class]] || [result isKindOfClass:[NSDictionary class]]) {
                resultJsonStr = [result mj_JSONString];
            } else if ([result isKindOfClass:[NSString class]]) {
                resultJsonStr = result;
            } else if ([result isKindOfClass:[NSNumber class]]) {
                NSNumber *resultNumber = (NSNumber *)result;
                if (strcmp([result objCType], @encode(BOOL)) == 0) { // BOOL类型
                    if ([resultNumber boolValue]) {
                        resultJsonStr = @"true";
                    } else {
                        resultJsonStr = @"false";
                    }
                } else {
                    resultJsonStr = resultNumber.stringValue?:@"";
                }
            }
            
            if (resolve) {
                resolve(resultJsonStr);
            }
        } failure:^(NSError * _Nonnull error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    });
}
                  
#pragma mark - AP配网，发送单播数据给设备
RCT_EXPORT_METHOD(uniCastSend:(NSDictionary *)postData
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = [postData SafeObjectForKey:@"assetId"];
        if (homeId.length == 0) {
            homeId = [self homeId];
        }
        
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:postData];
        [temp Rino_SafeSetObject:homeId forKey:@"homeId"];
        
        [[RinoAPManager sharedInstance] sendAPDistributionNetworkWithData:temp.copy isRN:YES];
    });
}

#pragma mark - 上传图片
RCT_EXPORT_METHOD(uploadFile:(NSString *)filePath
                  type:(int)type
                  isDelete:(BOOL)isDelete
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoFileUploadManager sharedInstance] uploadLoadImageVideoWithUrlArr:@[filePath] fileType:type Resolve:^(NSArray * _Nonnull result) {
            if (resolve) {
                resolve(result.firstObject);
            }
        } reject:^(NSError * _Nonnull error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

#pragma mark - Private

/// form
RCT_EXPORT_METHOD(rinoApiRequestForm:(NSString *)url
                            postData:(NSDictionary *)postData
                             resolve:(RCTPromiseResolveBlock)resolve
                              reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"--Engine--url---表单:%@",url);
        
        [self requestApiWithUrl:url postData:postData type:RinoPanelRequestTypeForm resolve:resolve reject:reject];
    });
}


/// form
RCT_EXPORT_METHOD(rinoApiRequestFormWithJSON:(NSString *)url
                                    postData:(NSString *)postData
                                     resolve:(RCTPromiseResolveBlock)resolve
                                     reject:(RCTPromiseRejectBlock)reject) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"--Engine--url---正常:%@",url);
        id param = [postData mj_JSONObject];
        
        [self requestApiWithUrl:url postData:param type:RinoPanelRequestTypeForm resolve:resolve reject:reject];
    });
}

#pragma mark ----- RinoAPManagerDelegate------
- (void)RinoWriedScandApDeviceWithModel:(RinoActivatorDeviceBLEModel *)model {
    
}

- (void)RinoReceiveUdpData:(NSDictionary *)data uuid:(nonnull NSString *)uuid {
    NSDictionary *dataDict = [data objectForKey:@"data"];
    for (NSString *key in dataDict.allKeys) {
        if ([key isEqualToString:@"type"]) {
            NSString *type = [dataDict StringForKey:@"type"];
            if ([type isEqualToString:RinoAPDistributionNetwork]) {
                [[RinoEmitterModule new] ReceiveUdpData:data];
            } else if ([type isEqualToString:RinoAPDeviceNetwork] || [type isEqualToString:RinoAPDevicewifisNetwork]) {
                [[RinoEmitterModule new] ReceiveUdpUnicastData:data];
            }
        }
    }
}

/// 原始网络请求
- (void)requestApiWithUrl:(NSString *)url postData:(id)postData type:(RinoPanelRequestType)type resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    
    RinoRequest *request = [[RinoRequest alloc] init];
    if (type == RinoPanelRequestTypeJson) {
        [request requestPostJsonWithApiName:url?:@""
                                   postData:postData
                                    success:^(RinoRequestModel * _Nonnull requestModel) {
            if (resolve) {
                resolve(requestModel.data);
            }
        } failure:^(NSError * _Nonnull error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    } else if (type == RinoPanelRequestTypeForm) {
        [request requestPostFormDataWithApiName:url
                                       postData:postData
                                        success:^(RinoRequestModel * _Nonnull requestModel) {
            if (resolve) {
                resolve(requestModel.data);
            }
        } failure:^(NSError * _Nonnull error) {
            if (reject) {
                reject([self rejectCode:error], [self rejectMessage:error], error);
            }
        }];
    }
}

@end
