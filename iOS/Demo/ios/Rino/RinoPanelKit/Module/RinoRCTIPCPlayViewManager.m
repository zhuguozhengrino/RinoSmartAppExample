//
//  RinoRCTIPCPlayViewManager.m
//  Rino
//
//  Created by zhangstar on 2023/4/4.
//

#define RinoDefaultIPCVideoHeight    240

#import "RinoRCTIPCPlayViewManager.h"
#import <RinoPanelKit/RinoPanelKit.h>
#import "RinoIPCPlay.h"

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
}
RCT_CUSTOM_VIEW_PROPERTY(role, NSString, RinoIPCPlay) {
    [view setRole:json];
    
    
}
RCT_CUSTOM_VIEW_PROPERTY(solution, solution, RinoIPCPlay) {
    [view setSolution:json];
    
    
}



RCT_REMAP_VIEW_PROPERTY(Style, NSString, NSDictionary)



RCT_EXPORT_VIEW_PROPERTY(onStatusChange, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onOtherBusiness, RCTBubblingEventBlock)

#pragma mark - Private
- (void)p2pConenctChangeStatus:(NSString *)status viewId:(NSString *)viewId{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
    });
}

@end
