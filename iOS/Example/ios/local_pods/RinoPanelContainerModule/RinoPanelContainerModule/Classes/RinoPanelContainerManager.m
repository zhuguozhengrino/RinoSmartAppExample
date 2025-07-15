//
//  RinoPanelContainerManager.m
//  Rino
//
//  Created by zhangstar on 2024/12/4.
//

#import "RinoPanelContainerManager.h"
#import "RinoEmitterModule.h"

#import "RinoActivatorPanelViewController.h"
#import "RinoPanelDeviceViewController.h"
#import "RinoPanelGroupViewController.h"
#import "RinoFunctionPanelViewController.h"
#import "RinoPanelVestViewController.h"
#import "RinoPanelMessageVideoViewController.h"

@interface RinoPanelContainerManager ()

@property (nonatomic, strong) RinoEmitterModule *emitter;

@end

@implementation RinoPanelContainerManager

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (__kindof UIViewController *)getPanelActivatorViewController {
    return [[RinoActivatorPanelViewController alloc] init];
}

- (NSString *)getPanelActivatorViewControllerClassName {
    return NSStringFromClass([RinoActivatorPanelViewController class]);
}

- (__kindof UIViewController *)getPanelDeviceViewController {
    return [[RinoPanelDeviceViewController alloc] init];
}

- (NSString *)getPanelDeviceViewControllerClassName {
    return NSStringFromClass([RinoPanelDeviceViewController class]);
}

- (__kindof UIViewController *)getPanelGroupViewController {
    return [[RinoPanelGroupViewController alloc] init];
}

- (NSString *)getPanelGroupViewControllerClassName {
    return NSStringFromClass([RinoPanelGroupViewController class]);
}

- (__kindof UIViewController *)getFunctionPanelViewController {
    return [[RinoFunctionPanelViewController alloc] init];
}

- (NSString *)getFunctionPanelViewControllerClassName {
    return NSStringFromClass([RinoFunctionPanelViewController class]);
}

- (__kindof UIViewController *)getPanelMessageVideoViewController {
    return [[RinoPanelMessageVideoViewController alloc] init];
}

- (NSString *)getPanelMessageVideoViewControllerClassName {
    return NSStringFromClass([RinoPanelMessageVideoViewController class]);
}

- (__kindof UIViewController *)getPanelVestViewController {
    return [[RinoPanelVestViewController alloc] init];
}

- (NSString *)getPanelVestViewControllerClassName {
    return NSStringFromClass([RinoPanelVestViewController class]);
}

/// 设备dp点发生改变
- (void)deviceDataPointUpdate:(NSArray *)data {
    [self.emitter deviceDataPointUpdate:data];
}

/// 设备属性发生改变
- (void)deviceInfoUpdate:(NSDictionary *)data {
    [self.emitter deviceInfoUpdate:data];
}

/// 设备绑定结果
- (void)gatewayDeviceBindData:(NSArray *)data {
    [self.emitter gatewayDeviceBindData:data];
}

/// 给面板发送通知
- (void)sendPanelNotify:(NSString *)notifyName data:(id)data {
    [self.emitter sendPanelNotify:notifyName data:data];
}

#pragma mark - Lazy Load

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        _emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}

@end
