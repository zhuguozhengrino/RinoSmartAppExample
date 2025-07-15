//
//  RinoPanelGroupViewController.m
//  Rino
//
//  Created by zhangstar on 2022/11/15.
//

#import "RinoPanelGroupViewController.h"

@interface RinoPanelGroupViewController ()

@end

@implementation RinoPanelGroupViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    RinoGroupModel *groupModel = [RinoGroup groupWithGroupId:[RinoPanelManager sharedInstance].groupModel.groupId].groupModel;
    [RinoPanelManager sharedInstance].groupModel = groupModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

- (void)getData {
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
    NSMutableDictionary *properties = [[RinoPanelViewModel sharedInstance] getGroupInitialProperties].mutableCopy;
    [self initPanelWithModuleName:RinoPanelModuleNameDevicePanel properties:properties];
    [self hideLoadingView];
}

@end
