//
//  RinoRCTVideo.m
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/12/4.
//

#import "RinoRCTVideo.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <MJExtension/MJExtension.h>
#import <RinoIPCKit/RinoIpcCloudStorgeRecordingManager.h>
#import "RinoRCTVideoManager.h"
@interface RinoRCTVideo ()<IJKFFMoviePlayerControllerDelegate>


@property (nonatomic , strong) IJKFFMoviePlayerController *player;


@property (nonatomic , copy)NSString *vlcUrl;

@property (nonatomic , assign) NSInteger totalTime;

@property (nonatomic , assign)float currentTime;


@property (nonatomic , strong) NSTimer *playerTimer;


@end

@implementation RinoRCTVideo


-(void)dealloc{
    NSLog(@"--RCTVideo-------dealloc------销毁 view:%@",_playerID);
    [self removePlayer];
    
}

-(void)setPlayerID:(NSString *)playerID{
    _playerID = playerID;
    NSLog(@"--RCTVideo--设置playerID:%@",_playerID);
    NSArray *releaseIdArr = [RinoRCTVideoManager sharedInstance].releaseIdArr;
    for (NSString *releaseId in releaseIdArr) {
        if ([_playerID isEqualToString:releaseId]) {
            NSLog(@"--RCTVideo--这个view 已经被释放了:%@",_playerID);
            [self removePlayer];
        }
    }
}

-(void)setSource:(NSDictionary *)source{
    _source = source;
   
    NSString *uri = [source objectForKey:@"uri"];
    NSArray *releaseIdArr = [RinoRCTVideoManager sharedInstance].releaseIdArr;
    for (NSString *releaseId in releaseIdArr) {
        if ([_playerID isEqualToString:releaseId]) {
            NSLog(@"--RCTVideo--这个view 已经被释放了,不需要初始化播放器");
            return;
        }
    }
    if (uri.length > 0) {
        NSLog(@"--RCTVideo--设置source:%@",[_source mj_JSONString]);
        self.vlcUrl = uri;
        [self initiPlayer];
    }
}


-(void)setPaused:(BOOL)paused{
    _paused = paused;
    NSLog(@"--RCTVideo--设置paused:%@",_paused?@"yes":@"no");
    if(_player){
        if (_paused) {
            [self.player pause];
        }else{
            [self.player play];
        }
        
    }
}


-(void)setSeek:(float)seek{
    _seek = seek;
    NSLog(@"--RCTVideo--设置seek:%f",_seek);
    if(_player){
        self.currentTime = _seek;
//        if(self.totalTime > 0 && self.currentTime >= 1){
//            self.player.currentPlaybackTime = self.currentTime;
//            [self.player play];
//            [self playStartTimer];
//        }
//        if (self.currentTime < 1) {
//            [self initiPlayer];
//            
//        }
        self.player.currentPlaybackTime = self.currentTime;
        [self.player play];
        [self playStartTimer];
        
    }
}
-(void)setProgressUpdateInterval:(float)progressUpdateInterval{
    _progressUpdateInterval = progressUpdateInterval;
    
    NSLog(@"--RCTVideo--设置progressUpdateInterval:%f",_progressUpdateInterval);
}

-(void)setSpeed:(float)speed{
    if (speed <= 1) {
        speed = 1;
    }
    _speed = speed;
    NSLog(@"--RCTVideo--设置speed:%f",_speed);
    if (_player) {
        _player.playbackRate = _speed;
    }
    
}

-(void)setVolume:(float)volume{
    _volume = volume;
    NSLog(@"--RCTVideo--设置volume:%f",_volume);
    if (_player) {
        _player.playbackVolume = _volume;
    }
    
}

-(void)initiPlayer{
    NSString *tempUrl = self.vlcUrl;
    [self removePlayer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.vlcUrl = tempUrl;
//        NSLog(@"--RCTVideo-rn--设置资源---延时处理：%@",self.vlcUrl);
        self.totalTime = 0;
        self.currentTime = 0;
        [self.playerTimer invalidate];
        self.playerTimer = nil;
        [self.player pause];
        self.player.playbackVolume = self.volume;
        [self.player prepareToPlay];
        if (self.onVideoLoadStart) {
            self.onVideoLoadStart(@{});
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerPlaybackStateDidChange:)
                                                     name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:self.player];
        // 添加播放完成通知的观察者
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlayerPlaybackDidFinish:)
                                                         name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.player];
        
        // 注册跳转完成的通知
           [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(seekComplete:)
                                                        name:IJKMPMoviePlayerDidSeekCompleteNotification
                                                      object:self.player];
        [self setSpeed:self.speed];
    });
}
- (void)seekComplete:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval targetTime = [userInfo[IJKMPMoviePlayerDidSeekCompleteTargetKey] doubleValue];
//    NSTimeInterval actualTime = [userInfo[IJKMPMoviePlayerDidSeekCompleteActualKey] doubleValue];
        
        NSLog(@"--RCTVideo--跳转完成，目标时间: %f", targetTime);
}

- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    IJKMPMovieFinishReason reason = [[userInfo valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    if (reason == IJKMPMovieFinishReasonPlaybackEnded) {
        // 正常播放结束
        NSLog(@"--RCTVideo--正常播放结束");
        self.currentTime = 0;
        [_playerTimer invalidate];
        _playerTimer = nil;
        if (self.onVideoEnd) {
            NSLog(@"--RCTVideo--正常播放结束---回调");
            self.onVideoEnd(@{});
        }
        
    } else if (reason == IJKMPMovieFinishReasonUserExited) {
        // 用户退出
        NSLog(@"--RCTVideo--用户退出");
        self.onVideoEnd(@{});
        self.currentTime = 0;
        [_playerTimer invalidate];
        _playerTimer = nil;
    } else if (reason == IJKMPMovieFinishReasonPlaybackError) {
        // 播放错误
        NSLog(@"--RCTVideo--播放错误");
    }
}



- (void)playerPlaybackStateDidChange:(NSNotification *)notification {
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            // 播放停止
            NSLog(@"--RCTVideo--播放停止");
            self.onVideoEnd(@{});
            self.currentTime = 0;
            [_playerTimer invalidate];
            _playerTimer = nil;
            break;
        case IJKMPMoviePlaybackStatePlaying:
            // 播放中
            NSLog(@"--RCTVideo--播放中");
            
            self.totalTime = self.player.duration;
            self.currentTime = (NSInteger)self.player.currentPlaybackTime;
           
            if (self.onVideoLoad) {
                NSLog(@"--RCTVideo--通知面板，正在播放中");
                NSDictionary *dict = @{@"duration":@(self.totalTime)};
                self.onVideoLoad(dict);
            }
            
            
            [self playStartTimer];
            break;
        case IJKMPMoviePlaybackStatePaused:
            // 暂停
            NSLog(@"--RCTVideo--暂停");
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            // 播放被中断
            NSLog(@"--RCTVideo---播放被中断");
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            //正在快进
            NSLog(@"--RCTVideo--正在快进");
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            // 正在快退
            NSLog(@"--RCTVideo--正在快退");
            break;
        default:
            break;
    }
}


-(IJKFFMoviePlayerController *)player{
    if(_player == nil && self.vlcUrl.length > 0){
        NSLog(@"--RCTVideo--创建新的player");
        NSURL *url = [NSURL URLWithString:self.vlcUrl];
        [IJKFFMoviePlayerController setLogReport:YES];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];

        _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
        [_player setScalingMode:IJKMPMovieScalingModeAspectFit];
        _player.view.frame = self.frame;
        _player.rinoDelegate = self;
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.player.view];
    }
    return _player;
}

-(void)removePlayer{
    if(self.vlcUrl.length > 0 && _player){
        NSLog(@"--RCTVideo--removePlayer");
        _player.rinoDelegate = nil;
        [_player pause];
        _player.playbackVolume = 0;
        [_player stop];
        [_player shutdown];
        // 移除观察者
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        // 移除播放器视图
        [_player.view removeFromSuperview];
        _player = nil;
        self.vlcUrl = @"";
        self.currentTime = 0;
        [_playerTimer invalidate];
        _playerTimer = nil;
        
    }
    
}

-(void)playStartTimer{
    if(!_playerTimer){
        self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playTimeChange) userInfo:nil repeats:YES];
    }
    
}


-(void)playTimeChange{
    if(_player.playbackState == IJKMPMoviePlaybackStatePlaying){
        self.currentTime = self.player.currentPlaybackTime;
        if(self.player.currentPlaybackTime >= 0 ) {
            NSDictionary *progressDict = @{
                @"currentTime": @(self.currentTime),
                @"playableDuration": @(self.totalTime)
            };
            
            if (self.onVideoProgress) {
                NSLog(@"--RCTVideo--progress--currentTime:%f--totalTime:%zd",self.currentTime,self.totalTime);
                self.onVideoProgress(progressDict);
            }
            
        }
    }
    
}

-(void)rinoHandleAudioFrameWithFormat:(int)format sample_rate:(int)sample_rate chanel_count:(int)chanel_count nb_samples:(int)nb_samples pcm_len:(int)pcm_len pcm:(uint8_t *)pcm{
    if (_playerID.length > 0 && _player) {
        [[RinoIpcCloudStorgeRecordingManager sharedInstance] rinoIpcHandleAudioFrameWithFormat:format sample_rate:sample_rate chanel_count:chanel_count nb_samples:nb_samples pcm_len:pcm_len pcm:pcm playerID:self.playerID];
    }
    
}

-(void)rinoHandleVideoFrameWithFormat:(uint32_t)format width:(int)width height:(int)height data_y:(uint8_t *)data_y data_u:(uint8_t *)data_u data_v:(uint8_t *)data_v strideY:(int)strideY strideU:(int)strideU strideV:(int)strideV{
    if (_playerID.length > 0 && _player) {
        [[RinoIpcCloudStorgeRecordingManager sharedInstance] rinoIpcHandleVideoFrameWithFormat:format width:width height:height data_y:data_y data_u:data_u data_v:data_v strideY:strideY strideU:strideU strideV:strideV playerID:self.playerID];
    }
    
}


@end
