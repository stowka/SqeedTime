//
//  DatabaseManager.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 30/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "DatabaseManager.h"
#import "CacheHandler.h"
#import "AFNetworking.h"
#import "AlertHelper.h"
#import "ActivitiesViewController.h"
#import "RootViewController.h"
#import "AddFriendsViewController.h"

@implementation DatabaseManager

static NSString* serverURL = @"http://sqtdbws.net-production.ch/";

+ (void) loginRequest: (NSString*) username : (NSString*) password {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"loginRequestV1",
                             @"username": username
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSString* userId = [response valueForKey:@"id"];
        NSLog(@"Login request for user id: %@", userId);
        [[CacheHandler instance] setCurrentUserId:userId];
        [[CacheHandler instance] setCurrentUser:[[User alloc] init:userId]];
        [[CacheHandler instance] setTmpUser:[[User alloc] init:userId]];
        [DatabaseManager login:username :password];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to log in: username doesn't exist!"];
        NSLog(@"Error: %@", error);
    }];

}

+ (void) login :(NSString*) username :(NSString*) password {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"login",
                             @"username": username,
                             @"password": password
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Login user %@", username);
        if (200 == [[response valueForKey:@"code"] integerValue]) {
            [DatabaseManager fetchUser:[[CacheHandler instance] tmpUser]];
            
            // Performs segue to ActivitiesViewController
            [[UIApplication sharedApplication] delegate] ;
            UIViewController *vc = [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
            [vc performSegueWithIdentifier: @"segueActivities" sender:vc];
            
            [[CacheHandler instance] setToken:[response valueForKey:@"token"]];
        } else {
            [AlertHelper error:@"Failed to log in: wrong password!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to log in"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchUser: (User*) user {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"getUser",
                             @"id": [user userId]
                            };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSString* username = [response valueForKey:@"username"];
        NSLog(@"Fetching user: %@", username);
        NSString* name = [response valueForKey:@"name"];
        NSString* forname = [response valueForKey:@"forname"];
        NSString* email = [response valueForKey:@"email"];
        NSString* phoneExt = [response valueForKey:@"phoneExt"];
        NSString* phone = [response valueForKey:@"phone"];
        NSString* salt = [response valueForKey:@"salt"];
        NSString* facebookUrl = [response valueForKey:@"facebookUrl"];
        [user set :username :name :forname :email :phoneExt :phone :salt :facebookUrl];
        [[CacheHandler instance] setTmpUser:user];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch user!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchMySqeeds: (User*) user {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"eventsByUser",
                             @"id": [user userId]
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Fetching my sqeeds for user: %@", [user username]);
        NSArray* tmp_sqeeds = response[@"result"];
        NSMutableArray* sqeeds = [[NSMutableArray alloc] init];
        Sqeed* tmp_sqeed;
        NSString* sqeedId;
        NSString* title;
        NSString* place;
        SqeedCategory* category;
        NSString* creatorFirstName;
        NSString* creatorName;
        NSString* peopleMin;
        NSString* peopleMax;
        NSDate* dateStart;
        NSDate* dateEnd;
        
        for (NSDictionary* sqeed in tmp_sqeeds) {
            sqeedId = sqeed[@"id"];
            title = sqeed[@"title"];
            place = sqeed[@"place"];
            category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
            creatorFirstName = sqeed[@"creator_first_name"];
            creatorName = sqeed[@"creator_name"];
            peopleMin = sqeed[@"people_min"];
            peopleMax = sqeed[@"people_max"];
            
            if (![sqeed[@"datetime_start"] isKindOfClass:[NSNull class]])
                dateStart = [NSDate dateWithTimeIntervalSince1970:[sqeed[@"datetime_start"] doubleValue]];
            else
                dateStart = [NSDate dateWithTimeIntervalSince1970:0];
            if (![sqeed[@"datetime_end"] isKindOfClass:[NSNull class]])
                dateEnd = [NSDate dateWithTimeIntervalSince1970:[sqeed[@"datetime_end"] doubleValue]];
            else
                dateEnd = [NSDate dateWithTimeIntervalSince1970:0];
            
            tmp_sqeed = [[Sqeed alloc] init: sqeedId];
            [tmp_sqeed setHeaders:title :place :category :creatorFirstName :creatorName :peopleMin :peopleMax :dateStart :dateEnd];
            
            [sqeeds addObject:tmp_sqeed];
        }
        [user setMySqeeds:sqeeds];
        [[CacheHandler instance] setTmpUser:user];
        
        // Refreshes (loads) the activity table
        [[UIApplication sharedApplication] delegate] ;
        RootViewController *rvc = (RootViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        
        if ([[[[rvc swipeViewController] viewControllers] lastObject] class] == [ActivitiesViewController class]) {
            ActivitiesViewController *avc = [[[rvc swipeViewController] viewControllers] lastObject];
            [avc refresh];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch my sqeeds!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchDiscovered: (User*) user {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"discover",
                             @"userId": [user userId]
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Fetching discovered for user: %@", [user username]);
        NSArray* tmp_sqeeds = response[@"result"];
        NSMutableArray* sqeeds = [[NSMutableArray alloc] init];
        Sqeed* tmp_sqeed;
        NSString* sqeedId;
        NSString* title;
        NSString* place;
        SqeedCategory* category;
        NSString* creatorFirstName;
        NSString* creatorName;
        NSString* peopleMin;
        NSString* peopleMax;
        NSDate* dateStart;
        NSDate* dateEnd;
        
        for (NSDictionary* sqeed in tmp_sqeeds) {
            sqeedId = sqeed[@"id"];
            title = sqeed[@"title"];
            place = sqeed[@"place"];
            category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
            creatorFirstName = sqeed[@"creator_first_name"];
            creatorName = sqeed[@"creator_name"];
            peopleMin = sqeed[@"people_min"];
            peopleMax = sqeed[@"people_max"];
            
            if (![sqeed[@"datetime_start"] isKindOfClass:[NSNull class]])
                dateStart = [NSDate dateWithTimeIntervalSince1970:[sqeed[@"datetime_start"] doubleValue]];
            else
                dateStart = [NSDate dateWithTimeIntervalSince1970:0];
            if (![sqeed[@"datetime_end"] isKindOfClass:[NSNull class]])
                dateEnd = [NSDate dateWithTimeIntervalSince1970:[sqeed[@"datetime_end"] doubleValue]];
            else
                dateEnd = [NSDate dateWithTimeIntervalSince1970:0];
            
            tmp_sqeed = [[Sqeed alloc] init: sqeedId];
            [tmp_sqeed setHeaders:title :place :category :creatorFirstName :creatorName :peopleMin :peopleMax :dateStart :dateEnd];
            
            [sqeeds addObject:tmp_sqeed];
        }
        [user setDiscovered:sqeeds];
        [[CacheHandler instance] setTmpUser:user];
        
        // Refreshes (loads) the activity table
        [[UIApplication sharedApplication] delegate] ;
        RootViewController *rvc = (RootViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        
        ActivitiesViewController *avc = [[[rvc swipeViewController] viewControllers] lastObject];
        [avc refresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch discovered!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchDiscovered :(User *) user :(SqeedCategory *) category {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"discover",
                             @"userId": [user userId],
                             @"categoryId": [category categoryId]
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Fetching discovered for user: %@", [user username]);
        NSArray* tmp_sqeeds = response[@"result"];
        NSMutableArray* sqeeds = [[NSMutableArray alloc] init];
        Sqeed* tmp_sqeed;
        NSString* sqeedId;
        NSString* title;
        NSString* place;
        SqeedCategory* category;
        NSString* creatorFirstName;
        NSString* creatorName;
        NSString* peopleMin;
        NSString* peopleMax;
        NSDate* dateStart;
        NSDate* dateEnd;
        
        for (NSDictionary* sqeed in tmp_sqeeds) {
            sqeedId = sqeed[@"id"];
            title = sqeed[@"title"];
            place = sqeed[@"place"];
            category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
            creatorFirstName = sqeed[@"creator_first_name"];
            creatorName = sqeed[@"creator_name"];
            peopleMin = sqeed[@"people_min"];
            peopleMax = sqeed[@"people_max"];
            
            if (![sqeed[@"datetime_start"] isKindOfClass:[NSNull class]])
                dateStart = [NSDate dateWithTimeIntervalSince1970:[sqeed[@"datetime_start"] doubleValue]];
            else
                dateStart = [NSDate dateWithTimeIntervalSince1970:0];
            if (![sqeed[@"datetime_end"] isKindOfClass:[NSNull class]])
                dateEnd = [NSDate dateWithTimeIntervalSince1970:[sqeed[@"datetime_end"] doubleValue]];
            else
                dateEnd = [NSDate dateWithTimeIntervalSince1970:0];
            
            tmp_sqeed = [[Sqeed alloc] init: sqeedId];
            [tmp_sqeed setHeaders:title :place :category :creatorFirstName :creatorName :peopleMin :peopleMax :dateStart :dateEnd];
            
            [sqeeds addObject:tmp_sqeed];
        }
        [user setDiscovered:sqeeds];
        [[CacheHandler instance] setTmpUser:user];
        
        // Refreshes (loads) the activity table
        [[UIApplication sharedApplication] delegate] ;
        RootViewController *rvc = (RootViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        
        ActivitiesViewController *avc = [[[rvc swipeViewController] viewControllers] lastObject];
        [avc refresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch discovered!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchFriends: (User*) user {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"listFriends",
                             @"userId": [user userId]
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Fetching friend list for user: %@", [user username]);
        NSArray* tmp_friends = response[@"list"];
        NSMutableArray* friends = [[NSMutableArray alloc] init];
        User* tmp_friend;
        NSString* friendId;
        
        for (NSDictionary* friend in tmp_friends) {
            friendId = friend[@"id"];
            tmp_friend = [[User alloc] init: friendId];
            [self fetchUser:tmp_friend];
            [friends addObject:tmp_friend];
        }
        [user setFriends:friends];
        [[CacheHandler instance] setTmpUser:user];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch friends!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchFriendRequests: (User*) user {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"listFriendRequests",
                             @"userId": [user userId]
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Fetching friend requests for user: %@", [user username]);
        NSArray* tmp_friends = response[@"list"];
        NSMutableArray* friends = [[NSMutableArray alloc] init];
        User* tmp_friend;
        NSString* friendId;
        
        for (NSDictionary* friend in tmp_friends) {
            friendId = friend[@"id"];
            tmp_friend = [[User alloc] init: friendId];
            [self fetchUser:tmp_friend];
            [friends addObject:tmp_friend];
        }
        [user setFriendRequests:friends];
        [[CacheHandler instance] setTmpUser:user];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch friend requests!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchSqeed: (Sqeed*) sqeed :(NSIndexPath *)indexPath {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"getEvent",
                             @"id": [sqeed sqeedId]
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Fetching sqeed: %@", [sqeed title]);
        NSDictionary *result = [response valueForKey:@"result"];
        NSString *sqeedDescritpion = [result valueForKey:@"description"];
        
        NSArray *tmp_going = [NSArray arrayWithArray:[result objectForKey:@"going"]];
        NSArray *tmp_waiting = [NSArray arrayWithArray:[result objectForKey:@"waiting"]];
        
        NSMutableArray *going = [[NSMutableArray alloc] init];
        NSMutableArray *waiting = [[NSMutableArray alloc] init];
        User *tmp_user;
        
        for (NSDictionary* g in tmp_going) {
            tmp_user = [[User alloc] init:g[@"user_id"]];
            [tmp_user setName:g[@"name"]];
            [tmp_user setForname:g[@"forname"]];
            [going addObject:tmp_user];
        }
        
        for (NSDictionary* w in tmp_waiting) {
            tmp_user = [[User alloc] init:w[@"user_id"]];
            [tmp_user setName:w[@"name"]];
            [tmp_user setForname:w[@"forname"]];
            [waiting addObject:tmp_user];
        }
        [sqeed setDescription:sqeedDescritpion];
        [[CacheHandler instance] setTmpSqeed:sqeed];
        [[[CacheHandler instance] tmpSqeed] setGoing:going];
        [[[CacheHandler instance] tmpSqeed] setWaiting:waiting];
        
        // Refreshes (loads) the activity table
        [[UIApplication sharedApplication] delegate] ;
        RootViewController *rvc = (RootViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        
        ActivitiesViewController *avc = [[[rvc swipeViewController] viewControllers] lastObject];
        [avc showDetails:indexPath];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch user!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchCategories {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{ @"function": @"getCategories" };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Fetching categories");
        SqeedCategory* tmp_cat;
        NSMutableArray* categories = [[NSMutableArray alloc] init];
        
        for (NSDictionary* category in response) {
            tmp_cat = [[SqeedCategory alloc] init];
            [tmp_cat setCategoryId:category[@"id"]];
            NSLog(@"%@", category[@"title"]);
            [tmp_cat setLabel:category[@"title"]];
            [categories addObject:tmp_cat];
        }
        [[CacheHandler instance] setCategories:categories];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to fetch categories!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) fetchGoing: (Sqeed*) sqeed {
    
}

+ (void) fetchWaiting: (Sqeed*) sqeed {
    
}

// ######################

+ (void) participate: (NSString*) userId : (NSString*) sqeedId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"participate",
                             @"userId": userId,
                             @"sqeedId": sqeedId
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Participate! (id = %@)", sqeedId);
        
        // Refreshes (loads) the activity table
        [[UIApplication sharedApplication] delegate] ;
        RootViewController *rvc = (RootViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        
        ActivitiesViewController *avc = [[[rvc swipeViewController] viewControllers] lastObject];
        
        [avc refresh];
        [[avc sqeedsTable] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to participate!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) notParticipate: (NSString*) userId : (NSString*) sqeedId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"notParticipate",
                             @"userId": userId,
                             @"sqeedId": sqeedId
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Not participate! (id = %@)", sqeedId);
        
        // Refreshes (loads) the activity table
        [[UIApplication sharedApplication] delegate] ;
        RootViewController *rvc = (RootViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        
        ActivitiesViewController *avc = [[[rvc swipeViewController] viewControllers] lastObject];
        
        [avc refresh];
        [[avc sqeedsTable] reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to not participate!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) addFriend: (NSString*) userId : (NSString*) friendId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"addFriend",
                             @"user1Id": userId,
                             @"user2Id": friendId
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Add friend! (id = %@)", friendId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to not participate!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) deleteFriend: (NSString*) userId : (NSString*) friendId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"deleteFriend",
                             @"user1Id": userId,
                             @"user2Id": friendId
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Remove friend! (id = %@)", friendId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to not participate!"];
        NSLog(@"Error: %@", error);
    }];

}

+ (void) createSqeed: (NSString*) title : (NSString*) place : (User*) creator : (NSString*) description : (NSString*) peopleMax : (NSString*) peopleMin : (SqeedCategory*) category :(NSDate*) datetimeStart : (NSDate*) datetimeEnd : (NSArray*) friends {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"addEvent",
                             @"title": title,
                             @"place": place,
                             @"creatorId": [creator userId],
                             @"description": description,
                             @"peopleMax": peopleMax,
                             @"peopleMin": peopleMin,
                             @"categoryId": [category categoryId],
                             @"datetimeStart": [NSString stringWithFormat:@"%f", [datetimeStart timeIntervalSince1970]],
                             @"datetimeEnd": [NSString stringWithFormat:@"%f", [datetimeEnd timeIntervalSince1970]],
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSString* sqeedId = response[@"event"][@"id"];
        NSLog(@"Sqeed created! (id = %@)", sqeedId);
        [self invite:sqeedId :friends];
        [[CacheHandler instance] setCreateSqeed:[[Sqeed alloc] init]];
        [[CacheHandler instance] setTmpSqeed:[[Sqeed alloc] init:sqeedId]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to create sqeed!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) deleteSqeed: (NSString*) sqeedId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"deleteEvent",
                             @"eventId": sqeedId
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Deleted! (id = %@)", sqeedId);
        
        // Refreshes (loads) the activity table
        [[UIApplication sharedApplication] delegate] ;
        RootViewController *rvc = (RootViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        
        ActivitiesViewController *avc = [[[rvc swipeViewController] viewControllers] lastObject];
        
        [avc refresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to not participate!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) invite: (NSString*) sqeedId : (NSArray*) friendIds {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError *error;
    NSData *dataFriendIds = [NSJSONSerialization dataWithJSONObject:friendIds
                                                        options:kNilOptions
                                                          error:&error];
    NSString *jsonFriendIds = [[NSString alloc] initWithData:dataFriendIds encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{
                             @"function": @"invite",
                             @"sqeedId": sqeedId,
                             @"friendIds": jsonFriendIds
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Friends invited!");
        [[UIApplication sharedApplication] delegate];
        AddFriendsViewController *afvc = (AddFriendsViewController*)[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
        [afvc performSegueWithIdentifier: @"segueBackToActivities" sender:afvc];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to invite friends!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (void) updateUser: (NSString*) userId : (NSString*) email : (NSString*) forname : (NSString*) name : (NSString*) phoneExt : (NSString*) phone : (NSString*) facebookUrl {

}

+ (void) searchUser: (NSString *) string {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function": @"search",
                             @"": string
                             };
    [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Search: %@", string);
        
        /*
         * TODO
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AlertHelper error:@"Failed to search!"];
        NSLog(@"Error: %@", error);
    }];
}

+ (UIViewController *)visibleViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self visibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self visibleViewController:selectedViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [self visibleViewController:presentedViewController];
}

@end
