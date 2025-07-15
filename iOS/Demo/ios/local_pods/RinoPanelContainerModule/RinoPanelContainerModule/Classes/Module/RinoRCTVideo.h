//
//  RinoRCTVideo.h
//  RinoPanelContainerModule
//
//  Created by 2bit on 2024/12/4.
//

#import <Foundation/Foundation.h>
#import <React/RCTComponent.h>
NS_ASSUME_NONNULL_BEGIN

@interface RinoRCTVideo : UIView
///播放器的唯一标识符
@property (nonatomic, strong) NSString *playerID;
///播放源
@property (nonatomic, strong) NSDictionary *source;
///播放与暂停
@property (nonatomic , assign) BOOL paused;
///进度值（单位：秒）
@property (nonatomic , assign) float seek;
///进度更新频率（默认为1秒）
@property (nonatomic , assign) float progressUpdateInterval;
///播放倍数
@property (nonatomic , assign) float speed;
///音量
@property (nonatomic , assign) float volume;
///视频播放完成
@property (nonatomic, copy) RCTDirectEventBlock onVideoEnd;
///视频播放出错
@property (nonatomic, copy) RCTDirectEventBlock onVideoError;
///视频开始加载
@property (nonatomic, copy) RCTDirectEventBlock onVideoLoadStart;
///视频加载完成即可以播放
@property (nonatomic, copy) RCTDirectEventBlock onVideoLoad;
///进度更新
@property (nonatomic, copy) RCTDirectEventBlock onVideoProgress;

-(void)removePlayer;
@end

NS_ASSUME_NONNULL_END
