//
//  RinoCustomDrawView.h
//  RinoPanelContainerModule
//
//  Created by jeff on 2024/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoCustomDrawView : UIView
- (void)drawWithJSONString:(NSString *)jsonString;
- (UIImage *)captureImage;
- (void)saveImageToSandbox:(UIImage *)image withFileName:(NSString *)fileName finish:(void(^)(NSString *path, NSError *error))finish;
@end

NS_ASSUME_NONNULL_END
