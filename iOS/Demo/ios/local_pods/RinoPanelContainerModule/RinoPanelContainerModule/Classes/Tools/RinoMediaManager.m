//
//  RinoMediaManager.m
//  Rino
//
//  Created by zhangstar on 2025/3/10.
//

#import "RinoMediaManager.h"

@implementation RinoMediaManager

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
