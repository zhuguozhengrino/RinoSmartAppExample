//
//  RinoReactNativeBaseModule.m
//  Rino
//
//  Created by zhangstar on 2022/9/9.
//

#import "RinoReactNativeBaseModule.h"

@implementation RinoReactNativeBaseModule

- (NSString *)rejectCode:(NSError *)error {
    return [NSString stringWithFormat:@"%ld", error.code];
}

- (NSString *)rejectMessage:(NSError *)error {
    return [error.userInfo StringForKey:NSLocalizedDescriptionKey];
}

- (void)postNotification:(NSString *)name
                userInfo:(NSDictionary *)userInfo {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:name?:@""
                          object:nil
                        userInfo:userInfo?:@{}];
}

- (void)resolveHandle:(RCTPromiseResolveBlock)resolve result:(BOOL)result {
    if (resolve) {
        resolve([NSNumber numberWithBool:result]);
    }
}

- (void)resolveHandle:(RCTPromiseResolveBlock)resolve data:(id)data {
    if (resolve) {
        resolve(data);
    }
}

- (void)rejectHandle:(RCTPromiseRejectBlock)reject error:(NSError *)error {
    if (reject) {
        reject([self rejectCode:error], [self rejectMessage:error], error);
    }
}

- (NSString *)homeId {
    id<RinoLaunchMenuProtocol> impl = [[RinoBizCore sharedInstance] serviceOfProtocol:@protocol(RinoLaunchMenuProtocol)];
    NSString *homeId = [impl getCurrenHomeId];
    return homeId;
}

RCT_EXPORT_MODULE();

#pragma mark - Lazy Load

- (RinoPanelViewModel *)panelViewModel {
    _panelViewModel = [RinoPanelViewModel sharedInstance];
    return _panelViewModel;
}

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        _emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}

@end
