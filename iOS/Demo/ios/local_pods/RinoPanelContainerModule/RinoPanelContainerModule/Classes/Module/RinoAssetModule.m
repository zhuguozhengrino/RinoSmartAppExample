//
//  RinoAssetModule.m
//  Rino
//
//  Created by super on 2023/7/4.
//

#import "RinoAssetModule.h"

#import <RinoBizCore/RinoBizCore.h>

@implementation RinoAssetModule

RCT_EXPORT_MODULE();

/// 获取当前家庭（资产）ID
RCT_EXPORT_METHOD(getCurrentAssetId:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = [self homeId];
        if (resolve) {
            resolve(homeId);
        }
    });
}

/// 获取当前家庭（资产）的房间（子资产）
RCT_EXPORT_METHOD(getRooms:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = [self homeId];
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

///3. 获取家庭列表
RCT_EXPORT_METHOD(getFamilies:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *homes = [[RinoHomeArchiver sharedInstance] loadHomeModelCache];
        NSMutableArray *homeList = [NSMutableArray array];
        for (RinoHomeModel *homeModel in homes) {
            NSDictionary *homeDict = [homeModel mj_JSONObject];
            [homeList addObject:homeDict];
        }
        NSString *homeJson = [homeList mj_JSONString];
        if (resolve) {
            resolve(homeJson);
        }
    });
}

/// 4. 获取当前家庭（资产）的详细数据
RCT_EXPORT_METHOD(getCurrentFamilyDetail:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *homeId = [self homeId];
        RinoHome *home = [RinoHome homeWithHomeId:homeId];
        RinoHomeModel *homeModel = home.homeModel;
        NSMutableArray *members = [NSMutableArray array];
        for (RinoHomeMemberModel *memberModel in home.memberList) {
            NSDictionary *memberDict = [memberModel mj_JSONObject];
            [members addObject:memberDict];
        }
        NSMutableArray *childrens = [NSMutableArray array];
        for (RinoRoomModel *roomModel in home.roomList) {
            NSDictionary *roomDict = [roomModel mj_JSONObject];
            [childrens addObject:roomDict];
        }
        
        NSMutableDictionary *homeDict = [NSMutableDictionary dictionary];
        [homeDict setValue:homeModel.homeId forKey:@"id"];
        [homeDict setValue:@(homeModel.latitude) forKey:@"lat"];
        [homeDict setValue:@(homeModel.longitude) forKey:@"lng"];
        [homeDict setValue:homeModel.name forKey:@"name"];
        [homeDict setValue:members forKey:@"members"];
        [homeDict setValue:@(homeModel.role) forKey:@"role"];
        [homeDict setValue:childrens forKey:@"childrens"];
        NSString *homeJson = [homeDict mj_JSONObject];
        if (resolve) {
            resolve(homeJson);
        }
    });
}

@end
