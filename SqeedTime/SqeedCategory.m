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

- (id) initWithIndex: (int) index {
    self = [[CacheHandler instance] categories][index];
    return self;
}

- (id) initWithId :(NSString *)_categoryId {
    for (SqeedCategory *sc in [[CacheHandler instance] categories]) {
        if ([[sc categoryId] isEqualToString:_categoryId]) {
            self = sc;
            return self;
        }
    }
    return nil;
}
@end
