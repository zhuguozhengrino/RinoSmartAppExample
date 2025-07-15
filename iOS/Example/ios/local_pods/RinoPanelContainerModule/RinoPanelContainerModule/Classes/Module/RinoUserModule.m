//
//  RinoUserModule.m
//  Rino
//
//  Created by super on 2023/7/4.
//

#import "RinoUserModule.h"

#import <RinoNetworkRequestKit/RinoRequestArchiver.h>

@implementation RinoUserModule

RCT_EXPORT_MODULE();

#pragma mark -  获取当前登录用户信息

RCT_EXPORT_METHOD(getUser:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        RinoUser *user = [RinoUser sharedInstance];
        RinoRequestArchiver *requestArchiver = [RinoRequestArchiver sharedInstance];
        NSDictionary *dataDict = @{@"avatarUrl"     :user.headIconUrl?:@"",
                                   @"registryType"  :@(user.regFrom),
                                   @"email"         :user.email?:@"",
                                   @"id"            :user.userId?:@"",
                                   @"phone"         :user.phoneNumber?:@"",
                                   @"tokenType"     :requestArchiver.tokenType?:@"",
                                   @"accessToken"   :requestArchiver.token?:@"",
                                   @"nickname"      :user.nickname?:@"",
                                   @"countryCode"   :user.countryCode?:@"",
                                   @"areaCode"      :user.countryCode?:@"",
                                   @"latestLoginTime":@"",
                                   @"tz"            :user.timeZone?:@"",
                                   @"userName"      :user.userName?:@""};
        
        NSString *dictJson = [dataDict mj_JSONString];
        if (resolve) {
            resolve(dictJson);
        }
    });
}

@end
