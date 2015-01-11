//
//  User.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "User.h"
#import "Sqeed.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"

@implementation User
@synthesize userId;
@synthesize username;
@synthesize name;
@synthesize forname;
@synthesize email;
@synthesize phoneNumber;
@synthesize salt;

@synthesize mySqeeds;
@synthesize discovered;
@synthesize friends;
@synthesize friendRequests;

@synthesize phone;
@synthesize phoneExt;
@synthesize facebookUrl;

- (id) init: (NSString*) _userId {
    self = [super init];
    userId = _userId;
    return self;
}

- (void) set: (NSString*) _username : (NSString*) _name : (NSString*) _forname : (NSString*) _email : (NSString*) _phoneExt : (NSString*) _phone : (NSString*) _salt : (NSString*) _facebookUrl {
    username = _username;
    name = _name;
    forname = _forname;
    email = _email;
    phoneExt = _phoneExt;
    phone = _phone;
    phoneNumber = [NSString stringWithFormat:@"+%@.%@", phoneExt, phone];
    salt = _salt;
    facebookUrl = _facebookUrl;
    [[CacheHandler instance] setLastUpdate:[NSDate date]];
}

- (void) fetchMySqeeds {
    if (self == nil)
    {
        NSLog(@"User not initialized!");
        return;
    }
    [DatabaseManager fetchMySqeeds:self];
}

- (void) fetchDiscovered {
    if (self == nil)
    {
        NSLog(@"User not initialized!");
        return;
    }
    [DatabaseManager fetchDiscovered:self];
}

- (void) fetchFriends {
    if (self == nil)
    {
        NSLog(@"User not initialized!");
        return;
    }
    [DatabaseManager fetchFriends:self];
}

- (void) fetchFriendRequests {
    if (self == nil)
    {
        NSLog(@"User not initialized!");
        return;
    }
    [DatabaseManager fetchFriendRequests:self];
}

- (void) update:(NSString*) key :(NSString*) value {
    NSMutableDictionary* userData = [[NSMutableDictionary alloc] init];
    [userData setObject:forname forKey:@"forname"];
    [userData setObject:name forKey:@"name"];
    [userData setObject:email forKey:@"email"];
    [userData setObject:facebookUrl forKey:@"facebookUrl"];
    
    [userData setObject:value forKey:key];
    
    forname = [userData valueForKey:@"forname"];
    name = [userData valueForKey:@"name"];
    email = [userData valueForKey:@"email"];
    facebookUrl = [userData valueForKey:@"facebookUrl"];
    
    [DatabaseManager updateUser:userId :email :name :forname :phoneExt :phone :facebookUrl];
}

- (BOOL)isEqual :(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    if ([self.userId isEqualToString:((User *)other).userId])
        return YES;
    return NO;
}

@end
