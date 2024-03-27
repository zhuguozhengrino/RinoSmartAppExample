//
//  RinoBasePanelViewController.h
//  Rino
//
//  Created by zhangstar on 2022/11/15.
//

#import <RinoBusinessLibraryModule/RinoRootViewController.h>
#import <RinoPanelKit/RinoPanelKit.h>

#if __has_include(<React/RCTRootView.h>)
#import <React/RCTRootView.h>
#else
#import "RCTRootView.h"
#endif

#if __has_include(<React/RCTAssert.h>)
#import <React/RCTEventDispatcher.h>
#import <React/RCTDevSettings.h>
#import <React/RCTPerformanceLogger.h>
#import <React/RCTAssert.h>
#import <React/RCTBridge+Private.h>
#else
#import "RCTEventDispatcher.h"
#import "RCTDevSettings.h"
#import "RCTPerformanceLogger.h"
#import "RCTAssert.h"
#endif

#import "RinoEmitterModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface RinoBasePanelViewController : RinoRootViewController

@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, strong) RCTRootView *rootView;
@property (nonatomic, strong) RinoEmitterModule *emitter;

- (void)initUIWithProperties:(NSDictionary *)properties;

@end

NS_ASSUME_NONNULL_END
