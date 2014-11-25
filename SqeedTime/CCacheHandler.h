//
//  CacheHandler.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUser.h"
#import "MSqeed.h"
#import "MCategory.h"

@interface CCacheHandler : NSObject
@property (strong) MUser* cache_currentUser;
@property (strong) MSqeed* cache_currentSqeed;
@property (weak, nonatomic) NSDate* cache_lastUpdate;
@property (strong) NSDictionary* cache_categories;
@property (strong, nonatomic) NSString* cache_token;

+ (CCacheHandler*) instance;
@end
