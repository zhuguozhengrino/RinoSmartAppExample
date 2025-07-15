//
//  RinoPanlControllerManager.m
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/7/4.
//

#import "RinoPanlControllerManager.h"
#import "RinoIPCModule.h"
#import "RinoRNP2PBridgingModule.h"

#import <RinoIPCKit/RinoIPCKit.h>

@interface RinoPanlControllerManager ()

@property (nonatomic, strong) RinoEmitterModule *emitter;

@end
@implementation RinoPanlControllerManager
+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

- (void)controllerDealloc{
    if ([RinoPanelManager sharedInstance].deviceModel.isIpc) {
        [[RinoIpcRNFunctionModul sharedInstance] destructionInstance];
        [RinoIpcRNFunctionModul sharedInstance].inVideoVoice = NO;
        [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeNone;
    }
    [[RinoPanelViewModel sharedInstance] stopBleScan];
}

- (void)controllerviewWillAppear{
    [self.emitter sendPanelNotify:RinoPanelEmitterEventPageFocusChange data:@(YES)];
}

- (void)controllerViewWillDisappear{
    [self.emitter sendPanelNotify:RinoPanelEmitterEventPageFocusChange data:@(NO)];
    [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeNone;
}

- (RinoEmitterModule *)emitter {
    if (!_emitter) {
        _emitter = [[RinoEmitterModule alloc] init];
    }
    return _emitter;
}
@end
