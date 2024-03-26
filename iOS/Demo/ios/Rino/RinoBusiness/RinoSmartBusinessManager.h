//
//  RinoSmartBusinessManager.h
//  Rino
//
//  Created by zhangstar on 2023/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoSmartBusinessManager : NSObject

+ (instancetype)sharedInstance;

/// 注册协议
- (void)registerProtocol;

/// 初始化监听
- (void)initBusinessMonitor;

@end

NS_ASSUME_NONNULL_END
