//
//  DatabaseManager.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 30/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"
#import "Sqeed.h"

@interface DatabaseManager : NSObject

+ (void) loginRequest : (NSString *)username :(NSString *)password;
+ (void) login :(NSString *)userId :(NSString *)password;

+ (void) fetchUser :(User *)user;
+ (void) fetchMySqeeds :(User *)user;
+ (void) fetchDiscovered :(User *)user;
+ (void) fetchDiscovered :(User *)user :(SqeedCategory *)category;
+ (void) fetchFriends :(User *)user;
+ (void) fetchFriendRequests :(User *)user;

+ (void) fetchSqeed: (Sqeed*) sqeed :(NSIndexPath *)indexPath;

+ (void) fetchCategories;

+ (void) participate :(NSString *)userId :(NSString *)sqeedId;
+ (void) notParticipate :(NSString *)userId :(NSString *)sqeedId;
+ (void) addFriend :(NSString *)userId :(NSString *)friendId;
+ (void) deleteFriend :(NSString *)userId :(NSString *)friendId;
+ (void) createSqeed :(NSString *)title :(NSString *)place :(User *)creator :(NSString *)description :(NSString *)peopleMax :(NSString *)peopleMin :(SqeedCategory *) category :(NSDate *)datetimeStart :(NSDate *)datetimeEnd :(NSArray *)friends;
+ (void) deleteSqeed :(NSString *)sqeedId;
+ (void) invite :(NSString *)sqeedId :(NSArray *)friendIds;
+ (void) updateUser :(NSString *)userId :(NSString *)email :(NSString *)forname :(NSString *)name :(NSString *)phoneExt :(NSString *)phone :(NSString *)facebookUrl;

+ (void) searchUser :(NSString *)string;
@end
