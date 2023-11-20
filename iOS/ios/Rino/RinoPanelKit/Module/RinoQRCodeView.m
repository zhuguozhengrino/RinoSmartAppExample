//
//  RinoQRCodeView.m
//  Rino
//
//  Created by super on 2023/7/5.
//

#import "RinoQRCodeView.h"

@interface RinoQRCodeView ()

@property (nonatomic, strong) UIImageView *qrCodeimageView;

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
    self.qrCodeimageView.image = [UIImage generateQRCode:data size:CGSizeMake(self.k_width, self.k_height)];
}

@end
