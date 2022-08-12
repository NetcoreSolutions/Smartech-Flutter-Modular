#import <Flutter/Flutter.h>

@interface SmartechBasePlugin : NSObject<FlutterPlugin>

+ (void)handleDeeplinkAction:(NSString *)urlString andCustomPayload:(NSDictionary *)customPayload;


@end
