//
//  RinoRCTVideoManager.h
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/12/4.
//

#import <React/RCTViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoRCTVideoManager : RCTViewManager
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSMutableArray *rctViewArr;

@property (nonatomic, strong) NSMutableArray *releaseIdArr;

@end

NS_ASSUME_NONNULL_END
