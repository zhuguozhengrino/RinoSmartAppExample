//
//  RinoBasicPanelViewController.h
//  Rino
//
//  Created by zhangstar on 2024/1/17.
//

#import <RinoBusinessLibraryModule/RinoRootViewController.h>
#import <RinoDebugKit/RinoDebugKit.h>

#import <Masonry/Masonry.h>
#import <React/RCTRootView.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTDevSettings.h>
#import <React/RCTPerformanceLogger.h>
#import <React/RCTAssert.h>
#import <React/RCTBridge+Private.h>

#import "RinoBasicPanelLoadingView.h"
#import "RinoEmitterModule.h"
#import "UIImage+RinoPanelContainer.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *RinoPanelModuleNameDevicePanel;
extern NSString *RinoPanelModuleNameActivatorPanel;
extern NSString *RinoPanelModuleNameVestPanel;

@interface RinoBasicPanelViewController : RinoRootViewController

@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, strong) RCTRootView *rootView;
@property (nonatomic, strong) RinoBasicPanelLoadingView *loadingView;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) RinoEmitterModule *emitter;
@property (nonatomic, strong) RinoDebugManager *debugManager;
@property (nonatomic, strong) RinoPanelManager *panelManager;

- (void)initPanelWithModuleName:(NSString *)moduleName properties:(NSDictionary *)properties;

- (void)sendPanelNotify:(NSString *)notifyName data:(id)data;

- (void)hideLoadingView;

@end

NS_ASSUME_NONNULL_END
