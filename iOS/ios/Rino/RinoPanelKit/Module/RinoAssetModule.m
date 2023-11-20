//
//  RinoAssetModule.m
//  Rino
//
//  Created by super on 2023/7/4.
//

#import "RinoAssetModule.h"

#import <RinoDeviceKit/RinoDeviceKit.h>
#import <RinoLaunchMenuKit/RinoLaunchMenuKit.h>

@implementation RinoAssetModule
RCT_EXPORT_MODULE();

/// 获取当前家庭（资产）ID
RCT_EXPORT_METHOD(getCurrentAssetId:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = [RinoGlobalHomeManager sharedInstance].homeId?:@"";
        if (resolve) {
            resolve(homeId);
        }
    });
}

/// 获取当前家庭（资产）的房间（子资产）
RCT_EXPORT_METHOD(getRooms:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = [RinoGlobalHomeManager sharedInstance].homeId?:@"";
        RinoHome *home = [RinoHome homeWithHomeId:homeId];
        NSArray *roomArr = home.roomList;
        NSMutableArray *roomDictArr = [NSMutableArray array];
        for (RinoRoomModel *roomModel in roomArr) {
            NSDictionary *roomDict = [roomModel mj_JSONObject];
            [roomDictArr addObject:roomDict];
        }
        NSString *roomsJson = [roomDictArr mj_JSONString];
        if (resolve) {
            resolve(roomsJson);
        }
    });
}

@end
