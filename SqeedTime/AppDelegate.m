//
//  AppDelegate.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "AppDelegate.h"
#import "CacheHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString* token = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[CacheHandler instance] setPn_token:token];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get push notifications token, error: %@", error);
    [[CacheHandler instance] setPn_token:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"NOTIFICATION: %@", userInfo);
    
    if (application.applicationState == UIApplicationStateActive) { // APP IS OPEN
        
        if ([userInfo[@"aps"][@"alert"][@"kind"] isEqualToString:@"invitation"]) {
            NSLog(@"NOTIFICATION: Invitation");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InvitationReveived"
                                                                object:nil
                                                              userInfo:userInfo];
        } else if ([userInfo[@"aps"][@"alert"][@"kind"] isEqualToString:@"message"]) {
            NSLog(@"NOTIFICATION: Message");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageReveived"
                                                                object:nil
                                                              userInfo:userInfo];
        } else if ([userInfo[@"aps"][@"alert"][@"kind"] isEqualToString:@"request"]) {
            NSLog(@"NOTIFICATION: Request");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestReveived"
                                                                object:nil
                                                              userInfo:userInfo];
        } else {
            NSLog(@"NOTIFICATION: Other");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveRemoteNotification"
                                                                object:nil
                                                              userInfo:userInfo];
        }
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
    } else {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
