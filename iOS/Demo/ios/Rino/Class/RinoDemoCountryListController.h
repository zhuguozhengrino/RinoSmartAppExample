//
//  RinoDemoCountryListController.h
//  Rino
//
//  Created by super on 2023/12/13.
//

#import <UIKit/UIKit.h>
#import <RinoBaseKit/RinoBaseKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^RinoDemoCountryListClickedBlock)(RinoCountryModel *countryModel);
@interface RinoDemoCountryListController : UIViewController

@property (nonatomic , copy) RinoDemoCountryListClickedBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
