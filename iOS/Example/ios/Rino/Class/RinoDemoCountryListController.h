//
//  RinoDemoCountryListController.h
//  Rino
//
//  Created by super on 2023/12/13.
//
#import <RinoBusinessLibraryModule/RinoRootViewController.h>
#import <RinoBaseKit/RinoBaseKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^RinoDemoCountryListClickedBlock)(RinoCountryModel *countryModel);
@interface RinoDemoCountryListController : RinoRootViewController

@property (nonatomic , copy) RinoDemoCountryListClickedBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
