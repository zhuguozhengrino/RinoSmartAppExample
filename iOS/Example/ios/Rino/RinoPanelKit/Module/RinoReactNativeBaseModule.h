//
//  RinoReactNativeBaseModule.h
//  Rino
//
//  Created by zhangstar on 2022/9/9.
//

#import <React/RCTBridgeModule.h>
#import <RinoPanelKit/RinoPanelViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoReactNativeBaseModule : NSObject<RCTBridgeModule>

@property (nonatomic, strong) RinoPanelViewModel *panelViewModel;

- (NSString *)rejectCode:(NSError *)error;

- (NSString *)rejectMessage:(NSError *)error;

/// 发送推送消息
- (void)postNotification:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
