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
@synthesize currentSqeed;
@synthesize createSqeed;
@synthesize lastUpdate;
@synthesize categories;
@synthesize token;

static CacheHandler* instance = nil;

+ (CacheHandler*)instance
{
    if (instance == NULL)
    {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            instance = [[CacheHandler alloc] init];
        });
        [DatabaseManager fetchCategories];
        [instance setCurrentSqeed:[[Sqeed alloc] init]];
        [instance setCreateSqeed:[[Sqeed alloc] init]];
        [[instance createSqeed] setTitle:@""];
        [[instance createSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithId:@"1"]];
    }
    return instance;
}
@end
