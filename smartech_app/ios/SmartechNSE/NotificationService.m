//
//  NotificationService.m
//  SmartechNSE
//
//  Created by Shubham on 25/07/22.
//

#import "NotificationService.h"
#import <SmartPush/SmartPush.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

SMTNotificationServiceExtension *smartechServiceExtension;

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
//    self.bestAttemptContent = [request.content mutableCopy];
    
    if ([[SmartPush sharedInstance] isNotificationFromSmartech:request.content.userInfo]) {
       smartechServiceExtension = [[SMTNotificationServiceExtension alloc] init];
       [smartechServiceExtension didReceiveNotificationRequest:request withContentHandler:contentHandler];
   }
    
//    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//
//    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    [smartechServiceExtension serviceExtensionTimeWillExpire];
    self.contentHandler(self.bestAttemptContent);
}

@end

