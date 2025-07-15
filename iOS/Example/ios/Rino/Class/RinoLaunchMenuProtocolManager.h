//
//  RinoLaunchMenuProtocolManager.h
//  Rino
//
//  Created by zhangstar on 2024/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoLaunchMenuProtocolManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerProtocol;

///更新家庭 id
-(void)updateHomeId:(NSString *)homeId;

@end

NS_ASSUME_NONNULL_END
