//
//  RinoPanlControllerManager.h
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoPanlControllerManager : NSObject
+ (instancetype)sharedInstance;

- (void)controllerDealloc;

- (void)controllerviewWillAppear;

- (void)controllerViewWillDisappear;
@end

NS_ASSUME_NONNULL_END
