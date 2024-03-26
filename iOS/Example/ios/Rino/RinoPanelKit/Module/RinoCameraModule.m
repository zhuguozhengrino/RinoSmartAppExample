//
//  RinoCameraModule.m
//  Rino
//
//  Created by zhangstar on 2023/4/4.
//

#import "RinoCameraModule.h"

@implementation RinoCameraModule

RCT_EXPORT_MODULE();

/// 初始化P2P
RCT_EXPORT_METHOD(initP2P:(NSString *)deviceId
                  resolve:(RCTPromiseResolveBlock)resolve
                   reject:(RCTPromiseRejectBlock)reject) {
    
}

/// 开始播放
RCT_EXPORT_METHOD(play:(NSString *)deviceId
               resolve:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject) {
    
}

/// 静音
RCT_EXPORT_METHOD(enableMute:(BOOL)isEnable
                     resolve:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject) {
    
}

/// 码率切换（清晰度切换）
RCT_EXPORT_METHOD(setClarity:(NSString *)clarity
                     resolve:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject) {
    
}

@end
