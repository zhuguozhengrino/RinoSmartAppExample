//
//  RinoPanelContainerManager.h
//  Rino
//
//  Created by zhangstar on 2024/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoPanelContainerManager : NSObject

@property (nonatomic, strong) NSDictionary *activatorData;

+ (instancetype)sharedInstance;

- (__kindof UIViewController *)getPanelActivatorViewController;

- (NSString *)getPanelActivatorViewControllerClassName;

- (__kindof UIViewController *)getPanelDeviceViewController;

- (NSString *)getPanelDeviceViewControllerClassName;

- (__kindof UIViewController *)getPanelGroupViewController;

- (NSString *)getPanelGroupViewControllerClassName;

- (__kindof UIViewController *)getFunctionPanelViewController;

- (NSString *)getFunctionPanelViewControllerClassName;

- (__kindof UIViewController *)getPanelMessageVideoViewController;

- (NSString *)getPanelMessageVideoViewControllerClassName;

- (__kindof UIViewController *)getPanelVestViewController;

- (NSString *)getPanelVestViewControllerClassName;

/// 设备dp点发生改变
- (void)deviceDataPointUpdate:(NSArray *)data;

/// 设备属性发生改变
- (void)deviceInfoUpdate:(NSDictionary *)data;

/// 设备绑定结果
- (void)gatewayDeviceBindData:(NSArray *)data;

/// 给面板发送通知
- (void)sendPanelNotify:(NSString *)notifyName data:(id)data;

@end

NS_ASSUME_NONNULL_END
