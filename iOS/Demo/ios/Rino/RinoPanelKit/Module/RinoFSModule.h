#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTLog.h>

typedef void (^CompletionHandler)(void);

@interface RinoFSModule : RCTEventEmitter <RCTBridgeModule>

+ (void)setCompletionHandlerForIdentifier:(NSString *)identifier completionHandler:(CompletionHandler)completionHandler;

@end
