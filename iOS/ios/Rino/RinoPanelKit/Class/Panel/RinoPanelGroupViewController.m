//
//  RinoPanelGroupViewController.m
//  Rino
//
//  Created by zhangstar on 2022/11/15.
//

#import "RinoPanelGroupViewController.h"

@interface RinoPanelGroupViewController ()

@end

@implementation RinoPanelGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *properties = [[RinoPanelViewModel sharedInstance] getGroupInitialProperties];
    [self initUIWithProperties:properties];
}

@end
