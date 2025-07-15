//
//  RinoAMRPlayer.m
//  Rino
//
//  Created by 2bit on 2025/5/26.
//

#import "RinoAMRPlayer.h"
#import <FFmpegKit/FFmpegKit.h>

@interface RinoAMRPlayer ()<AVAudioPlayerDelegate>

@end

@implementation RinoAMRPlayer

- (void)playAMRFromURL:(NSURL *)url {
    // 1. 创建临时文件路径
    _tempWavPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp_amr.wav"];
    
    // 2. 删除可能存在的旧文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:_tempWavPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempWavPath error:nil];
    }
    
    // 3. 使用FFmpeg将网络AMR转换为本地WAV
    NSString *command = [NSString stringWithFormat:@"-i \"%@\" -ar 44100 -ac 2 -y \"%@\"", url.absoluteString, _tempWavPath];
    
    [FFmpegKit executeAsync:command withCompleteCallback:^(FFmpegSession* session) {
        ReturnCode *returnCode = [session getReturnCode];
        
        if ([ReturnCode isSuccess:returnCode]) {
            NSLog(@"转换成功，准备播放");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 4. 使用AVAudioPlayer播放转换后的WAV文件
                NSError *error;
                self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.tempWavPath] error:&error];
                
                if (error) {
                    NSLog(@"播放器初始化失败: %@", error.localizedDescription);
                } else {
                    self.audioPlayer.delegate = self;
                    [self.audioPlayer prepareToPlay];
                    [self.audioPlayer play];
                    NSLog(@"开始播放AMR音频");
                }
            });
        } else {
            NSLog(@"转换失败: %@", [session getFailStackTrace]);
        }
    } withLogCallback:^(Log *log) {
        NSLog(@"FFmpeg log: %@", [log getMessage]);
    } withStatisticsCallback:nil];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        NSLog(@"音频播放完成");
    } else {
        NSLog(@"音频播放中断");
    }
}

- (void)stopPlayback {
    
//    [self.audioPlayer pause];
//    [self.audioPlayer play];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    
    // 清理临时文件
    if (_tempWavPath && [[NSFileManager defaultManager] fileExistsAtPath:_tempWavPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:_tempWavPath error:nil];
    }
}
@end
