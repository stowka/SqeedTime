//
//  ViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
    NSLog(@"Login..."); /* for testing purpose only */
    @try {
        
        if([[_username text] isEqualToString:@""]
        || [[_password text] isEqualToString:@""])
        {
            [self alertStatus:@"Please enter both Username and Password" :
                @"Login Failed!"];
        }
        else
        {
            NSString *post =
                [[NSString alloc]
                 initWithFormat:@"function=loginRequestV1&username=%@",
                 [_username text]];
            NSLog(@"PostData: %@", post);
            
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
            
            /* just in case :P */
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response error:&error];
            
            NSLog(@"Response code: %d", [response statusCode]);
            if ([response statusCode] >= 200
            && [response statusCode] < 300)
            {
                NSString *responseData =
                        [[NSString alloc]initWithData:urlData
                                     encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser
                                    objectWithString:responseData error:nil];
                NSLog(@"%@", jsonData);
                NSInteger id = [(NSNumber *) [jsonData
                                        objectForKey:@"id"] integerValue];
                NSLog(@"login id: %d", id);
                if (id > 0)
                {
                    NSString *post =
                    [[NSString alloc]
                     initWithFormat:@"function=loginV1&id=%d&password=%@",
                     id, [_password text]];
                    NSLog(@"PostData: %@", post);
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
                    
                    /* just in case :P */
                    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
                    
                    NSError *error = [[NSError alloc] init];
                    NSHTTPURLResponse *response = nil;
                    NSData *urlData=[NSURLConnection sendSynchronousRequest:request
                                                          returningResponse:&response error:&error];
                    
                    NSLog(@"Response code: %d", [response statusCode]);
                    if ([response statusCode] >= 200
                        && [response statusCode] < 300)
                    {
                        NSString *responseData =
                        [[NSString alloc]initWithData:urlData
                                             encoding:NSUTF8StringEncoding];
                        NSLog(@"Response ==> %@", responseData);
                        
                        SBJsonParser *jsonParser = [SBJsonParser new];
                        NSDictionary *jsonData = (NSDictionary *) [jsonParser
                                                                   objectWithString:responseData error:nil];
                        NSLog(@"%@", jsonData);
                        NSString *state = [(NSString *) [jsonData
                                                        valueForKey:@"state"] uppercaseString];
                        NSLog(@"%@", state);
                        if ([state  isEqual: @"LOG IN: OK"])
                        {
                            [self alertStatus:@"Connection Success!" :@":-)"];
                        }
                        else
                        {
                            [self alertStatus:@"Connection Failed!" :state];
                        }
                    }
                }
            }
            else
            {
                if (error)
                    NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Login Failed!"];
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }
}

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (IBAction)backgroundClick:(id)sender
{
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}
@end
