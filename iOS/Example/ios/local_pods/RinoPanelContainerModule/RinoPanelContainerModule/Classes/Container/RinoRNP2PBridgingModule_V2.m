//
//  RinoRNP2PBridgingModule_V2.m
//  Rino
//
//  Created by super on 2023/12/29.
//

#import "RinoRNP2PBridgingModule_V2.h"
#import "RinoAgoraPlayView.h"
#import "RinoEmitterModule.h"
#import "RinoPanelDeviceViewController.h"

#import <RinoBaseKit/RinoBaseKit.h>
#import <RinoBizCore/RinoBizCore.h>
#import <RinoFoundationKit/RinoFoundationKit.h>
#import <RinoIPCKit/RinoIPCKit.h>
#import <RinoPanelKit/RinoPanelKit.h>

static id RNP2PBridgingV2SharedInstance;
static dispatch_once_t RNP2PBridgingV2OnceToken;


@interface RinoRNP2PBridgingModule_V2 ()<RinoIpcKitProtocol>

@end

@implementation RinoRNP2PBridgingModule_V2
+ (instancetype)sharedInstance {
    dispatch_once(&RNP2PBridgingV2OnceToken, ^{
        RNP2PBridgingV2SharedInstance = [[self alloc] init];
        [RNP2PBridgingV2SharedInstance ListeningNoti];
        [RNP2PBridgingV2SharedInstance registerProtocol];
    });
    return RNP2PBridgingV2SharedInstance;
}

#pragma mark - Public

- (void)registerProtocol {
    RinoBizCore *bizCore = [RinoBizCore sharedInstance];
    [bizCore registerService:@protocol(RinoIpcKitProtocol) withInstance:self];
    
}

#pragma mark - RinoIpcKitProtocol

- (void)getPlayViewWithId:(NSString *)playViewId completion:(void (^)(UIView * _Nullable))completion {
    NSArray *viewArr = [RinoAgoraRtcEngineManager_V2 sharedInstance].ipcViewArr;
    for (NSInteger i = 0; i < viewArr.count; i++) {
        RinoAgoraPlayView *ipcView = [viewArr Rino_SafeObjectAtIndex:i];
        if([playViewId isEqualToString:ipcView.playViewId]){
            if(completion){
                completion(ipcView);
            }
            return;
        }
    }
}

- (void)ListeningNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaRecorderStateChangeNoti:) name:RinoIPCmediaRecorderStateDidChangedwNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDPUpdate:) name:RinoNotificationPanelDeviceDataPointUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceivingVoiceOrVideNoti:) name:RinoIPCReceivingVoiceOrVideoNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoteVideoStatsChangeNoti:) name:RinoIPCRemoteVideoStatsChangeNoti object:nil];
    
    
}
#pragma mark - 接听语音或者视频的通知
-(void)ReceivingVoiceOrVideNoti:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSString *type = [userInfo StringForKey:@"type"];
    if([type isEqualToString:@"voice"]){
        [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeListenVoice;
    }else if ([type isEqualToString:@"video"]){
        [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeListenVideo;
    }else if ([type isEqualToString:@""]){
        [RinoPanelManager sharedInstance].ipcFunctionType = RinoIpcPanelFunctionTypeNone;
    }
    
}



-(void)mediaRecorderStateChangeNoti:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    [[RinoEmitterModule new] ipcRecordStateChange:dict];
}

/// 设备属性发生改变
- (void)deviceDPUpdate:(NSNotification *)notification {
    if([RinoIpcRNFunctionModul sharedInstance].inVideoVoice){
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    [[RinoIpcVideoOrVoicePushTool sharedInstance] updateIpcDps:userInfo];
    
}
#pragma mark - 远端声网发生发生变化
-(void)RemoteVideoStatsChangeNoti:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = noti.userInfo;
        [[RinoEmitterModule new] sendPanelNotify:@"RinoIPCAgoraBusiness" data:dict];
    });
    
    
}

#pragma mark - 销毁对象
- (void)destructionInstance{
    [[RinoIpcRNFunctionModul_V2 sharedInstance] destructionInstance];
}
@end
