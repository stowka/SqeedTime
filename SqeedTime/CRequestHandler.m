//
//  RequestHandler.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "CRequestHandler.h"
#import "SBJson.h"
#import "CAlertHelper.h"

@implementation CRequestHandler

static CRequestHandler* requestHandler = nil;
static NSString* serverURL = @"http://sqtdbws.net-production.ch/";

+ (NSDictionary*)post:(NSString*) args
{
    NSString *post = [[NSString alloc] initWithFormat:@"%@", args];
    NSURL *url = [NSURL URLWithString:serverURL];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    NSDictionary *headerFields =
    @{
      @"Content-Length" : postLength,
      @"Accept" : @"application/json",
      @"Content-Type" : @"application/x-www-form-urlencoded"
    };
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    for (id key in headerFields)
        [request setValue:[headerFields objectForKey:key] forHTTPHeaderField:key];
    [request setHTTPBody:postData];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseData);
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
        NSLog(@"%@", jsonData);
        return jsonData;
    }
    else
    {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        [CAlertHelper error:@"Connection failed"];
        return nil;
    }
}
@end
