#import "SmartechPushPlugin.h"
#import <CoreLocation/CoreLocation.h>
#import <SmartPush/SmartPush.h>

@implementation SmartechPushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"smartech_push"
            binaryMessenger:[registrar messenger]];
  SmartechPushPlugin *instance = [[SmartechPushPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    @try {
      if ([@"optPushNotification" isEqualToString:call.method]) {
          [[SmartPush sharedInstance] optPushNotification:[call.arguments boolValue]];
          result(NULL);
      } else if ([@"hasOptedPushNotification" isEqualToString:call.method]) {
          result(@([[SmartPush sharedInstance] hasOptedPushNotification]));
      } else {
        result(FlutterMethodNotImplemented);
      }
    }
    @catch (NSException *exception) {
        NSLog(@"SMT : error setting Smartech base method %@", exception.reason);
    }
}

@end
