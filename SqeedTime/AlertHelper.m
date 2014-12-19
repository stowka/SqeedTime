//
//  AlertHelper.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 27/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

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

+ (void) show:(NSString*)message :(NSString*)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

@end
