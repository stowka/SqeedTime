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
@synthesize USER_TOKEN;

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
