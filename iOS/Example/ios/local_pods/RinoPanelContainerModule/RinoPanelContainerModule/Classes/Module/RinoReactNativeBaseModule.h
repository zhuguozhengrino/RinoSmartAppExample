//
//  RinoReactNativeBaseModule.h
//  Rino
//
//  Created by zhangstar on 2022/9/9.
//

#import <React/RCTBridgeModule.h>
#import <RinoBizCore/RinoBizCore.h>

#import "RinoEmitterModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface RinoReactNativeBaseModule : NSObject<RCTBridgeModule>

@property (nonatomic, strong) RinoPanelViewModel *panelViewModel;

@property (nonatomic, strong) RinoEmitterModule *emitter;

- (NSString *)rejectCode:(NSError *)error;

- (NSString *)rejectMessage:(NSError *)error;

/// 发送推送消息
- (void)postNotification:(NSString *)name userInfo:(NSDictionary *)userInfo;

- (void)resolveHandle:(RCTPromiseResolveBlock)resolve result:(BOOL)result;

- (void)resolveHandle:(RCTPromiseResolveBlock)resolve data:(id)data;

- (void)rejectHandle:(RCTPromiseRejectBlock)reject error:(NSError *)error;

- (NSString *)homeId;

@end

NS_ASSUME_NONNULL_END
