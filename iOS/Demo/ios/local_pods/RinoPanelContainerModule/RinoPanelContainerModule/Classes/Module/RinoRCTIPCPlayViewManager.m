//
//  RinoRCTIPCPlayViewManager.m
//  Rino
//
//  Created by zhangstar on 2023/4/4.
//

#import "RinoRCTIPCPlayViewManager.h"
#import "RinoRNP2PBridgingModule.h"
#import "RinoIPCPlay.h"

#import <RinoCommonDefineKit/RinoCommonDefineKit.h>
#import <RinoFoundationKit/RinoFoundationKit.h>
#import <RinoIPCKit/RinoIPCKit.h>
#import <RinoPanelKit/RinoPanelKit.h>

#define RinoDefaultIPCVideoHeight    240

@interface RinoRCTIPCPlayViewManager ()

@end

static id rctPlayViewSharedInstance = nil;
static dispatch_once_t rctPlayViewOnceToken;

@implementation RinoRCTIPCPlayViewManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&rctPlayViewOnceToken, ^{
        rctPlayViewSharedInstance = [super allocWithZone:zone];
        [[NSNotificationCenter defaultCenter] addObserver:rctPlayViewSharedInstance selector:@selector(rinoPanelScreenChange:) name:RinoSetScreenDirectionChangeNoti object:nil];
    });
    return rctPlayViewSharedInstance;
}

RCT_EXPORT_MODULE(RinoIPCPlay)

- (void)rinoPanelScreenChange:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *orentation = [notification.userInfo StringForKey:@"Orentation"];
        NSInteger type = 0;
        if([orentation isEqualToString:RinoSetScreenDirectionPortrait]){
            type = 1;
        }else if ([orentation isEqualToString:RinoSetScreenDirectionReverse_Portrait]){
            type = 1;
        }else if ([orentation isEqualToString:RinoSetScreenDirectionLandscape]){
            type = 2;
        }else if ([orentation isEqualToString:RinoSetScreenDirectionReverse_Landscape]){
            type = 2;
        }else if ([orentation isEqualToString:RinoSetScreenDirectionAuto_rotate]){

        }
    });
}

- (UIView *)view {
//    NSLog(@"--Engine--:创建新的view");
    RinoIPCPlay *videoView = [[RinoIPCPlay alloc]init];
    return videoView;
}

RCT_CUSTOM_VIEW_PROPERTY(id, NSString, RinoIPCPlay) {
    NSLog(@"--Engine--viewId:%@",json);
    [view setID:json];
    [[RinoAgoraRtcEngineManager sharedInstance] initModelDataWithViewId:json];
    
}
RCT_CUSTOM_VIEW_PROPERTY(role, NSString, RinoIPCPlay) {
    [view setRole:json];
    NSLog(@"--Engine--role:%@",json);
    RinoAgoraRtcEngineDataModel *dataModel = [[RinoAgoraRtcEngineManager sharedInstance] getDataModelWithViewId:view.ID];
    BOOL isExit = NO;
    for (RinoIPCPlay *ipcView in dataModel.videoViewArr) {
        if([ipcView.role isEqualToString:json]){
            isExit = YES;
            NSLog(@"--Engine-- 视图已经存在");
            [dataModel rinoRemoteVideo:view role:view.role];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(view.onStatusChange){
                    NSLog(@"--Engine--status:%@",ipcView.status);
                    view.onStatusChange(@{@"status":ipcView.status});
                }
            });
            return;
        }
    }
    if(!isExit){
        [dataModel.videoViewArr addObject:view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(view.onStatusChange){
                NSLog(@"--Engine--status:%@",RinoIPCStatusForInit);
                view.onStatusChange(@{@"status":RinoIPCStatusForInit});
            }
        });
    }
    
}
RCT_CUSTOM_VIEW_PROPERTY(solution, solution, RinoIPCPlay) {
    [view setSolution:json];
    NSString *solution = [NSString stringWithFormat:@"%@",json];
    if([solution isEqualToString:@"ShangYun"]){
        [RinoIpcRNFunctionModul sharedInstance].solutionType = RinoIPCConnectSolutionTypeShangYun;
    }else if ([solution isEqualToString:@"Agora"]){
        [RinoIpcRNFunctionModul sharedInstance].solutionType = RinoIPCConnectSolutionTypeAgora;
    }
    
}



RCT_REMAP_VIEW_PROPERTY(Style, NSString, NSDictionary)



RCT_EXPORT_VIEW_PROPERTY(onStatusChange, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onOtherBusiness, RCTBubblingEventBlock)

#pragma mark - Private
- (void)p2pConenctChangeStatus:(NSString *)status viewId:(NSString *)viewId{
    dispatch_async(dispatch_get_main_queue(), ^{
        RinoAgoraRtcEngineDataModel *dataModel = [[RinoAgoraRtcEngineManager sharedInstance] getDataModelWithViewId:viewId];
        for (RinoIPCPlay *videoView in dataModel.videoViewArr) {
            if(videoView.onStatusChange){
                videoView.onStatusChange(@{@"status":status});
            }
        }
        
    });
}

@end
