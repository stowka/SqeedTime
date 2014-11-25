//
//  User.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "MUser.h"
#import "MSqeed.h"
#import "CCacheHandler.h"
#import "CRequestHandler.h"

@implementation MUser
@synthesize uId;
@synthesize uUsername;
@synthesize uName;
@synthesize uForname;
@synthesize uEmail;
@synthesize uPhoneNumber;
@synthesize uSalt;
@synthesize uMySqeeds;
@synthesize uDiscovered;
@synthesize uFriends;

- (id) initWithId: (NSInteger)userId
{
    self = [super init];
    NSString* request = [NSString stringWithFormat:@"function=getUser&id=%d",(int)userId];
    NSDictionary* data = [CRequestHandler post:request];
    uId = userId;
    uUsername = [data valueForKey:@"username"];
    uName = [data valueForKey:@"name"];
    uForname = [data valueForKey:@"forname"];
    uEmail = [data valueForKey:@"email"];
    uPhoneNumber = [NSString stringWithFormat:@"+%@.%@", [data valueForKey:@"phone_ext"], [data valueForKey:@"phone"]];
    uSalt = [data valueForKey:@"salt"];
    [self fetchMySqeeds];
    [self fetchDiscovered];
    [[CCacheHandler instance] setCache_lastUpdate:[NSDate date]];
    return self;
}

- (void) fetchMySqeeds
{
    if (self == nil)
    {
        NSLog(@"User not initialized! (@see initWithId method)");
        return;
    }
    NSString* request = [NSString stringWithFormat:@"function=eventsByUser&id=%d", uId];
    uMySqeeds = [CRequestHandler post:request];
}

- (void) fetchDiscovered
{
    if (self == nil)
    {
        NSLog(@"User not initialized! (@see initWithId method)");
        return;
    }
    NSString* request = [NSString stringWithFormat:@"function=eventsByUser&id=%d", uId];
    uDiscovered = [CRequestHandler post:request];
}

- (void) fetchFriends
{
    if (self == nil)
    {
        NSLog(@"User not initialized! (@see initWithId method)");
        return;
    }
    NSString* request = [NSString stringWithFormat:@"function=listFriends&id=%d", uId];
    uFriends = [CRequestHandler post:request];
}

- (void) update: (NSString*) key :(NSString*) value
{
    NSLog(@"UPDATING...");
}
@end
