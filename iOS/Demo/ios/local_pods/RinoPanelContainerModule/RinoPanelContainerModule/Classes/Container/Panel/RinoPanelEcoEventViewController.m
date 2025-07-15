//
//  RinoPanelEcoEventViewController.m
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/6/18.
//

#import "RinoPanelEcoEventViewController.h"
#import "RinoIPCModule.h"
#import "RinoRNP2PBridgingModule.h"

#import <RinoIPCKit/RinoIPCKit.h>

@interface RinoPanelEcoEventViewController ()

@end

@implementation RinoPanelEcoEventViewController

- (void)dealloc {
    if (self.panelManager.deviceModel.isIpc) {
        [[RinoIpcRNFunctionModul sharedInstance] destructionInstance];
        [RinoIpcRNFunctionModul sharedInstance].inVideoVoice = NO;
        self.panelManager.ipcFunctionType = RinoIpcPanelFunctionTypeNone;
    }
    
    [[RinoPanelViewModel sharedInstance] stopBleScan];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[RinoPanelViewModel sharedInstance] checkDeviceBLEConnectStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[RinoIpcRNFunctionModul_V2 sharedInstance] releaseAllPlayView:^(NSInteger integer) {
//        [[RinoIpcRNFunctionModul_V2 sharedInstance]  releaseEngine:@"RinoAgoraIPCSdkEngine" resolve:^(NSInteger integer) {
//            
//        } reject:^(NSError *error) {
//            
//        }];
//    } reject:^(NSError *error) {
//        
//    }];
    
    
//    if (self.panelManager.deviceModel.isIpc) {
//        [[RinoIPCModule new] snapshot];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getData];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
   
}
- (void)initUI {
    self.view.backgroundColor = Theme().B1;
    self.loadingView = [[RinoBasicPanelLoadingView alloc] init];
    self.loadingView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.loadingView];
    self.loadingView.hidden = YES;
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
    [self showPanelView];

}
- (void)showPanelView {
    NSMutableDictionary *properties = [[RinoPanelViewModel sharedInstance] getDeviceInitialProperties].mutableCopy;
    [properties setValue:@(YES) forKey:@"multideviceEvent"];
    [properties setValue:@(YES) forKey:@"isEventPage"];
    [self initPanelWithModuleName:RinoPanelModuleNameDevicePanel properties:properties];
//    [self hideLoadingView];
}
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
   
    if ([RinoDebugManager sharedInstance].debugPanel == YES) {
        NSString *ip = [RinoDebugManager sharedInstance].debugPanelIP?:@"";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index.bundle?platform=ios&dev=true", ip]];
        return url;
    } else {
        NSURL *url;
        // 加载项目本地面板
        if ([RinoUser sharedInstance].isAppSH) {
            url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"local_index.ios_sh" ofType:@"bundle"]];
        }else{
            url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"local_index.ios" ofType:@"bundle"]];
        }
        return url;
    }
}


@end
