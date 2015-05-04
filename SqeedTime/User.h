//
//  User.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property NSString* userId;
@property NSString* username;
@property NSString* name;
@property NSString* email;
@property NSString* phoneNumber;
@property NSString* salt;
@property NSArray* mySqeeds;
@property NSArray* discovered;
@property NSArray* friends;
@property NSArray* requests;
@property NSArray* pending;

@property NSString* phone;
@property NSString* phoneExt;
@property NSString* facebookUrl;

- (id) init: (NSString*) _userId;
- (void) set: (NSString *)_username :(NSString *)_name :(NSString *)_email :(NSString *)_phoneExt :(NSString *)_phone :(NSString *)_salt :(NSString *)_facebookUrl;
- (void) fetchMySqeeds;
- (void) fetchDiscovered;
- (void) fetchFriends;
- (void) update:(NSString*) key :(NSString*) value;
- (BOOL)isEqual :(id)other;
@end
