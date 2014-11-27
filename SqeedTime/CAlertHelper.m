//
//  CAlertHelper.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 27/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "CAlertHelper.h"

@implementation CAlertHelper

+ (void) error:(NSString*)message
{
    [self alert:message :@"Error"];
}

+ (void) status:(NSString*)message
{
    [self alert:message :@"Status"];
}

+ (void) alert:(NSString*)message :(NSString*)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end
