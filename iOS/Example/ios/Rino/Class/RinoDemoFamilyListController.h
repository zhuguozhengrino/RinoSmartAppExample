//
//  RinoDemoFmailyListController.h
//  Rino
//
//  Created by super on 2023/12/13.
//
#import <UIKit/UIKit.h>
#import <RinoBusinessLibraryModule/RinoRootViewController.h>
#import <RinoDeviceKit/RinoDeviceKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^RinoDemoFamilyListClickedBlock)(RinoHomeModel *homeModel);
@interface RinoDemoFamilyListController : UIViewController
@property (nonatomic , copy) RinoDemoFamilyListClickedBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
