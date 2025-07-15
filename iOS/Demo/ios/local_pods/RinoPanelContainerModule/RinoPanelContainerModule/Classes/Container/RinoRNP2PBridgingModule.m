//
//  RinoRNP2PBridgingModule.m
//  Rino
//
//  Created by super on 2023/8/3.
//

#import "RinoRNP2PBridgingModule.h"
#import "RinoIPCPlay.h"
#import "RinoEmitterModule.h"
#import "RinoPanelDeviceViewController.h"

#import <RinoBaseKit/RinoBaseKit.h>
#import <RinoFoundationKit/RinoFoundationKit.h>
#import <RinoPanelKit/RinoPanelKit.h>
#import <RinoIPCKit/RinoIPCKit.h>

static id RNP2PBridgingSharedInstance;
static dispatch_once_t RNP2PBridgingOnceToken;

@interface RinoRNP2PBridgingModule ()

@end

@implementation RinoRNP2PBridgingModule

+ (instancetype)sharedInstance {
    dispatch_once(&RNP2PBridgingOnceToken, ^{
        RNP2PBridgingSharedInstance = [[self alloc] init];
//        [RNP2PBridgingSharedInstance ListeningNoti];
    });
    return RNP2PBridgingSharedInstance;
}

- (void)ListeningNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userJoinGetVideoViewNoti:) name:RinoIPCUserJoinGetVideoViewNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conenctStatusChangeNoti:) name:RinoIPCConenctStatusChangeNoti object:nil];
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
    }
    
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
    if([RinoIpcRNFunctionModul sharedInstance].inVideoVoice){
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    [[RinoIpcVideoOrVoicePushTool sharedInstance] updateIpcDps:userInfo];
    
}

#pragma mark - 远端视频 stats 发生变化
-(void)RemoteVideoStatsChangeNoti:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSString *viewId = [dict StringForKey:@"viewId"];
    RinoAgoraRtcEngineDataModel *dataModel = [[RinoAgoraRtcEngineManager sharedInstance] getDataModelWithViewId:viewId];
    for (RinoIPCPlay *ipcView in dataModel.videoViewArr) {
        if(ipcView.onOtherBusiness){
            ipcView.onOtherBusiness(dict);
        }
    }
    
}
@end
