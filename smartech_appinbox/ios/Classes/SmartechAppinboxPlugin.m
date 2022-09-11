#import "SmartechAppinboxPlugin.h"
#import <SmartechAppInbox/SmartechAppInbox.h>
#import <Smartech/Smartech.h>

NSString *const kNotificationCategoryCarouselPortrait = @"SmartechCarouselPortraitNotification";
NSString *const kNotificationCategoryCarouselLandscape = @"SmartechCarouselLandscapeNotification";
NSString *const kNotificationCategoryCarouselFallback = @"SmartechCarouselFallbackNotification";

@implementation SmartechAppinboxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"smartech_appinbox"
                                     binaryMessenger:[registrar messenger]];
    SmartechAppinboxPlugin* instance = [[SmartechAppinboxPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    @try {
        if ([@"getAppInboxCategoryList" isEqualToString:call.method]) {
            NSArray *appInboxCategoryArray  = [[NSArray alloc] initWithArray:[[SmartechAppInbox sharedInstance] getAppInboxCategoryList]];
            NSMutableArray *categoryData = [[NSMutableArray alloc] init];
            for (SMTAppInboxCategoryModel *catObj in appInboxCategoryArray) {
                NSMutableDictionary *categoryDict = [[NSMutableDictionary alloc] initWithDictionary:@{ @"name": [catObj categoryName],
                                                                                                       @"state":  @([catObj isSelected]),
                                                                                                       @"position" : @(0)
                                                                                                    }];
                [categoryData addObject:categoryDict];
            }
            NSString *categoryString = [self jsonStringFromObject:categoryData];
            result(categoryString);
        } else if ([@"getAppInboxCategoryWiseMessageList" isEqualToString:call.method]) {
            [self getAppInboxMessagesWithCategory:call withResult:(FlutterResult)result];
        } else if ([@"getAppInboxMessages" isEqualToString:call.method]) {
            NSArray *appInboxMessagesArray  = [[NSArray alloc] initWithArray:[[SmartechAppInbox sharedInstance] getAppInboxMessages:[call.arguments intValue]]];
            [self getAppInboxMessages:appInboxMessagesArray withCallback:result];
        } else if ([@"getAppInboxMessageCount" isEqualToString:call.method]) {
            NSString *messageType = [call.arguments objectForKey:@"smtAppInboxMessageType"];
            NSNumber *messageCount = 0;
            if (messageType){
                if ([messageType isEqualToString:@"read"]){
                    messageCount = @([[SmartechAppInbox sharedInstance] getAppInboxMessageCount:READ_MESSAGE]);//3
                } else if ([messageType isEqualToString:@"unread"]){
                    messageCount = @([[SmartechAppInbox sharedInstance] getAppInboxMessageCount:UNREAD_MESSAGE]);//3
                } else {
                    messageCount = @([[SmartechAppInbox sharedInstance] getAppInboxMessageCount:ALL_MESSAGE]);//3
                }
            }
            result(messageCount);
        } else if ([@"markMessageAsViewed" isEqualToString:call.method]) {
            NSDictionary *inboxPayload = [NSDictionary dictionaryWithDictionary:call.arguments];
            NSString *trid = [inboxPayload objectForKey:@"trid"];
            SMTAppInboxMessage *appInboxMessage = [[SmartechAppInbox sharedInstance] getInboxMessageById:trid];
            [[SmartechAppInbox sharedInstance] markMessageAsViewed:appInboxMessage];
            result(NULL);
        } else if ([@"markMessageAsClicked" isEqualToString:call.method]) {
            NSDictionary *inboxPayload = [NSDictionary dictionaryWithDictionary:call.arguments];
            NSString *trid = [inboxPayload objectForKey:@"trid"];
            SMTAppInboxMessage *appInboxMessage = [[SmartechAppInbox sharedInstance] getInboxMessageById:trid];
            [[SmartechAppInbox sharedInstance] markMessageAsClicked:appInboxMessage withDeeplink:[inboxPayload objectForKey:@"deeplink"]];
            result(NULL);
        } else if ([@"markMessageAsDismissed" isEqualToString:call.method]) {
            NSDictionary *inboxMessage = [NSDictionary dictionaryWithDictionary:call.arguments];
            if (inboxMessage) {
                SMTAppInboxMessage *appInboxMessage = [[SmartechAppInbox sharedInstance] getInboxMessageById:[inboxMessage objectForKey:@"trid"]];
                [[SmartechAppInbox sharedInstance] markMessageAsDismissed:appInboxMessage withCompletionHandler:^(NSError *error, BOOL status) {
                    if (status) {
                        //Remove data from array and refresh the table view
                        result(NULL);
                    }
                }];
            }
        } else if([@"getAppInboxMessagesByApiCall" isEqualToString:call.method]){
            [self getAppInboxMessagesByApiCall:call withResult:result];
        } else {
            result(FlutterMethodNotImplemented);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SMT : error setting Smartech Appinbox method %@", exception.reason);
    }
}

-(void)getAppInboxMessagesWithCategory:(FlutterMethodCall *)call withResult:(FlutterResult)result{
    @try {
        NSMutableArray *inboxCAtegory = [call.arguments objectForKey:@"group_id"];
        if (inboxCAtegory.count == 0){
            NSArray <SMTAppInboxMessage *> *appInboxMessagesArray = [[SmartechAppInbox sharedInstance] getAppInboxMessageWithCategory:[[[SmartechAppInbox sharedInstance] getAppInboxCategoryList] mutableCopy]];
            [self getAppInboxMessages:appInboxMessagesArray withCallback:result];
        }else{
            NSMutableArray <SMTAppInboxCategoryModel *> *appInboxArray  =  [self getCategoryFilter:call];
            NSArray <SMTAppInboxMessage *> *appInboxMessagesArray = [[SmartechAppInbox sharedInstance] getAppInboxMessageWithCategory:appInboxArray];
            [self getAppInboxMessages:appInboxMessagesArray withCallback:result];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"SMT : error setting getAppInboxMessages %@", exception.reason);
    }
}

/**
 @brief This method is used to  get their respective count. This method accepts SMTAppInboxMessageType as a parameter  by Smartech APPInbox SDK.
 */
-(void)getAppInboxMessagesByApiCall:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    
    NSDictionary *inboxPayload = [NSDictionary dictionaryWithDictionary:call.arguments];
    NSMutableArray <SMTAppInboxCategoryModel *> *appInboxArray  = [self getCategoryFilter:call];
    
    SMTAppInboxFilter *inboxFilter = [[SmartechAppInbox sharedInstance] getPullToRefreshParameter];
    inboxFilter.limit = [[inboxPayload objectForKey:@"messageLimit"] intValue];
    inboxFilter.direction = [inboxPayload objectForKey:@"smtInboxDataType"];
    
    [[SmartechAppInbox sharedInstance] getAppInboxMessage:inboxFilter withCompletionHandler:^(NSError *error,BOOL status) {
        if (appInboxArray.count == 0){
            NSArray <SMTAppInboxMessage *> *appInboxMessagesArray = [[SmartechAppInbox sharedInstance] getAppInboxMessageWithCategory:[[[SmartechAppInbox sharedInstance] getAppInboxCategoryList] mutableCopy]];
            [self getAppInboxMessages:appInboxMessagesArray withCallback:result];
        }else{
            NSArray <SMTAppInboxMessage *> *appInboxMessagesArray = [[SmartechAppInbox sharedInstance] getAppInboxMessageWithCategory:appInboxArray];
            [self getAppInboxMessages:appInboxMessagesArray withCallback:result];
        }
    }];
}

- (NSMutableArray <SMTAppInboxCategoryModel *> *)getCategoryFilter:(FlutterMethodCall *)call {
    NSMutableArray <SMTAppInboxCategoryModel *> *appInboxArray  = [[NSMutableArray alloc] init];
    
    @try {
        NSDictionary *inboxPayload = [NSDictionary dictionaryWithDictionary:call.arguments];
        NSArray *appInboxCategoryArray = [inboxPayload objectForKey:@"group_id"];
        for (int i =0; i< appInboxCategoryArray.count; i++) {
            SMTAppInboxCategoryModel *notificationPayload = [[SMTAppInboxCategoryModel alloc] init];
            notificationPayload.categoryName = [appInboxCategoryArray objectAtIndex:i];
            [appInboxArray addObject:notificationPayload];
        }
    } @catch (NSException *exception) {
        NSLog(@"Smartech error: Exception caught in getting app inbox messages with category.");
    }
    
    return  appInboxArray;
}

-(void)getAppInboxMessages:(NSArray *)appInboxMessagesArray withCallback:(FlutterResult)result{
    NSMutableArray *appInboxArray = [[NSMutableArray alloc] init];
    @try {
        for (SMTAppInboxMessage *messageObj in appInboxMessagesArray) {
            NSMutableDictionary *appInboxObject = [[NSMutableDictionary alloc] init];
            SMTAppInboxMessageModel *notificationPayload = messageObj.payload;
            NSString *notificationCategory = notificationPayload.aps.category;

            NSMutableDictionary * smtCustomPayloadObj = [[NSMutableDictionary alloc] initWithDictionary:notificationPayload.smtCustomPayload];
            
            NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] initWithDictionary:@{ @"title": notificationPayload.aps.alert.title,
                                                                                                  @"subtitle":notificationPayload.aps.alert.subtitle,
                                                                                                  @"body": notificationPayload.aps.alert.body,
                                                                                                  @"type":notificationPayload.smtPayload.type.lowercaseString,
                                                                                                  @"notificationCategory":notificationCategory,
                                                                                                  @"trid": notificationPayload.smtPayload.trid,
                                                                                                  @"deeplink": notificationPayload.smtPayload.deeplink,
                                                                                                  @"mediaUrl": notificationPayload.smtPayload.mediaURL,
                                                                                                  @"publishedDate": notificationPayload.smtPayload.publishedDate,
                                                                                                  @"status": notificationPayload.smtPayload.status,
                                                                                               }];
            
            if ([notificationCategory isEqualToString:kNotificationCategoryCarouselPortrait] || [notificationCategory isEqualToString:kNotificationCategoryCarouselLandscape] || [notificationCategory isEqualToString:kNotificationCategoryCarouselFallback]) {
                
                NSArray <SMTCarousel *> *carouselAppInboxArray = notificationPayload.smtPayload.carousel;
                NSMutableArray *carouselArray = [[NSMutableArray alloc] init];
                for (SMTCarousel *carouselObj in carouselAppInboxArray) {
                    NSMutableDictionary *carouselDict = [[NSMutableDictionary alloc] initWithDictionary:@{ @"imgUrl": carouselObj.imgUrl,
                                                                                                           @"imgUrlPath": (carouselObj.imgUrlPath != nil) ? carouselObj.imgUrlPath : @"",
                                                                                                           @"imgTitle":carouselObj.imgTitle,
                                                                                                           @"imgMsg":carouselObj.imgMsg,
                                                                                                           @"imgDeeplink":carouselObj.imgDeeplink
                                                                                                        }];
                    [carouselArray addObject:carouselDict];
                }
                [messageDict setObject:carouselArray forKey:@"carousel"];
            }else{
                [messageDict setObject:@[] forKey:@"carousel"];
            }
            
            
            if (notificationPayload.smtPayload.actionButton.count > 0) {
                NSArray <SMTActionButton *> *actionButtonAppInboxArray = notificationPayload.smtPayload.actionButton;
                NSMutableArray *actionArray = [[NSMutableArray alloc] init];
                for (SMTActionButton *actionObj in actionButtonAppInboxArray) {
                    NSMutableDictionary *actionDict = [[NSMutableDictionary alloc] initWithDictionary:@{ @"actionDeeplink": actionObj.actionDeeplink,
                                                                                                         @"actionName": actionObj.actionName,
                                                                                                         @"aTyp":actionObj.actionType,
                                                                                                         @"callToAction":actionObj.actionName,
                                                                                                         @"config_ctxt":(actionObj.actionConfig.count >   0) ?      [actionObj.actionConfig objectForKey:@"ctxt"] :     @""
                                                                                                      }];
                    [actionArray addObject:actionDict];
                }
                [messageDict setObject:actionArray forKey:@"actionButton"];
            }else{
                [messageDict setObject:@[] forKey:@"actionButton"];
            }
            
            [appInboxObject setValue:messageDict forKey:@"smtPayload"];
            NSString *smtCustomPayload = [self jsonStringFromObject:smtCustomPayloadObj];
            [appInboxObject setValue:smtCustomPayload forKey:@"smtCustomPayload"];
            [appInboxArray addObject:appInboxObject];
        }
    } @catch (NSException *exception) {
        NSLog(@"Smartech error: Exception caught in getting app inbox messages.");
    }
    NSString *appInboxString = [self jsonStringFromObject:appInboxArray];
    result(appInboxString);
}
    -(NSString *)jsonStringFromObject:(id)obj {
        NSError *err;
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:obj options:0 error:&err];
        NSString *appInboxString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
        return appInboxString;
    }
@end


