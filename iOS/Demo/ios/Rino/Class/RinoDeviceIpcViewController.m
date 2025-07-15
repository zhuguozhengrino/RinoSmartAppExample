//
//  RinoDeviceIpcViewController.m
//  RinoLaunchMenuKit
//
//  Created by super on 2024/4/26.
//

#import "RinoDeviceIpcViewController.h"
#import <RinoIPCKit/RinoIpcNativeSingleChannelModul.h>
#import <RinoIPCKit/RinoIpcSnapShootManger.h>
#import <RinoIPCKit/RinoIpcVideoView.h>
#import <RinoNetworkRequestKit/RinoNetworkRequestKit.h>
@interface RinoDeviceIpcViewController ()<RinoIpcRNFunctionModulNativeDelegate>

@property (nonatomic , strong) RinoIpcVideoView *ipcView;

@property (nonatomic , strong) RinoIpcVideoView *ipcViewTwo;

@property (nonatomic , strong) UIButton *snapBtn;

@property (nonatomic , strong) UIButton *starBtn;

@property (nonatomic , strong) UIButton *endBtn;

@property (nonatomic , strong) UIView *localView;

@property (nonatomic, strong) UIButton *jietuBtn;

@property (nonatomic , strong) RinoIpcNativeSingleChannelModul *singleModel;
@end

@implementation RinoDeviceIpcViewController

-(void)dealloc{
    [self.singleModel destroyInstanceResolve:^(BOOL result) {
        
    } reject:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"--Engine--ipc_deviceId:%@",self.deviceModel.deviceId);
    [self singleChannel];
}



-(void)singleChannel{
    [self.view addSubview:self.ipcView];
    [self.view addSubview:self.ipcViewTwo];
    [self.view addSubview:self.localView];
    RinoDevice *device = [RinoDevice deviceWithDeviceId:self.deviceModel.deviceId];
    [device deviceIpcGetTokenSuccess:^(NSDictionary *data) {
        NSString *agoraAppId = [data Rino_StringForKey:@"agoraAppId"];
        NSDictionary *rtcToken = [data DictionaryForKey:@"rtcToken"];
        NSString *rtcTokenStr = [rtcToken StringForKey:@"rtcToken"];
        NSString *channelName = [rtcToken StringForKey:@"channelName"];
        NSInteger uid = [rtcToken IntegerForKey:@"uid"];
        self.ipcView.tokenStr = rtcTokenStr;
        self.ipcView.remoteUid = 1;
        self.ipcView.uid = uid;
        self.ipcView.channelName = channelName;
        
        if(self.deviceModel.ipcCameraNum == 1){
            self.singleModel = [RinoIpcNativeSingleChannelModul rinoInitIpcWithDeviceId:self.deviceModel.deviceId agoraAppId:agoraAppId ipcViewArr:@[self.ipcView] deviceSize:CGSizeMake(0, 0) delegate:self resolve:^(BOOL result) {
                
            } reject:^(NSError *error) {
                
            }];
            
        }else if (self.deviceModel.ipcCameraNum ==  2){
            self.ipcViewTwo.tokenStr = rtcTokenStr;
            self.ipcViewTwo.remoteUid = 2;
            self.ipcViewTwo.uid = uid;
            self.ipcViewTwo.channelName = channelName;
            self.singleModel = [RinoIpcNativeSingleChannelModul rinoInitIpcWithDeviceId:self.deviceModel.deviceId agoraAppId:agoraAppId ipcViewArr:@[self.ipcView,self.ipcViewTwo] deviceSize:CGSizeMake(0, 0) delegate:self resolve:^(BOOL result) {
                
            } reject:^(NSError *error) {
                
            }];
        }
        ///通知设备加入频道（这个可以改成你们自己的接口，去通知设备）
        [device deviceIpcJoinPullStreemWithData:data success:^{
            NSLog(@"--Engine--通知设备加入频道成功");
        } failure:^(NSError *error) {
            
        }];
    
        
    } failure:^(NSError *error) {
        
    }];
    
    
    [self.view addSubview:self.jietuBtn];
    
}



-(void)rinoIpcDeviceId:(NSString *)deviceId remoteVideoStateChanged:(RinoVideoRemoteState)state reason:(RinoVideoRemoteStateReason)reason{
//    NSLog(@"--Engine--state:%zd--reason:%zd",state,reason);
}

-(void)rinoIpcDeviceId:(NSString *)deviceId connectionChangedToState:(RinoIPCConnectionState)state reason:(RinoConnectionChangedReason)reason{
//    NSLog(@"--Engine--state:%zd--reason:%zd",state,reason);
}

-(void)rinoIpcDeviceId:(NSString *)deviceId didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    
    ///订阅和取消订阅音频
    [self.singleModel rinoSubscriptionRemoteAudioStreamEnabled:YES resolve:^(BOOL result) {
            
        } reject:^(NSError *error) {
            
        }];
    ///订阅和取消订阅视频
    [self.singleModel rinoSubscriptionRemoteVideoStreamEnabled:YES resolve:^(BOOL result) {
        
    } reject:^(NSError *error) {
        
    }];
    
}


-(void)rinoIpcFirstRemoteVideoFrameIpcView:(RinoIpcVideoView *)ipcView uid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    
    //开始推本地音频
    [self.singleModel rinoStartPushLocalAudioSteamEnabled:YES muted:YES formatType:RinoAudioFormatTypeG711U resolve:^(BOOL result) {
        
    } reject:^(NSError *error) {
        
    }];
    //开始推本地视频
    [self.singleModel rinoStartPushLocalVideoSteamEnabled:YES muted:NO renderMode:1 localView:self.localView resolve:^(BOOL result) {
        
    } reject:^(NSError *error) {
        
    }];
    
}


-(RinoIpcVideoView *)ipcView{
    if(_ipcView == nil){
        _ipcView = [[RinoIpcVideoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth(), 180)];
        _ipcView.backgroundColor = [UIColor cyanColor];
    }
    return _ipcView;
}

-(RinoIpcVideoView *)ipcViewTwo{
    if(_ipcViewTwo == nil){
        _ipcViewTwo = [[RinoIpcVideoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ipcView.frame) + 8, kScreenWidth(), 180)];
        _ipcViewTwo.backgroundColor = [UIColor cyanColor];
    }
    return _ipcViewTwo;
}


-(UIView *)localView{
    if(_localView == nil){
        _localView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ipcViewTwo.frame) + 20, 80, 120)];
        _localView.backgroundColor = [UIColor cyanColor];
    }
    return _localView;
}

-(UIButton *)jietuBtn{
    if (_jietuBtn == nil) {
        _jietuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jietuBtn.frame = CGRectMake(CGRectGetMaxX(self.localView.frame) + 20, self.localView.k_y, 80, 40);
        _jietuBtn.backgroundColor = [UIColor cyanColor];
        [_jietuBtn setTitle:@"截图" forState:UIControlStateNormal];
        [_jietuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_jietuBtn addTapBlock:^(UIButton *btn) {
            
        }];
    }
    return _jietuBtn;
}
@end
