//
//  CacheHandler.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Sqeed.h"
#import "SqeedCategory.h"

@interface CacheHandler : NSObject
@property (strong) NSString* currentUserId;
@property (strong) User* currentUser;
@property (strong) User* tmpUser;
@property (strong) Sqeed* currentSqeed;
@property (strong) Sqeed* tmpSqeed;
@property (strong) Sqeed* createSqeed;
@property (weak, nonatomic) NSDate* lastUpdate;
@property (strong) NSArray* categories;
@property (strong, nonatomic) NSString* token;

+ (CacheHandler*) instance;
@end
