//
//  RinoPanelDeviceViewController.m
//  Rino
//
//  Created by zhangstar on 2022/9/6.
//

#import "RinoPanelDeviceViewController.h"
#import "RinoIPCModule.h"
#import "RinoRNP2PBridgingModule.h"

#import <RinoIPCKit/RinoIPCKit.h>

@interface RinoPanelDeviceViewController ()

@end

@implementation RinoPanelDeviceViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RinoPanelViewModel sharedInstance] checkDeviceBLEConnectStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.panelManager.deviceModel.isIpc) {
        [[RinoIPCModule new] snapshot];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

- (void)getData {
    RinoDeviceModel *deviceModel = [RinoPanelManager sharedInstance].deviceModel;
    if (deviceModel) {
        RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceModel.deviceId];
        [device getDeviceDpList:^(RinoDeviceModel * _Nonnull deviceModel) {
            NSDictionary *dps = deviceModel.dataPointValue;
            if (dps.count > 0) {
                NSArray *data = @[@{@"deviceId"  :deviceModel.deviceId?:@"",
                                    @"properties":dps}];
                [self.emitter deviceDataPointUpdate:data];
            }
        } failure:nil];
    }
    
    [self.panelManager getDevicePanelData:^{
        if ([self.panelManager getPanelFilePath].length == 0) {
            [self.panelManager downloadPanelResource:^(NSInteger downloadProgress) {
                self.loadingView.progress = downloadProgress;
            } success:^{
                [self showPanelView];
            } failure:^(NSError *error) {
                self.loadingView.errorMessage = [error.userInfo StringForKey:NSLocalizedDescriptionKey];
                self.backBtn.hidden = NO;
            }];
        } else {
            [self showPanelView];
        }
    } failure:^(NSError *error) {
        self.loadingView.errorMessage = [error.userInfo StringForKey:NSLocalizedDescriptionKey];
        self.backBtn.hidden = NO;
    }];
}

- (void)showPanelView {
    NSMutableDictionary *properties = [[RinoPanelViewModel sharedInstance] getDeviceInitialProperties].mutableCopy;
    [self initPanelWithModuleName:RinoPanelModuleNameDevicePanel properties:properties];
    [self hideLoadingView];
}

@end
