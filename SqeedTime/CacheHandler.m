//
//  CacheHandler.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "CacheHandler.h"
#import "DatabaseManager.h"

@implementation CacheHandler
@synthesize currentUserId;
@synthesize currentUser;
@synthesize tmpUser;
@synthesize currentSqeed;
@synthesize tmpSqeed;
@synthesize createSqeed;
@synthesize editSqeed;
@synthesize friendIds;
@synthesize phoneMatches;
@synthesize lastUpdate;
@synthesize categories;
@synthesize token;
@synthesize pn_token;
@synthesize contacts;
@synthesize editing;
@synthesize chatMessages;
@synthesize categoryFilter;

static CacheHandler* instance = nil;

+ (CacheHandler*)instance {
    if (NULL == instance) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            instance = [[CacheHandler alloc] init];
        });
        [DatabaseManager fetchCategories];
        [instance setCurrentSqeed:[[Sqeed alloc] init]];
        [instance setCreateSqeed:[[Sqeed alloc] init]];
        [instance setFriendIds:[[NSArray alloc] init]];
        [instance setChatMessages:[[NSArray alloc] init]];
        [[instance createSqeed] setTitle:@""];
        [[instance createSqeed] setPeopleMax:@"10"];
        [[instance createSqeed] setPrivateAccess:@"0"];
        [[instance createSqeed] setDateStart:[NSDate date]];
        [[instance createSqeed] setDateEnd:[NSDate dateWithTimeIntervalSinceNow:1800]];
        [[instance createSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:0]];
        
        
        [[instance editSqeed] setTitle:@""];
        [[instance editSqeed] setPeopleMax:@"10"];
        [[instance editSqeed] setPrivateAccess:@"0"];
        [[instance editSqeed] setDateStart:[NSDate date]];
        [[instance editSqeed] setDateEnd:[NSDate dateWithTimeIntervalSinceNow:1800]];
        [[instance editSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:0]];
        
        [instance setCategoryFilter:@"0"];
    }
    return instance;
}
@end
