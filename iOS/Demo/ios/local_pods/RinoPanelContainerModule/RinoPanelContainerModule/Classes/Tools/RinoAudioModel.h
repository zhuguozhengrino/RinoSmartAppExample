//
//  RinoAudioModel.h
//  Rino
//
//  Created by zhangstar on 2025/3/10.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoAudioModel : NSObject

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSURL *recordFileURL;

- (void)startRecording;

- (void)stopRecording;

@end

NS_ASSUME_NONNULL_END
