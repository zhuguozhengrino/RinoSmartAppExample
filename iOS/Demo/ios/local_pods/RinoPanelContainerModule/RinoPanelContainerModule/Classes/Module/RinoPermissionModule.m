//
//  RinoPermissionModule.m
//  Rino
//
//  Created by zhangstar on 2023/12/14.
//

#import "RinoPermissionModule.h"

@implementation RinoPermissionModule

RCT_EXPORT_MODULE();

/// 检查并申请系统权限
RCT_EXPORT_METHOD(checkAndRequestPermission:(NSString *)permission
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--rn--检查并申请系统权限：%@",permission);
        [[RinoPanelBLEManager sharedInstance] checkAndRequestPermission:permission completion:^(BOOL result) {
            if (result) {
                if (resolve) {
                    resolve([NSNumber numberWithBool:YES]);
                }
            } else {
                NSError *error = [NSError rinoError:-10001 message:@"Permission denied"];
                if (reject) {
                    reject([self rejectCode:error], [self rejectMessage:error], error);
                }
            }
        }];
       
    });
}

///// 检查并申请系统权限
//RCT_EXPORT_METHOD(checkAndRequestPermission:(NSString *)permission
//                  param:(NSString *)param
//                  resolve:(RCTPromiseResolveBlock)resolve
//                  reject:(RCTPromiseRejectBlock)reject) {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"--rn--检查并申请系统权限：%@",permission);
//        [[RinoPanelBLEManager sharedInstance] checkAndRequestPermission:permission param:param completion:^(BOOL result) {
//            if (result) {
//                if (resolve) {
//                    resolve([NSNumber numberWithBool:YES]);
//                }
//            } else {
//                NSError *error = [NSError rinoError:-10001 message:@"Permission denied"];
//                if (reject) {
//                    reject([self rejectCode:error], [self rejectMessage:error], error);
//                }
//            }
//        }];
//       
//    });
//}
/// 检查系统权限
RCT_EXPORT_METHOD(checkPermission:(NSString *)permission
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"--rn--查询系统权限：%@",permission);
        [[RinoPanelBLEManager sharedInstance] checkPermission:permission completion:^(BOOL result) {
            if (result) {
                if (resolve) {
                    resolve([NSNumber numberWithBool:YES]);
                }
            } else {
                NSError *error = [NSError rinoError:-10001 message:@"Permission denied"];
                if (reject) {
                    reject([self rejectCode:error], [self rejectMessage:error], error);
                }
            }
        }];
       
    });
}

/// 开启蓝牙位置服务状态监听(仅安卓端, ios默认支持监听)
RCT_EXPORT_METHOD(startBleLocationListener:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {

}

/// 停止蓝牙位置服务状态监听(仅安卓端, ios默认支持监听)
RCT_EXPORT_METHOD(stopBleLocationListener:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {

}


@end
