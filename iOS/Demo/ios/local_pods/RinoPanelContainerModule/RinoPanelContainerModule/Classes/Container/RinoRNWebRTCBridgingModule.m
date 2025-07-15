//
//  RinoRNWebRTCBridgingModule.m
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/7/25.
//

#import "RinoRNWebRTCBridgingModule.h"
#import <RinoBizCore/RinoBizCore.h>
#import "RinoRCTWebRTCVideo.h"
#import <RinoIPCKit/RinoWebRTCManager.h>
#import "RinoEmitterModule.h"
@interface RinoRNWebRTCBridgingModule ()<RinoWebRtcProtocol,RinoRtcSignalExchangeProtocol>

@end
@implementation RinoRNWebRTCBridgingModule
+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance registerProtocol];
    });
    return sharedInstance;
}

- (void)registerProtocol {
    RinoBizCore *bizCore = [RinoBizCore sharedInstance];
    [bizCore registerService:@protocol(RinoRtcSignalExchangeProtocol) withInstance:self];
    [bizCore registerService:@protocol(RinoWebRtcProtocol) withInstance:self];
    
}
-(void)rinoIPCSendDataToRn:(NSDictionary *)dataDict{
    [[RinoEmitterModule new] sendPanelNotify:RinoPanelEmitterWebRTCNotify data:dataDict];
}

-(void)rinoRtcSignelExchangeMQTTWithData:(NSDictionary *)data{
    [[RinoWebRTCManager sharedInstance] putRtcSignelExchangeMQTTWithData:data];
}

-(void)rinoWebRtcFirstFrameBlock:(UIView *)videoView{
    RinoRCTWebRTCVideo *webRtcView = (RinoRCTWebRTCVideo *)videoView;
    if (webRtcView.onFirstFrameRendered) {
        webRtcView.onFirstFrameRendered(@{});
    }
    
}

- (void)rinoWebRtcOnFrameResolutionChangedBlock:(UIView *_Nonnull)videoView dataDict:(NSDictionary *_Nonnull)dataDict{
    RinoRCTWebRTCVideo *webRtcView = (RinoRCTWebRTCVideo *)videoView;
    if (webRtcView.onFrameResolutionChanged) {
        webRtcView.onFrameResolutionChanged(dataDict);
    }
}
@end
