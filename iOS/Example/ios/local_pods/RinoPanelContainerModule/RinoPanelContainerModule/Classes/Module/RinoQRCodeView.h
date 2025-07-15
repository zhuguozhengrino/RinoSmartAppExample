//
//  RinoQRCodeView.h
//  Rino
//
//  Created by super on 2023/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoQRCodeView : UIView

@property (nonatomic, strong) NSString *data;

@property (nonatomic, assign) NSInteger errorCorrectionLevel;

@end

NS_ASSUME_NONNULL_END
