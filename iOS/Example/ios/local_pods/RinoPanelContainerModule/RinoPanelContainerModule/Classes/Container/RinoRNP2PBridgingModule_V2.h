//
//  RinoRNP2PBridgingModule_V2.h
//  Rino
//
//  Created by super on 2023/12/29.
//

#import <Foundation/Foundation.h>
#import <RinoDeviceKit/RinoDeviceKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RinoRNP2PBridgingModule_V2 : NSObject
@property (nonatomic , strong) RinoDeviceModel *deviceModel;
+ (instancetype)sharedInstance;
/// 注册协议
- (void)registerProtocol;
#pragma mark - 销毁对象
- (void)destructionInstance;
@end

NS_ASSUME_NONNULL_END
