//
//  RinoPanelDeviceViewController.m
//  Rino
//
//  Created by zhangstar on 2022/9/6.
//

#import "RinoPanelDeviceViewController.h"

@interface RinoPanelDeviceViewController ()

@end

@implementation RinoPanelDeviceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RinoPanelViewModel sharedInstance] checkDeviceBLEConnectStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *properties = [[RinoPanelViewModel sharedInstance] getDeviceInitialProperties].mutableCopy;
    
    if ([RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypeAlbum) {
        [properties setValue:@"gallery" forKey:@"basePage"];
    } else if ([RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypePlayback) {
        [properties setValue:@"cloud" forKey:@"basePage"];
    } else if ([RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypeMessage) {
        [properties setValue:@"message" forKey:@"basePage"];
    } else if ([RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypeListenVideo) {
        [properties setValue:@"intercon_video" forKey:@"basePage"];
    } else if ([RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypeListenVoice) {
        [properties setValue:@"intercon_voice" forKey:@"basePage"];
    }else if ([RinoPanelManager sharedInstance].ipcFunctionType == RinoIpcPanelFunctionTypeSetting) {
        [properties setValue:@"settings" forKey:@"basePage"];
    }
    if ([RinoPanelViewModel sharedInstance].ipcTokenData.allKeys.count > 0) {
        [properties setValue:[RinoPanelViewModel sharedInstance].ipcTokenData forKey:@"token"];
    }
    [self initUIWithProperties:properties];
}

@end
