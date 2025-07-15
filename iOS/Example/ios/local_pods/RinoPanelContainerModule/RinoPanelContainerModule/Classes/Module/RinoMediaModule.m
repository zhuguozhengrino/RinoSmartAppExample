//
//  RinoMediaModule.m
//  RinoPanelContainerModule
//
//  Created by 2bit on 2025/3/11.
//

#import "RinoMediaModule.h"
#import <RinoIPCKit/RinoIPCKit.h>
@implementation RinoMediaModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(startRecordVoiceToLocalFile:(NSString *)jsonParam
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoAudioMediaManager sharedInstance] rinoAudioMediaStartRecordingWithJsonStr:jsonParam resolve:^(BOOL result) {
            if (resolve) {
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}
RCT_EXPORT_METHOD(stopRecordVoiceToLocalFile:(NSString *)recorderKey
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoAudioMediaManager sharedInstance] rinoAudioMediaStopRecordVoiceWithRecorderKey:recorderKey resolve:^(BOOL result) {
            if (resolve) {
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

RCT_EXPORT_METHOD(operateVoicePlayer:(NSString *)jsonParam
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[RinoAudioMediaManager sharedInstance] rinoVoicePlayerWithJsonStr:jsonParam resolve:^(BOOL result) {
            if (resolve) {
                resolve([NSNumber numberWithBool:result]);
            }
        } reject:^(NSError *error) {
            if (reject) {
                reject(@(error.code).stringValue, [error.userInfo StringForKey:NSLocalizedDescriptionKey], error);
            }
        }];
    });
}

@end
