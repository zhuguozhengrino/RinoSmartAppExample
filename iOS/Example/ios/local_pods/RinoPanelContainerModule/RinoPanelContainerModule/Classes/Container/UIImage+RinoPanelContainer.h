//
//  UIImage+RinoPanelContainer.h
//  RinoPanelContainerModule
//
//  Created by zhangstar on 2024/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN UIImage * RinoPanelContainerImageNamed(NSString *name);

@interface UIImage (RinoPanelContainer)

+ (UIImage *)RinoPanelContainerImageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
