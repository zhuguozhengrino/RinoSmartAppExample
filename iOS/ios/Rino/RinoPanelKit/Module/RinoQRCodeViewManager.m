//
//  RinoQRCodeViewManager.m
//  Rino
//
//  Created by super on 2023/7/5.
//

#import "RinoQRCodeViewManager.h"
#import "RinoQRCodeView.h"

@interface RinoQRCodeViewManager ()

@property (nonatomic, strong) RinoQRCodeView *qrCodeView;

@end

@implementation RinoQRCodeViewManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return self.qrCodeView;
}

RCT_CUSTOM_VIEW_PROPERTY(data, NSString, UIView) {
    self.qrCodeView.frame = view.frame;
    self.qrCodeView.data = json;
}

#pragma mark - Lazy Load

- (RinoQRCodeView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[RinoQRCodeView alloc] init];
    }
    return _qrCodeView;
}

@end
