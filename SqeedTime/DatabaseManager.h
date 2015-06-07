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
#import "VoteOption.h"

@interface DatabaseManager : NSObject

+ (void) login :(NSString *)username :(NSString *)password;

+ (void) fetchUser;
+ (void) fetchUser :(User *)user;
+ (void) fetchMySqeeds;
+ (void) fetchDiscovered;
+ (void) fetchDiscovered :(NSString *)categoryId;
+ (void) fetchFriends;

+ (void) fetchSqeed :(Sqeed*)sqeed :(NSIndexPath *)indexPath;

+ (void) fetchCategories;

+ (void) participate :(NSString *)sqeedId;
+ (void) notParticipate :(NSString *)sqeedId;
+ (void) addFriend :(NSString *)friendId;
+ (void) deleteFriend :(NSString *)friendId;
+ (void) createSqeed :(NSString *)title :(NSString *)place :(NSString *)description :(NSString *)peopleMax :(SqeedCategory *) category :(NSDate *)datetimeStart :(NSDate *)datetimeEnd :(NSString *)privateAccess;
+ (void)addDatetimeOption :(NSString *)sqeedId :(VoteOption *)voteOption :(int)index;
+ (void)deleteDatetimeOption :(NSString *)sqeedId :(NSString *)voteId;
+ (void)vote :(NSString *)sqeedId :(NSString *)optionId;
+ (void) deleteSqeed :(NSString *)sqeedId;
+ (void) invite :(NSString *)sqeedId :(NSArray *)friendIds;
+ (void) updateEvent :(NSString *)sqeedId :(NSString *)title :(NSString *)place :(NSString *)description :(NSString *)peopleMax :(SqeedCategory *)category;
+ (void) updateEventAccess :(NSString *)sqeedId :(NSString *)isPrivate;

+ (void) updateUser :(NSString *)email :(NSString *)name :(NSString *)phoneExt :(NSString *)phone :(NSString *)facebookUrl;

+ (void) getGroups;
+ (void) addGroup :(NSString *)title :(NSArray *)friendIds;
+ (void) updateGroup :(NSString *)groupId :(NSArray *)friendIds;
+ (void) delGroup :(NSString *)groupId :(NSArray *)friendIds;
+ (void) addToGroup :(NSString *)groupId :(NSArray *)friendIds;

+ (void) searchUser :(NSString *)string;
+ (void)searchByPhones :(NSArray *)phoneArray;

+ (void) postMessage :(NSString *)sqeedId :(NSString *)message;
+ (void) fetchMessages :(NSString *)sqeedId;

+ (void) signup :(NSString *)email :(NSString *)password :(NSString *)phone :(NSString *)phoneExt :(NSString *)gender :(NSString *)birthYear;

+ (void) logout;
@end
