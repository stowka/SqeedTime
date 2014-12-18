//
//  Sqeed.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqeedCategory.h"
#import "User.h"

@interface Sqeed : NSObject
@property NSString* sqeedId;
@property NSString* title;
@property NSString* place;

@property SqeedCategory* sqeedCategory;
@property User* creator;
@property NSString* creatorName;
@property NSString* creatorFirstName;

@property NSString* peopleMin;
@property NSString* peopleMax;

@property NSString* sqeedDescription;

@property NSDate* dateStart;
@property NSDate* dateEnd;

@property NSArray* going;
@property NSArray* waiting;
@property NSString* goingCount;
@property NSString* waitingCount;

- (id) init:(NSString*) _sqeedId;
- (void) setHeaders: (NSString*) _title : (NSString*) _place : (SqeedCategory*) _category : (NSString*) _peopleMin : (NSString*) _peopleMax : (NSDate*) _dateStart : (NSDate*) _dateEnd;

- (void) setDetails: (NSString*) _description;
- (void) fetchGoing;
- (void) fetchWaiting;

- (void) createSqeed;
@end