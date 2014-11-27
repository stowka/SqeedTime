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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void) status:(NSString*)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Status"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
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
