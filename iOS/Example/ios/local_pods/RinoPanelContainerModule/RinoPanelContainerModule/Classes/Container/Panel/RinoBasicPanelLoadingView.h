//
//  RinoBasicPanelLoadingView.h
//  Rino
//
//  Created by zhangstar on 2024/1/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoBasicPanelLoadingView : UIView

@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) NSInteger progress;

@end

NS_ASSUME_NONNULL_END
