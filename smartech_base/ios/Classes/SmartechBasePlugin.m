#import "SmartechBasePlugin.h"
#import <Smartech/Smartech.h>

static FlutterMethodChannel *channel;

@implementation SmartechBasePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    channel = [FlutterMethodChannel
                                     methodChannelWithName:@"smartech_base"
                                     binaryMessenger:[registrar messenger]];
    SmartechBasePlugin *instance = [[SmartechBasePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}


+ (void)handleDeeplinkAction:(NSString *)urlString andCustomPayload:(NSDictionary *)customPayload {
    NSMutableDictionary *notificationPayload = [[NSMutableDictionary alloc] init];
    
    [notificationPayload setObject:urlString ? urlString : @"" forKey:@"deeplinkURL"];
    [notificationPayload setObject:customPayload ? customPayload : @{} forKey:@"customPayload"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationState"] != nil){
        BOOL isTerminated = [[NSUserDefaults standardUserDefaults] boolForKey:@"ApplicationState"];
        if (isTerminated){
            [[NSUserDefaults standardUserDefaults] setObject:notificationPayload forKey:@"DeeplinkActionData"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ApplicationState"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    [channel invokeMethod:@"onhandleDeeplinkAction" arguments:notificationPayload];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    @try {
        if ([@"getDeviceGuid" isEqualToString:call.method]) {
            result([[Smartech sharedInstance] getDeviceGuid]);
        } else if ([@"clearUserIdentity" isEqualToString:call.method]) {
            [[Smartech sharedInstance] clearUserIdentity];
            result(NULL);
        } else if ([@"trackAppInstall" isEqualToString:call.method]) {
            [[Smartech sharedInstance] trackAppInstall];
            result(NULL);
        } else if ([@"trackAppUpdate" isEqualToString:call.method]) {
            [[Smartech sharedInstance] trackAppUpdate];
            result(NULL);
        } else if ([@"trackAppInstallUpdateBySmartech" isEqualToString:call.method]) {
            [[Smartech sharedInstance] trackAppInstallUpdateBySmartech];
            result(NULL);
        } else if ([@"updateUserProfile" isEqualToString:call.method]) {
            [[Smartech sharedInstance] updateUserProfile:call.arguments];
            result(NULL);
        } else if ([@"setUserIdentity" isEqualToString:call.method]) {
            [[Smartech sharedInstance] setUserIdentity:call.arguments];
            result(NULL);
        } else if ([@"getUserIdentity" isEqualToString:call.method]) {
            result([[Smartech sharedInstance] getUserIdentity]);
        } else if ([@"login" isEqualToString:call.method]) {
            [[Smartech sharedInstance] login:call.arguments];
            result(NULL);
        } else if ([@"logoutAndClearUserIdentity" isEqualToString:call.method]) {
            [[Smartech sharedInstance] logoutAndClearUserIdentity:[call.arguments boolValue]];
            result(NULL);
        } else if ([@"trackEvent" isEqualToString:call.method]) {
            [self trackEvent:call];
            result(NULL);
        } else if ([@"getDeviceUniqueId" isEqualToString:call.method]) {
            result([[Smartech sharedInstance] getDeviceGuid]);
        } else if ([@"setUserLocation" isEqualToString:call.method]) {
            [self setUserLocation:call];
            result(NULL);
        } else if ([@"optTracking" isEqualToString:call.method]) {
            [[Smartech sharedInstance] optTracking:[call.arguments boolValue]];
            result(NULL);
        } else if ([@"optInAppMessage" isEqualToString:call.method]) {
            [[Smartech sharedInstance] optInAppMessage:[call.arguments boolValue]];
            result(NULL);
        } else if ([@"hasOptedTracking" isEqualToString:call.method]) {
            result(@([[Smartech sharedInstance] hasOptedTracking]));
        } else if ([@"hasOptedInAppMessage" isEqualToString:call.method]) {
            result(@([[Smartech sharedInstance] hasOptedInAppMessage]));
        } else if ([@"getAppID" isEqualToString:call.method]) {
            result([[Smartech sharedInstance] getAppId]);
        } else if ([@"getDevicePushToken" isEqualToString:call.method]) {
            result([[Smartech sharedInstance] getDevicePushToken]);
        } else if ([@"getSDKVersion" isEqualToString:call.method]) {
            result([[Smartech sharedInstance] getSDKVersion]);
        } else if ([@"onHandleDeeplinkAction" isEqualToString:call.method]) {
            result(NULL);
        } else if ([@"onHandleDeeplinkActionBackground" isEqualToString:call.method]) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DeeplinkActionData"] != nil){
                NSDictionary *notificationPayload = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"DeeplinkActionData"];
                [channel invokeMethod:@"onhandleDeeplinkAction" arguments:notificationPayload];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DeeplinkActionData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            result(NULL);
        } else {
            result(FlutterMethodNotImplemented);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SMT : error setting Smartech base method %@", exception.reason);
    }
}

- (void)trackEvent:(FlutterMethodCall *)call {
    @try {
        NSDictionary *eventPayload = [NSDictionary dictionaryWithDictionary:call.arguments];
        [[Smartech sharedInstance] trackEvent:[eventPayload objectForKey:@"event_name"] andPayload:[eventPayload objectForKey:@"event_data"]];
    }
    @catch (NSException *exception) {
        NSLog(@"SMT : error setting trackEvent %@", exception.reason);
    }
}

- (void)setUserLocation:(FlutterMethodCall *)call {
    @try {
        NSDictionary *userLocation = [NSDictionary dictionaryWithDictionary:call.arguments];
        CLLocationCoordinate2D userLocationCordinate = CLLocationCoordinate2DMake([[userLocation objectForKey:@"latitude"] doubleValue], [[userLocation objectForKey:@"longitude"] doubleValue]);
        [[Smartech sharedInstance] setUserLocation:userLocationCordinate];
    }
    @catch (NSException *exception) {
        NSLog(@"SMT : error setting location %@", exception.reason);
    }
}


@end

