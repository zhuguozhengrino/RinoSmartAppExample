//
//  RinoRNP2PBridgingModule.h
//  Rino
//
//  Created by super on 2023/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoRNP2PBridgingModule : NSObject

///视频或者语音中
@property (nonatomic , assign)BOOL inVideoVoice;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
