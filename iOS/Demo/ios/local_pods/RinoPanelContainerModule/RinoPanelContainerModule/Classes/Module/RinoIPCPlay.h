//
//  RinoIPCPlay.h
//  Rino
//
//  Created by zhangstar on 2023/4/4.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface RinoIPCPlay : UIView

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSDictionary *style1;
@property (nonatomic, strong) NSString *solution;

@property (nonatomic, copy) RCTBubblingEventBlock onStatusChange;
@property (nonatomic, copy) RCTBubblingEventBlock onOtherBusiness;

@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END

