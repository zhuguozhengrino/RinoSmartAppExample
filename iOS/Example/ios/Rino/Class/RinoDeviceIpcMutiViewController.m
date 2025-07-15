//
//  RinoDeviceIpcMutiViewController.m
//  Rino
//
//  Created by 2bit on 2024/5/24.
//

#import "RinoDeviceIpcMutiViewController.h"
#import <RinoIPCKit/RinoIpcNativeSingleChannelModul.h>
#import <RinoIPCKit/RinoIpcNativeMultichannelModul.h>
#import <RinoIPCKit/RinoIpcSnapShootManger.h>
#import <RinoIPCKit/RinoIpcVideoView.h>
#import <RinoNetworkRequestKit/RinoNetworkRequestKit.h>
#import <RinoDeviceKit/RinoDeviceKit.h>
@interface RinoDeviceIpcMutiViewController ()<RinoIpcNativeMultichannelModulDelegate>
@property (nonatomic , strong) NSArray *deviceIdArr;

@property (nonatomic , strong) NSArray *ipcViewArr;
@property (nonatomic , strong) UIView *localView;

@property (nonatomic , strong) RinoIpcNativeMultichannelModul *multiModul;

@end

@implementation RinoDeviceIpcMutiViewController

-(void)dealloc{
    [self.multiModul destroyMultiInstanceResolve:^(BOOL result) {
        
    } reject:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self multichannel];
    
}

-(void)multichannel{
    [self.view addSubview:self.localView];
    //双目
    self.deviceIdArr = @[@"1789264640269279232",@"1784791914174894080",@"1784791375089950720"];
    CGFloat viewW = (kScreenWidth() - 2 ) / 2;
    CGFloat viewH = 120;
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *viewArr = [NSMutableArray array];
    __block NSString *agoraAppId;
    for (int i = 0; i < self.deviceIdArr.count; i ++) {
        NSString *deviceId = self.deviceIdArr[i];
        dispatch_group_enter(group);
        RinoDevice *device = [RinoDevice deviceWithDeviceId:deviceId];
        [device deviceIpcGetTokenSuccess:^(NSDictionary *data) {
            agoraAppId = [data Rino_StringForKey:@"agoraAppId"];
            NSDictionary *rtcToken = [data DictionaryForKey:@"rtcToken"];
            NSString *rtcTokenStr = [rtcToken StringForKey:@"rtcToken"];
            NSString *channelName = [rtcToken StringForKey:@"channelName"];
            NSInteger uid = [rtcToken IntegerForKey:@"uid"];
            if(device.deviceModel.ipcCameraNum == 1){
                RinoIpcVideoView *videoView = [[RinoIpcVideoView alloc]init];
                videoView.backgroundColor = [UIColor cyanColor];
                videoView.tokenStr = rtcTokenStr;
                videoView.remoteUid = 1;
                videoView.uid = uid;
                videoView.channelName = channelName;
                videoView.deviceId = deviceId;
                [self.view addSubview:videoView];
                [viewArr addObject:videoView];
            }else if (device.deviceModel.ipcCameraNum ==  2){
                RinoIpcVideoView *videoView1 = [[RinoIpcVideoView alloc]init];
                videoView1.backgroundColor = [UIColor cyanColor];
                videoView1.tokenStr = rtcTokenStr;
                videoView1.remoteUid = 1;
                videoView1.uid = uid;
                videoView1.channelName = channelName;
                videoView1.deviceId = deviceId;
                [self.view addSubview:videoView1];
                
                [viewArr addObject:videoView1];
                RinoIpcVideoView *videoView2 = [[RinoIpcVideoView alloc]init];
                videoView2.backgroundColor = [UIColor cyanColor];
                videoView2.tokenStr = rtcTokenStr;
                videoView2.remoteUid = 2;
                videoView2.uid = uid;
                videoView2.channelName = channelName;
                videoView2.deviceId = deviceId;
                [self.view addSubview:videoView2];
                [viewArr addObject:videoView2];
                
            }
            
            [device deviceIpcJoinPullStreemWithData:data success:^{
                NSLog(@"--Engine--通知设备加入频道成功");
            } failure:^(NSError *error) {
                NSLog(@"--Engine--通知设备加入频道失败");
                
            }];
            
            dispatch_group_leave(group);
        } failure:^(NSError *error) {
            dispatch_group_leave(group);
        }];
    }
    
    self.ipcViewArr = viewArr;
    //等上面全部执行完，在执行一下方法
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (int i = 0; i < viewArr.count; i ++) {
            NSInteger rols = i / 2;
            NSInteger cols = i % 2;
            RinoIpcVideoView *videoView = [viewArr Rino_SafeObjectAtIndex:i];
            videoView.frame = CGRectMake(cols * (viewW + 2 ) , rols * (viewH + 2), viewW, viewH);
        }
        self.multiModul = [RinoIpcNativeMultichannelModul rinoInitMultiIpcWithDeviceIds:self.deviceIdArr ipcViewArr:viewArr agoraAppId:agoraAppId delegate:self resolve:^(BOOL result) {
            
        } reject:^(NSError *error) {
            
        }];
        
        
    });
    
    
}






-(void)rinoMultiIpcDeviceId:(NSString *)deviceId remoteVideoStateChanged:(RinoVideoRemoteState)state reason:(RinoVideoRemoteStateReason)reason{
    //    NSLog(@"--Engine--state:%zd--reason:%zd",state,reason);
}

-(void)rinoMultiIpcDeviceId:(NSString *)deviceId connectionChangedToState:(RinoIPCConnectionState)state reason:(RinoConnectionChangedReason)reason{
    //    NSLog(@"--Engine--state:%zd--reason:%zd",state,reason);
}

-(void)rinoMultiIpcDeviceId:(NSString *)deviceId didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    
}


-(void)rinoMultiIpcFirstRemoteVideoFrameIpcView:(RinoIpcVideoView *)ipcView uid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    NSLog(@"--Engine--第一帧终于显示了:ipc——uid:%zd",ipcView.remoteUid);
}

-(UIView *)localView{
    if(_localView == nil){
        _localView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight() - 280, 80, 120)];
        _localView.backgroundColor = [UIColor cyanColor];
    }
    return _localView;
}
@end
