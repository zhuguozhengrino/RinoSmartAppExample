//
//  RinoPanelMessageVideoViewController.m
//  Rino
//
//  Created by super on 2024/1/25.
//

#import "RinoPanelMessageVideoViewController.h"

#import <MJExtension/MJExtension.h>

@interface RinoPanelMessageVideoViewController ()

@end

@implementation RinoPanelMessageVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.messageModel && self.deviceModel) {
        RinoDevice *device = [RinoDevice deviceWithDeviceId:self.deviceModel.deviceId];
        [RinoPanelManager sharedInstance].deviceModel = device.deviceModel;
        NSMutableDictionary *properties = [[RinoPanelViewModel sharedInstance] getDeviceInitialProperties].mutableCopy;
        NSDictionary *messageParam = [self.messageModel mj_JSONObject];
        [properties setValue:@(self.messageModel.recordStartTime) forKey:@"recordStartTime"];
        [properties setValue:@(self.messageModel.recordTime) forKey:@"recordTime"];
        [properties setValue:@"playback" forKey:@"basePage"];
        [properties setValue:self.messageModel.messageId forKey:@"msgId"];
        [properties setValue:self.messageModel.fromType forKey:@"fromType"];
        
        NSString *storage = @"message";
        if ([self.messageModel.storage isEqualToString:@"local"]) {
            storage = @"sd-back";
        } else if ([self.messageModel.storage isEqualToString:@"cloud"]) {
            storage = @"message";
        } else {
            if (self.skipLocal) {
                storage = @"sd-back";
            } else {
                storage = @"message";
            }
        }
        [properties setValue:storage forKey:@"from"];
        [properties setValue:[messageParam mj_JSONString] forKey:@"param"];
        [self initUIWithProperties:properties];
    }
}

@end
