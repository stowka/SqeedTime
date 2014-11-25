//
//  Sqeed.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "MSqeed.h"
#import "CRequestHandler.h"

@implementation MSqeed
@synthesize sId;
@synthesize sTitle;
@synthesize sDescription;
@synthesize sCategory;
@synthesize sPlace;
@synthesize sPeopleMin;
@synthesize sPeopleMax;
@synthesize sDateStart1;
@synthesize sDateStart2;
@synthesize sDateStart3;
@synthesize sDuration;
@synthesize sUsersInvited;

#pragma mark - TODO
- (id) initWithId: (NSInteger) sqeedId
{
    self = [super init];
    NSString* request = [NSString stringWithFormat:@"function=getEvent&id=%d",(int)sqeedId];
    NSDictionary* data = [CRequestHandler post:request];
    sId = sqeedId;
    sTitle = [data valueForKey:@"title"];
    sDescription = [data valueForKey:@"description"];
    sPlace = [data valueForKey:@"place"];
    sPeopleMin = (int)[[data valueForKey:@"people_min"] integerValue];
    sPeopleMax = (int)[[data valueForKey:@"people_max"] integerValue];
    // TODO: sDateStart, sDateEnd
    [self fetchUsersInvited];
    return self;
}

#pragma mark - TODO
- (void) fetchUsersInvited
{
    if (self == nil)
    {
        NSLog(@"Sqeed not initialized! (@see initWithId method)");
        return;
    }
    NSString* request = [NSString stringWithFormat:@"function= # TODO # &id=%d", sId];
    sUsersInvited = [CRequestHandler post:request];
}
@end
