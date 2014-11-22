//
//  GlobalClass.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "GlobalClass.h"

@implementation GlobalClass

@synthesize USER_ID;
@synthesize CURRENT_SQEED;
@synthesize USER_TOKEN;

// main activity cache
@synthesize USER_DATA;
@synthesize MY_SQEEDS_DATA;
@synthesize DISCOVERED_DATA;
@synthesize LAST_SQEED_DATA;

@synthesize USER_DATA_LC;
@synthesize MY_SQEEDS_DATA_LC;
@synthesize DISCOVERED_DATA_LC;

// properties to cache new sqeed data
@synthesize NEW_SQEED_CATEGORY_ID;
@synthesize NEW_SQEED_DESCRIPTION;
@synthesize NEW_SQEED_END;
@synthesize NEW_SQEED_START;
@synthesize NEW_SQEED_PLACE;
@synthesize NEW_SQEED_TITLE;

static GlobalClass* globalClass = nil;

+ (GlobalClass*)globalClass
{
    if (globalClass == NULL)
    {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            globalClass = [[GlobalClass alloc] init];
        });
    }
    return globalClass;
}
@end
