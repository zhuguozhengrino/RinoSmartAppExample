//
//  RinoRCTWebRTCVideo.h
//  Rino
//
//  Created by 2bit on 2024/7/17.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <WebRTC/WebRTC.h>
NS_ASSUME_NONNULL_BEGIN

@interface RinoRCTWebRTCVideo : RTCMTLVideoView


@property (nonatomic, strong) NSString *peerClientId;

@property (nonatomic, strong) NSString *streamId;

@property (nonatomic, copy) RCTBubblingEventBlock onReady;

@property (nonatomic, copy) RCTBubblingEventBlock onFirstFrameRendered;

@property (nonatomic, copy) RCTBubblingEventBlock onFrameResolutionChanged;
@end

NS_ASSUME_NONNULL_END
