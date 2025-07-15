//
//  RinoBasicPanelLoadingView.m
//  Rino
//
//  Created by zhangstar on 2024/1/17.
//

#import "RinoBasicPanelLoadingView.h"

#import <Masonry/Masonry.h>
#import <RinoAppConfigModule/RinoAppConfigModule.h>
#import <RinoLanguageKit/RinoLanguageKit.h>
#import <RinoLibraryModule/RinoProgressLineView.h>
#import <RinoPanelContainerModule/RinoPanelContainerModule-Swift.h>
#import <RinoUIKit/RinoUIKit.h>

@interface RinoBasicPanelLoadingView ()

@property (nonatomic, strong) RinoBasicPanelAnimationView *animateView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RinoProgressLineView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;

@end

@implementation RinoBasicPanelLoadingView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat margin = kWidthReal(56);
    [self.animateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(kHeightReal(227));
        make.size.mas_equalTo(CGSizeMake(82, 88));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.top.equalTo(self.animateView.mas_bottom).offset(kHeightReal(36));
        make.right.equalTo(self).offset(-margin);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.titleLabel);
        make.height.mas_equalTo(4);
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.progressView.mas_bottom).offset(kHeightReal(12));
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.animateView) {
        [self.animateView beginAnimation];
    }
}

- (void)initUI {
    self.animateView = [[RinoBasicPanelAnimationView alloc] init];
    [self addSubview:self.animateView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = Theme().H1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = SystemFont(17);
    self.titleLabel.hidden = YES;
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    self.progressView = [[RinoProgressLineView alloc] init];
    self.progressView.progressColor = Theme().themeColor;
    self.progressView.progressBGColor = HexString(@"#EEEEF2");
    self.progressView.layer.cornerRadius = 2;
    self.progressView.hidden = YES;
    [self addSubview:self.progressView];
    
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.textColor = Theme().H1;
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.font = SystemFont(14);
    self.progressLabel.hidden = YES;
    [self addSubview:self.progressLabel];
}

- (void)setErrorMessage:(NSString *)errorMessage {
    _errorMessage = errorMessage;
    
    if (errorMessage.length > 0) {
        self.titleLabel.hidden = NO;
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
    }
    self.titleLabel.text = @"rino_common_load_fail".localized;
}

- (void)setProgress:(NSInteger)progress {
    _progress = progress;
    
    if (self.progressLabel.hidden) {
        self.titleLabel.hidden = YES;
        self.progressView.hidden = NO;
        self.progressLabel.hidden = NO;
    }
    self.progressView.progress = progress / 100.0;
    self.progressLabel.text = [NSString stringWithFormat:@"%@ %@%%", @"rino_common_loading".localized, @(progress).stringValue];
}

@end
