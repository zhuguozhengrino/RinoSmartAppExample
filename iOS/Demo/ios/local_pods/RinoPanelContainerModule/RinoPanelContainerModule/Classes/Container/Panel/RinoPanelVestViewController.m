//
//  RinoPanelVestViewController.m
//  Rino
//
//  Created by zhangstar on 2024/1/29.
//

#import "RinoPanelVestViewController.h"

@interface RinoPanelVestViewController ()

@property (nonatomic, assign) BOOL needReloadJS;

@end

@implementation RinoPanelVestViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.needReloadJS) {
        self.needReloadJS = NO;
        
        if (![self.bridge isBatchActive]) {
            [self.bridge onFastRefresh];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSInteger count = 0;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[RinoBasicPanelViewController class]]) {
            count++;
        }
    }
    if (count == 2) {
        self.needReloadJS = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showPanelView];
}

- (void)showPanelView {
    [self initPanelWithModuleName:RinoPanelModuleNameVestPanel properties:@{}];
    [self hideLoadingView];
}

@end
