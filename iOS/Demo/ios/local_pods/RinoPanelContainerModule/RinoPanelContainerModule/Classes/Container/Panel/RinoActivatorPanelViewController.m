//
//  RinoActivatorPanelViewController.m
//  Rino
//
//  Created by zhangstar on 2023/7/5.
//

#import "RinoActivatorPanelViewController.h"

@interface RinoActivatorPanelViewController ()

@end

@implementation RinoActivatorPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

- (void)getData {
    if (self.panelManager.activatorData.count > 0) {
        if ([self.panelManager checkLoadActivatorFilePath]) {
            [self showPanelView];
        } else {
            [self downloadPanel];
        }
    } else {
        [self.panelManager getActivatorData:^{
            if ([self.panelManager checkLoadActivatorFilePath]) {
                [self showPanelView];
            } else {
                [self downloadPanel];
            }
        } failure:^(NSError *error) {
            self.loadingView.errorMessage = [error.userInfo StringForKey:NSLocalizedDescriptionKey];
            self.backBtn.hidden = NO;
        }];
    }
}

- (void)downloadPanel {
    [self.panelManager downloadActivatorPanelResource:^(NSInteger progress) {
        self.loadingView.progress = progress;
    } success:^{
        [self showPanelView];
    } failure:^(NSError *error) {
        self.loadingView.errorMessage = [error.userInfo StringForKey:NSLocalizedDescriptionKey];
        self.backBtn.hidden = NO;
    }];
}

- (void)showPanelView {
    NSString *iosRnType = [self.panelManager.activatorData StringForKey:@"iosRnType"];
    NSDictionary *properties = [NSDictionary dictionary];
    if ([iosRnType isEqualToString:@"itemClick"]) {
        properties = @{@"pairingDataFromProductType":[self.panelManager.activatorData mj_JSONString]};
    } else if ([iosRnType isEqualToString:@"scan"]) {
        properties = @{@"deviceQRCodeInfo":[self.panelManager.activatorData mj_JSONString]};
    } else if ([iosRnType isEqualToString:@"activatorClick"]) {
        properties = @{@"distributionNetworkData":[self.panelManager.activatorData mj_JSONString]};
    } else if ([iosRnType isEqualToString:@"BLEClick"]) {
        properties = @{@"deviceQRCodeInfo":[self.panelManager.activatorData mj_JSONString], @"isBlePairing":@(YES)};
    }
    
    [self initPanelWithModuleName:RinoPanelModuleNameActivatorPanel properties:properties];
    [self hideLoadingView];
}

@end
