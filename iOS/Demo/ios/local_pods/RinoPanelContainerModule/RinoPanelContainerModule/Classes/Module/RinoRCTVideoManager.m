//
//  RinoRCTVideoManager.m
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/12/4.
//

#import "RinoRCTVideoManager.h"
#import "RinoRCTVideo.h"
static id RCTVideoSharedInstance = nil;
static dispatch_once_t RCTVideo2OnceToken;

@implementation RinoRCTVideoManager
+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSMutableArray *)rctViewArr{
    if (_rctViewArr == nil) {
        _rctViewArr = [NSMutableArray array];
    }
    return _rctViewArr;
}

-(NSMutableArray *)releaseIdArr{
    if (_releaseIdArr == nil) {
        _releaseIdArr = [NSMutableArray array];
    }
    return _releaseIdArr;
}

RCT_EXPORT_MODULE(RinoRCTVideoManager)

- (UIView *)view {
    NSLog(@"--RCTVideo--创建新的view");
    RinoRCTVideo *videoView = [[RinoRCTVideo alloc]init];
    [[RinoRCTVideoManager sharedInstance].rctViewArr addObject:videoView];
    return videoView;
}

RCT_CUSTOM_VIEW_PROPERTY(playerID, NSString, RinoRCTVideo) {
    view.playerID = json;
}

RCT_CUSTOM_VIEW_PROPERTY(source, NSDictionary, RinoRCTVideo) {
   
    view.source = json;
}

RCT_CUSTOM_VIEW_PROPERTY(paused, BOOL, RinoRCTVideo) {
    view.paused = [json boolValue];
}

RCT_CUSTOM_VIEW_PROPERTY(seek, float, RinoRCTVideo) {
    view.seek = [json floatValue];
}


RCT_CUSTOM_VIEW_PROPERTY(progressUpdateInterval, float, RinoRCTVideo) {
    
    view.progressUpdateInterval = [json floatValue];
}

RCT_CUSTOM_VIEW_PROPERTY(speed, float, RinoRCTVideo) {
    
    view.speed = [json floatValue];
}

RCT_CUSTOM_VIEW_PROPERTY(volume, float, RinoRCTVideo) {
    
    view.volume = [json floatValue];
}

RCT_EXPORT_VIEW_PROPERTY(onVideoEnd, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onVideoError, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onVideoLoadStart, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onVideoLoad, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onVideoProgress, RCTDirectEventBlock)



@end
