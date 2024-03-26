//
//  RinoIPCPlay.m
//  Rino
//
//  Created by zhangstar on 2023/4/4.
//

#import "RinoIPCPlay.h"
@implementation RinoIPCPlay

//- (instancetype)initWithView:(UIView *)view {
//    self = [super init];
//    self.backgroundColor = [UIColor redColor];
//    if (self) {
//        NSArray *layers = view.layer.sublayers;
//        for (id layer in layers) {
//            [self.layer addSublayer:laye ];
//        }
//    }
//    return self;
//}





- (NSString *)status {
    if (!_status) {
        _status = @"";
    }
    return _status;
}

@end
