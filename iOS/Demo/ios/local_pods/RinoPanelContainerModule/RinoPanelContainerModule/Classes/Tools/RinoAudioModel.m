//
//  RinoAudioModel.m
//  Rino
//
//  Created by zhangstar on 2025/3/10.
//

#import "RinoAudioModel.h"

@implementation RinoAudioModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRecorder];
    }
    return self;
}

- (void)setupRecorder {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"record.pcm"];
    self.recordFileURL = [NSURL fileURLWithPath:path];

    NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
        AVSampleRateKey: @8000,
        AVNumberOfChannelsKey: @1,
        AVLinearPCMBitDepthKey: @16,
        AVLinearPCMIsBigEndianKey: @NO,
        AVLinearPCMIsFloatKey: @NO};

    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileURL settings:settings error:&error];

    if (error) {
        NSLog(@"Recorder setup error: %@", error.localizedDescription);
    }
}

- (void)startRecording {
    [self.recorder record];
}

- (void)stopRecording {
    [self.recorder stop];
}

@end
