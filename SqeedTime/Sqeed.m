//
//  Sqeed.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "Sqeed.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"

@implementation Sqeed
@synthesize sqeedId;
@synthesize title;
@synthesize sqeedDescription;
@synthesize sqeedCategory;
@synthesize place;
@synthesize peopleMin;
@synthesize peopleMax;
@synthesize dateStart;
@synthesize dateEnd;
@synthesize going;
@synthesize waiting;
@synthesize goingCount;
@synthesize waitingCount;
@synthesize creator;
@synthesize creatorFirstName;
@synthesize creatorName;

- (id) init: (NSString*) _sqeedId
{
    if (self = [super init])
        [self setSqeedId:_sqeedId];
    return self;
}

- (void) setHeaders:(NSString *)_title :(NSString *)_place :(SqeedCategory *)_category :(NSString *)_peopleMin :(NSString *)_peopleMax :(NSDate *)_dateStart :(NSDate *)_dateEnd {
    title = _title;
    place = _place;
    sqeedCategory = _category;
    peopleMin = _peopleMin;
    peopleMax = _peopleMax;
    dateStart = _dateStart;
    dateEnd = _dateEnd;
    
    [[CacheHandler instance] setLastUpdate:[NSDate date]];
}

- (void) setDetails:(NSString *)_description {
    sqeedDescription = _description;
    [self fetchGoing];
    [self fetchWaiting];
    
    [[CacheHandler instance] setLastUpdate:[NSDate date]];
}

- (void) fetchGoing {
    if (self == nil)
    {
        NSLog(@"Sqeed not initialized!");
        return;
    }
    [DatabaseManager fetchGoing:self];
}

- (void) fetchWaiting {
    if (self == nil)
    {
        NSLog(@"Sqeed not initialized!");
        return;
    }
    [DatabaseManager fetchWaiting:self];
}

- (void) createSqeed
{
    //[DatabaseManager createSqeed:title :place :description :peopleMin :peopleMax :[category categoryId] : : :<#(NSString *)#>];
}
@end
