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

RCT_EXPORT_MODULE();

#pragma mark - Lazy Load

- (RinoPanelViewModel *)panelViewModel {
    return [RinoPanelViewModel sharedInstance];
}

@end
