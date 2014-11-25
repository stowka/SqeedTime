//
//  Category.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 25/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "MCategory.h"
#import "CRequestHandler.h"
#import "CCacheHandler.h"

@implementation MCategory
@synthesize cId;
@synthesize cLabel;
@synthesize cIconName;

static NSDictionary* categories;

- (id) initWithId: (NSInteger) categoryId
{
    self = [super init];
    cId = categoryId;
    [MCategory getCategories];
    cLabel = [[[CCacheHandler instance] cache_categories] valueForKey:[NSString stringWithFormat:@"%d", cId]];
    cIconName = [NSString stringWithFormat:@"icon-category-%@", [cLabel lowercaseString]];
    return self;
}

+ (void) getCategories
{
    if ([[CCacheHandler instance] cache_categories])
        return;
    NSString* request = @"function=getCategories";
    [[CCacheHandler instance] setCache_categories:[CRequestHandler post:request]];
}
@end
