//
//  RinoPanelOperationView.m
//  Rino
//
//  Created by zhangstar on 2022/11/11.
//

#import "RinoPanelOperationView.h"

#import <RinoCommonDefineKit/RinoCommonDefineKit.h>
#import <RinoDebugKit/RinoDebugKit.h>
#import <RinoPanelKit/RinoPanelKit.h>
#import <RinoUIKit/RinoUIKit.h>

#import <React/RCTRootView.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTDevSettings.h>
#import <React/RCTPerformanceLogger.h>
#import <React/RCTAssert.h>
#import <React/RCTBridge+Private.h>

@interface RinoPanelOperationView ()<RCTBridgeDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, strong) RCTRootView *rootView;

@property (nonatomic, strong) RinoPanelManager *panelManager;

@end

@implementation RinoPanelOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self checkOperationViewFilePath];
        [self initOperationPanelView];
    }
    return self;
}

#pragma mark - View

- (void)initOperationPanelView {
    self.bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
    self.rootView = [[RCTRootView alloc] initWithBridge:self.bridge
                                             moduleName:@"RinoRCTApp"
                                       initialProperties:@{}];
    self.rootView.backgroundColor = [UIColor clearColor];
    self.rootView.frame = CGRectMake(0, 0, self.backView.k_width, self.backView.k_height);
}

- (void)deallocPanelView {
    self.bridge = nil;
    [self.rootView removeFromSuperview];
    self.rootView = nil;
}

#pragma mark - Public

- (void)show {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.frame = CGRectMake(0, 0, kScreenWidth(), kScreenHeight());
    self.alpha = 0;
    [MainWindow() addSubview:self];
    [self addSubview:self.backView];
    [self.backView addSubview:self.rootView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:RinoNotificationPanelBackPreviousView object:nil];

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.backView.k_y = kScreenHeight() - self.backView.k_height;
    }];
}

#pragma mark - Private

- (void)hide {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.backView.k_y = kScreenHeight();
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)checkOperationViewFilePath {
    if (![self.panelManager checkShortcutPanelFileResource]) {
        [self.panelManager unzipShortcutPanel];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    NSString *viewName = NSStringFromClass([view class]);
    if (view != self.backView && ![viewName containsString:@"RN"] && ![viewName containsString:@"RCT"]) {
        
        [self hide];
    }
}

#pragma mark - RCTBridgeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    if ([RinoDebugManager sharedInstance].debugOperationPanel) {
        NSString *ip = [RinoDebugManager sharedInstance].debugOperationPanelIP?:@"";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index.bundle?platform=ios&dev=true", ip]];
        return url;
    } else {
        NSString *resUrl;
        NSURL *url;
        if ([self.panelManager checkShortcutPanelFileResource]) {
            resUrl = [self.panelManager getShortcutPanelResourceFilePath];
        }
        if (resUrl.length > 0) {
            url = [NSURL fileURLWithPath:resUrl];
        } else {
            resUrl = [[NSBundle mainBundle] pathForResource:@"index.ios" ofType:@"bundle"];
            url = [NSURL URLWithString:resUrl];
        }
        return url;
    }
}

- (void)backPreviousView {
    [self hide];
}

#pragma mark - Lazy Load

- (UIView *)backView {
    if (!_backView) {
        CGFloat rate = 430.0 / 812.0;
        CGFloat height = rate * kScreenHeight();
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight(), kScreenWidth(), height)];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

- (RinoPanelManager *)panelManager {
    _panelManager = [RinoPanelManager sharedInstance];
    return _panelManager;
}

@end
