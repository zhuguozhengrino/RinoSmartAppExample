//
//  RinoAMRPlayer.h
//  Rino
//
//  Created by 2bit on 2025/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoAMRPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString *tempWavPath;

- (void)playAMRFromURL:(NSURL *)url;
- (void)stopPlayback;

@end

NS_ASSUME_NONNULL_END
