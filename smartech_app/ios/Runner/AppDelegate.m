#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "SmartechBasePlugin.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, SmartechDelegate> {
  NSMutableDictionary *smtDeeplinkData;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // [FIRApp configure];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    [[Smartech sharedInstance] initSDKWithDelegate:self withLaunchOptions:launchOptions];
    [[Smartech sharedInstance] setDebugLevel:SMTLogLevelVerbose];
    [[SmartPush sharedInstance] registerForPushNotificationWithDefaultAuthorizationOptions];
    [[Smartech sharedInstance] trackAppInstallUpdateBySmartech];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"[SMT-APP] didRegisterForRemoteNotificationsWithDeviceToken");
  [[SmartPush sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"[SMT-APP] didFailToRegisterForRemoteNotificationsWithError = %@", [error localizedFailureReason]);
  [[SmartPush sharedInstance] didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"[SMT-APP] didReceiveRemoteNotification Silent Notification");
  if ([[SmartPush sharedInstance] isNotificationFromSmartech:userInfo]) {
    [[SmartPush sharedInstance] didReceiveRemoteNotification:userInfo withCompletionHandler:^(UIBackgroundFetchResult bgFetchResult) {
      completionHandler(bgFetchResult);
    }];
  }
  else {
    completionHandler(UIBackgroundFetchResultNewData);
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"[SMT-APP] application Active");
}

- (void)applicationWillTerminate:(UIApplication *)application{
    NSLog(@"[SMT-APP] application terminate");
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"ApplicationState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UNUserNotificationCenterDelegate Methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  NSLog(@"[SMT-APP] willPresentNotification");
  [[SmartPush sharedInstance] willPresentForegroundNotification:notification];
  completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
  NSLog(@"[SMT-APP] didReceiveNotificationResponse %@",response.notification.request.content);
  [[SmartPush sharedInstance] didReceiveNotificationResponse:response];
  completionHandler();
}

- (void)handleDeeplinkActionWithURLString:(NSString *)deeplinkURLString andCustomPayload:(NSDictionary *)customPayload{
   [SmartechBasePlugin handleDeeplinkAction:deeplinkURLString andCustomPayload:customPayload];
}

- (void)handleDeeplinkActionWithURLString:(NSString *)deeplinkURLString andNotificationPayload:(NSDictionary *)notificationPayload{
    [SmartechBasePlugin handleDeeplinkAction:deeplinkURLString andCustomPayload:notificationPayload];
}

@end
