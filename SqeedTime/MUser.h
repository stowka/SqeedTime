//
//  User.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUser : NSObject
@property NSInteger uId;
@property (readonly) NSString* uUsername;
@property NSString* uName;
@property NSString* uForname;
@property NSString* uEmail;
@property (readonly) NSString* uPhoneNumber;
@property (readonly) NSString* uSalt;
@property NSDictionary* uMySqeeds;
@property NSDictionary* uDiscovered;
@property NSDictionary* uFriends; // key: User*, value: state (requestSent, requestReceived, friend)

- (id) initWithId:(NSInteger) userId;
- (void) fetchMySqeeds;
- (void) fetchDiscovered;
- (void) fetchFriends;
- (void) update:(NSString*) key :(NSString*) value;
@end
