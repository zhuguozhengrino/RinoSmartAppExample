//
//  RinoRNP2PBridgingModule.m
//  Rino
//
//  Created by super on 2023/8/3.
//

#import "RinoRNP2PBridgingModule.h"
#import "RinoIPCPlay.h"
#import "RinoEmitterModule.h"
//#import "RinoDeviceHomeViewModel.h"
//#import "RinoPanelManager.h"
#import "RinoPanelDeviceViewController.h"

#import <RinoBaseKit/RinoBaseKit.h>
#import <RinoIPCKit/RinoIPCKit.h>
#import <RinoLaunchMenuKit/RinoDeviceHomeViewModel.h>
#import <RinoPanelKit/RinoPanelKit.h>
#import <RinoProgressHUD/RinoProgressHUD.h>

static id RNP2PBridgingSharedInstance;
static dispatch_once_t RNP2PBridgingOnceToken;

@interface RinoRNP2PBridgingModule ()

@property (nonatomic , strong) RinoIpcReceivedAudioOrVideoView *videoReceivedView;

@end

@implementation RinoRNP2PBridgingModule

+ (instancetype)sharedInstance {
    dispatch_once(&RNP2PBridgingOnceToken, ^{
        RNP2PBridgingSharedInstance = [[self alloc] init];
        [RNP2PBridgingSharedInstance ListeningNoti];
    });
    return RNP2PBridgingSharedInstance;
}

- (void)ListeningNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userJoinGetVideoViewNoti:) name:RinoIPCUserJoinGetVideoViewNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conenctStatusChangeNoti:) name:RinoIPCConenctStatusChangeNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaRecorderStateChangeNoti:) name:RinoIPCmediaRecorderStateDidChangedwNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDPUpdate:) name:RinoNotificationPanelDeviceDataPointUpdate object:nil];
    
}

#pragma mark - 连接状态发生变化
-(void)conenctStatusChangeNoti:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSString *status = [dict StringForKey:@"status"];
    NSString *viewId = [dict StringForKey:@"viewId"];
    NSInteger uid = [dict IntegerForKey:@"uid"];
    RinoAgoraRtcEngineDataModel *dataModel = [[RinoAgoraRtcEngineManager sharedInstance] getDataModelWithViewId:viewId];
    if(uid > 0){
        for (RinoIPCPlay *ipcView in dataModel.videoViewArr) {
            NSInteger roleValue = [ipcView.role integerValue];
            if(roleValue == uid){
                if(ipcView.status != RinoIPCStatusForPlaying){
                    if(ipcView.onStatusChange){
                        ipcView.status = status;
                        NSLog(@"--Engine--11111:%@",status);
                        ipcView.onStatusChange(@{@"status":status});
                    }
                }
            }
        }
    }else{
        for (RinoIPCPlay *ipcView in dataModel.videoViewArr) {
            if(ipcView.status != RinoIPCStatusForPlaying){
                if(ipcView.onStatusChange){
                    ipcView.status = status;
                    NSLog(@"--Engine--11111:%@",status);
                    ipcView.onStatusChange(@{@"status":status});
                }
            }
        }
    }
}

#pragma mark - 根据uid获取RemoteVideo
- (void)userJoinGetVideoViewNoti:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSString *role = [dict StringForKey:@"role"];
    NSString *viewId = [dict StringForKey:@"viewId"];
    RinoAgoraRtcEngineDataModel *dataModel = [[RinoAgoraRtcEngineManager sharedInstance] getDataModelWithViewId:viewId];
    for (RinoIPCPlay *ipcView in dataModel.videoViewArr) {
        
        if([role isEqualToString:ipcView.role]){
            [dataModel rinoRemoteVideo:ipcView role:role];
            return;
        }
    }
}

-(void)mediaRecorderStateChangeNoti:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    [[RinoEmitterModule new] ipcRecordStateChange:dict];
}

