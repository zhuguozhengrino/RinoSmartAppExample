//
//  RinoRCTIPCAgoraManager.m
//  Rino
//
//  Created by super on 2023/12/29.
//

#import "RinoRCTIPCAgoraManager.h"
#import "RinoAgoraPlayView.h"

#import <RinoIPCKit/RinoIPCKit.h>

static id rctPlayViewV2SharedInstance = nil;
static dispatch_once_t rctPlayViewV2OnceToken;

@implementation RinoRCTIPCAgoraManager
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&rctPlayViewV2OnceToken, ^{
        rctPlayViewV2SharedInstance = [super allocWithZone:zone];
    });
    return rctPlayViewV2SharedInstance;
}

RCT_EXPORT_MODULE(RinoAgoraPlayView)



- (UIView *)view {
    NSLog(@"--Engine--:创建新的view");
    RinoAgoraPlayView *videoView = [[RinoAgoraPlayView alloc]init];
    return videoView;
}

RCT_CUSTOM_VIEW_PROPERTY(playViewId, NSString, RinoAgoraPlayView) {
    NSLog(@"--Engine-—playViewId:%@",json);
    [view setPlayViewId:json];
    NSMutableArray *exitViewArr = [RinoAgoraRtcEngineManager_V2 sharedInstance].ipcViewArr;
    if(exitViewArr.count > 0){
        NSArray *tempArr = exitViewArr.copy;
        for (RinoAgoraPlayView *playView in tempArr) {
            if([playView.playViewId isEqualToString:json]){
                [exitViewArr removeObject:playView];
                NSLog(@"--Engine-—视图已经存在");
            }
        }
        [exitViewArr addObject:view];
    }else{
        [exitViewArr addObject:view];
    }
    [RinoAgoraRtcEngineManager_V2 sharedInstance].ipcViewArr = exitViewArr;
    if(view.onReady){
        view.onReady(@{@"onReady":@"true"});
    }
}

RCT_EXPORT_VIEW_PROPERTY(onReady, RCTBubblingEventBlock)



@end
