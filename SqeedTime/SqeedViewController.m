//
//  UIViewController+SqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 20/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SqeedViewController.h"
#import "SBJson.h"

@interface SqeedViewController()

@end

@implementation SqeedViewController
NSDictionary* myData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myData = [self fetchSqeed: [self.eventId integerValue]];
    self.eventTitle.text = (NSString*)[myData valueForKey:@"title"];
    self.eventPlace.text = (NSString*)[myData valueForKey:@"place"];
    self.eventMinMax.text = [NSString stringWithFormat:@"%@ / %@", (NSNumber *)[myData valueForKey:@"people_min"], (NSNumber *)[myData valueForKey:@"people_max"]];
    self.eventDescription.text = (NSString*)[myData valueForKey:@"description"];
}

- (NSDictionary*)fetchSqeed:(int)eventId
{
    NSString *post = [[NSString alloc] initWithFormat:@"function=getEvent&id=%d", eventId];
    
    NSURL *url = [NSURL URLWithString:
                  @"http://sqtdbws.net-production.ch/"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                          allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",
                            [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSLog(@"Response code: %d", [response statusCode]);
    if ([response statusCode] >= 200
        && [response statusCode] < 300)
    {
        NSString *responseData =
        [[NSString alloc]initWithData:urlData
                             encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
        return jsonData;
    }
    else
    {
        if (error)
            NSLog(@"Error: %@", error);
        [self alertStatus:@"Connection failed" :@"Error..."];
        return nil;
    }
}

/**
 * provides an alert message
 */
- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

@end
