//
//  RinoPanelMessageVideoViewController.h
//  Rino
//
//  Created by super on 2024/1/25.
//

#import "RinoBasePanelViewController.h"
#import <RinoMessageKit/RinoMessageKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoPanelMessageVideoViewController : RinoBasePanelViewController

@property (nonatomic , strong) RinoMessageModel *messageModel;

@property (nonatomic , strong) RinoDeviceModel *deviceModel;

@property (nonatomic, assign) BOOL skipLocal;
@end

NS_ASSUME_NONNULL_END
