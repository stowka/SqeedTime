//
//  Sqeed.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCategory.h"

@interface MSqeed : NSObject
@property NSInteger sId;
@property NSString* sTitle;
@property NSString* sPlace;
@property MCategory* sCategory;
@property NSInteger sPeopleMin;
@property NSInteger sPeopleMax;
@property NSString* sDescription;
@property NSDate* sDateStart1;
@property NSDate* sDateStart2;
@property NSDate* sDateStart3;
@property NSDate* sDuration;
@property NSDictionary* sUsersInvited; // key: User*, value: state (pending, accepted, refused)

- (id) initWithId:(NSInteger) sqeedId;
- (void) fetchUsersInvited;
@end
