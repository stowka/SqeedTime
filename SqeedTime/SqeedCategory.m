//
//  SqeedCategory.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SqeedCategory.h"
#import "CacheHandler.h"

@implementation SqeedCategory
@synthesize categoryId;
@synthesize label;

static NSDictionary* categories;

- (id) initWithId: (NSString*) _categoryId
{
    self = [[CacheHandler instance] categories][_categoryId];
    
    return self;
}
@end
