//
//  RinoIPCAgoraPlay.h
//  Rino
//
//  Created by super on 2023/12/29.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoAgoraPlayView : UIView

@property (nonatomic, strong) NSString *playViewId;

@property (nonatomic, copy) RCTBubblingEventBlock onReady;

@end

NS_ASSUME_NONNULL_END
