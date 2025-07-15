//
//  RinoQRCodeView.m
//  Rino
//
//  Created by super on 2023/7/5.
//

#import "RinoQRCodeView.h"
#import "RinoEmitterModule.h"

#import <RinoUIKit/RinoUIKit.h>

@interface RinoQRCodeView ()

@property (nonatomic, strong) UIImageView *qrCodeimageView;
@property (nonatomic, strong) NSString *level;

@end

@implementation RinoQRCodeView

- (void)setData:(NSString *)data {
    _data = data;
    
    if (!self.qrCodeimageView) {
        self.qrCodeimageView = [[UIImageView alloc] init];
        self.qrCodeimageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.qrCodeimageView];
    }
        
    self.qrCodeimageView.frame = CGRectMake(0, 0, self.k_width, self.k_height);
    self.qrCodeimageView.image = [UIImage generateQRCode:data level:self.level version:0 size:self.k_width];
}

- (void)setErrorCorrectionLevel:(NSInteger)errorCorrectionLevel {
    _errorCorrectionLevel = errorCorrectionLevel;
    
    switch (errorCorrectionLevel) {
        case 0:
            _level = @"L";
            break;
        case 1:
            _level = @"M";
            break;
        case 2:
            _level = @"Q";
            break;
        case 3:
            _level = @"H";
            break;
        default:
            _level = @"M";
            break;
    }
}

@end
