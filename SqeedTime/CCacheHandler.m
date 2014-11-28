//
//  CacheHandler.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "CCacheHandler.h"

@implementation CCacheHandler
@synthesize cache_currentUser;
@synthesize cache_currentSqeed;
@synthesize cache_newSqeed;
@synthesize cache_lastUpdate;
@synthesize cache_categories;
@synthesize cache_token;

static CCacheHandler* instance = nil;

+ (CCacheHandler*)instance
{
    if (instance == NULL)
    {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            instance = [[CCacheHandler alloc] init];
        });
        [MCategory getCategories];
        [instance setCache_currentSqeed:[[MSqeed alloc] init]];
    }
    return instance;
}
@end