/// 设备属性发生改变
- (void)deviceDPUpdate:(NSNotification *)notification {
    if(self.inVideoVoice){
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    NSArray *devices = [userInfo ArrayForKey:@"devices"];
    for (NSDictionary *dict in devices) {
        NSString *deviceId = [dict StringForKey:@"deviceId"];
        NSDictionary *properties = [dict DictionaryForKey:@"properties"];
        RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
        if(device){
            for (NSString *key in properties.allKeys) {
                if([key isEqualToString:@"connect_status"]){
                    NSString *connect_status = properties[@"connect_status"];
                    if([connect_status isEqualToString:@"connecting"]){
                        [MainWindow() addSubview:self.videoReceivedView];
                        self.videoReceivedView.deviceId = deviceId;
                    }else{
                        [self.videoReceivedView removeFromSuperview];
                        self.videoReceivedView = nil;
                    }
                    return;
                }
            }
            
        }
        
    }
}

#pragma mark - 接听视频或者语音
-(void)deviceReceivedAudioOrVideoClickedType:(ReceivedAudioOrVideoViewClickedType)clieckType deviceId:(NSString *)deviceId{
    
    RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
    NSString *devid = [NSString getDeviceIDInKeychain];
    
    [RinoProgressHUD showHUDView];
    
    if(clieckType == ReceivedAudioOrVideoViewClickedTypeVideo){///视频接听
        NSDictionary *dps = @{@"connect_status":@"connected",
                @"connected_client":devid
        };
        [device publishDps:dps success:^{
            self.inVideoVoice = YES;
            [[RinoDeviceHomeViewModel sharedInstance] gotoIPCPanelListeningVideoView:device.deviceModel callback:^(UIViewController * _Nonnull viewController) {
                [RinoProgressHUD hideHUDView];
                [self rnPanlResetView];
                [self.videoReceivedView removeFromSuperview];
                self.videoReceivedView = nil;
                if (viewController) {
                    [TopViewController().navigationController pushViewController:viewController animated:YES];
                   
                }
            }];
        } failure:^(NSError *error) {
            [RinoProgressHUD hideHUDView];
        }];
        
    }else if(clieckType == ReceivedAudioOrVideoViewClickedTypeVoice){///语音接听
        NSDictionary *dps = @{@"connect_status":@"connected",
                @"connected_client":devid
        };
        [device publishDps:dps success:^{
            self.inVideoVoice = YES;
            [[RinoDeviceHomeViewModel sharedInstance] gotoIPCPanelListeningVoiceView:device.deviceModel callback:^(UIViewController * _Nonnull viewController) {
                [RinoProgressHUD hideHUDView];
                [self rnPanlResetView];
                [self.videoReceivedView removeFromSuperview];
                self.videoReceivedView = nil;
                if (viewController) {
                    [TopViewController().navigationController pushViewController:viewController animated:YES];
                }
            }];
        } failure:^(NSError *error) {
            [RinoProgressHUD hideHUDView];
        }];
        
        
    }else if(clieckType == ReceivedAudioOrVideoViewClickedTypeCancel){///挂断
        NSDictionary *dps = @{@"connect_status":@"waiting",
                @"connected_client":devid
        };
        [device publishDps:dps success:^{
            [RinoProgressHUD hideHUDView];
            self.inVideoVoice = NO;
            [self.videoReceivedView removeFromSuperview];
            self.videoReceivedView = nil;
        } failure:^(NSError *error) {
            [RinoProgressHUD hideHUDView];
        }];
    }
    
    
}

-(void)rnPanlResetView{
    NSString *viewStr = NSStringFromClass([TopViewController() class]);
    if([viewStr isEqualToString:@"RinoPanelDeviceViewController"] || [viewStr isEqualToString:@"RinoPanelGroupDetailsViewController"]){
        [TopViewController().navigationController popToRootViewControllerAnimated:NO];
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:TopViewController().navigationController.viewControllers];
//        for (id vc in TopViewController().navigationController.viewControllers) {
//            if ([vc isKindOfClass:[self class]]) {
//                [temp removeObject:vc];
//            }
//        }
        
//        RinoPanelDeviceViewController *panelVC = [[RinoPanelDeviceViewController alloc] init];
//        [temp addObject:panelVC];
//        [TopViewController().navigationController setViewControllers:temp.copy animated:YES];
    }
    
}

-(RinoIpcReceivedAudioOrVideoView *)videoReceivedView{
    if(!_videoReceivedView){
        _videoReceivedView = [[RinoIpcReceivedAudioOrVideoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth(), kScreenHeight())];
        kWeakSelf(self)
        [_videoReceivedView  setClickedBlock:^(ReceivedAudioOrVideoViewClickedType clieckType, NSString * _Nonnull deviceId) {
            [weakself deviceReceivedAudioOrVideoClickedType:clieckType deviceId:deviceId];
        }];
        
    }
    return _videoReceivedView;
}
@end
