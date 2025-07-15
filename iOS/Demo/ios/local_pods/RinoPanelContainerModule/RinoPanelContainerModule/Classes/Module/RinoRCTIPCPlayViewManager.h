//
//  RinoRCTIPCPlayViewManager.h
//  Rino
//
//  Created by zhangstar on 2023/4/4.
//

#import <React/RCTViewManager.h>
#import "RinoEmitterModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface RinoRCTIPCPlayViewManager : RCTViewManager

- (void)p2pConenctChangeStatus:(NSString *)status viewId:(NSString *)viewId;

@end

NS_ASSUME_NONNULL_END
