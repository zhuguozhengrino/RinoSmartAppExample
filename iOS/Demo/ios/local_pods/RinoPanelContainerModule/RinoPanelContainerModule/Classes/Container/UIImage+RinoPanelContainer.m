//
//  UIImage+RinoPanelContainer.m
//  RinoPanelContainerModule
//
//  Created by zhangstar on 2024/6/18.
//

#import "UIImage+RinoPanelContainer.h"
#import <RinoFoundationKit/RinoFoundationKit.h>

static NSString *RinoPanelContainerBundleKey = @"RinoPanelContainerModule";

UIImage * RinoPanelContainerImageNamed(NSString *name) {
    return [UIImage RinoPanelContainerImageNamed:name];
}

@implementation UIImage (RinoPanelContainer)

+ (UIImage *)RinoPanelContainerImageNamed:(NSString *)name {
    if (!name) return nil;
    
    UIImage *image = [self imageNamed:name];
    if (!image) {
        NSString *imageName = [NSString RinoSDKImageNameWithSDKName:RinoPanelContainerBundleKey xcassetsName:@"images" imageNamed:name];
        UIImage *image = [self imageNamed:imageName];
        if (image) {
            return image;
        } else {
            image = [self panelContainerImagesAssetsImageNamed:name];
            if (image) {
                return image;
            }
        }
    }
    return image;
}

+ (UIImage *)panelContainerImagesAssetsImageNamed:(NSString *)name {
    static NSString *bundlePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundlePath = [[NSBundle mainBundle] pathForResource:RinoPanelContainerBundleKey ofType:@"bundle"];
    });
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
