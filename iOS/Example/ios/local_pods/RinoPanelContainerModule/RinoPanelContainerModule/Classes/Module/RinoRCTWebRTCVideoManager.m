//
//  RinoRCTWebRTCVideoManager.m
//  Rino
//
//  Created by 2bit on 2024/7/17.
//

#import "RinoRCTWebRTCVideoManager.h"
#import "RinoRCTWebRTCVideo.h"
#import <RinoIPCKit/RinoWebRTCManager.h>
static id WebRTCViewV2SharedInstance = nil;
static dispatch_once_t WebRTCViewV2OnceToken;

@implementation RinoRCTWebRTCVideoManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&WebRTCViewV2OnceToken, ^{
        WebRTCViewV2SharedInstance = [super allocWithZone:zone];
    });
    return WebRTCViewV2SharedInstance;
}
RCT_EXPORT_MODULE(RinoRCTWebRTCVideo)

- (UIView *)view {
    NSLog(@"--webrtc--创建新的view");
    RinoRCTWebRTCVideo *videoView = [[RinoRCTWebRTCVideo alloc]init];
    return videoView;
}

RCT_CUSTOM_VIEW_PROPERTY(peerClientId, NSString, RinoRCTWebRTCVideo) {
    NSLog(@"--webrtc--设置peerClientId:%@",json);
    view.peerClientId = json;
    if (view.peerClientId.length > 0 && view.streamId.length > 0) {
        [[RinoWebRTCManager sharedInstance] setViewSreamId:view.streamId peerClientId:view.peerClientId videoView:view];
    }
    
}

RCT_CUSTOM_VIEW_PROPERTY(streamId, NSString, RinoRCTWebRTCVideo) {
    NSLog(@"--webrtc--设置streamId:%@", json);
    view.streamId = json;
    if (view.peerClientId.length > 0 && view.streamId.length > 0) {
        [[RinoWebRTCManager sharedInstance] setViewSreamId:view.streamId peerClientId:view.peerClientId videoView:view];
    }
}

RCT_EXPORT_VIEW_PROPERTY(onFirstFrameRendered, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onReady, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onFrameResolutionChanged, RCTBubblingEventBlock)


@end
