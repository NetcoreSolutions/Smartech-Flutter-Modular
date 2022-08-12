//
//  NotificationViewController.m
//  SmartechNCE
//
//  Created by Shubham on 25/07/22.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <SmartPush/SmartPush.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    [[SmartPush sharedInstance] loadCustomNotificationContentView:self.customView];
}

- (void)didReceiveNotification:(UNNotification *)notification {
    [[SmartPush sharedInstance] didReceiveCustomNotification:notification];
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption option))completion {
    [[SmartPush sharedInstance] didReceiveCustomNotificationResponse:response completionHandler:^(UNNotificationContentExtensionResponseOption option) {
        completion(option);
    }];
}

@end
