//
//  RinoFunctionPanelViewController.m
//  RinoPanelContainerModule
//
//  Created by super on 2024/9/5.
//

#import "RinoFunctionPanelViewController.h"

#import "RinoRNP2PBridgingModule.h"


@interface RinoFunctionPanelViewController ()

@end

@implementation RinoFunctionPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
}

- (void)getData {
    
    if ([self.panelManager getPanelFilePath].length == 0) {
        [self.panelManager downloadRNSourceWithProgress:^(NSInteger downloadProgress) {
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
    
    
}

- (void)showPanelView {
    NSDictionary *properties = self.panelManager.activatorData;
    [self initPanelWithModuleName:RinoPanelModuleNameDevicePanel properties:properties];
    [self hideLoadingView];
}


@end
