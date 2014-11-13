//
//  ViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "LoginViewController.h"
#import "SBJson.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    @try {
        
        if([[_username text] isEqualToString:@""]
        || [[_password text] isEqualToString:@""])
        {
            [self alertStatus:@"Please enter both username and password" :
                @"Login failed!"];
        }
        else
        {
            NSString *post =
                [[NSString alloc]
                 initWithFormat:@"function=loginRequestV1&username=%@",
                 [_username text]];
            
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
                
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser
                                    objectWithString:responseData error:nil];
                NSInteger id = [(NSNumber *) [jsonData
                                        objectForKey:@"id"] integerValue];
                if (id > 0)
                {
                    NSString *post =
                    [[NSString alloc]
                     initWithFormat:@"function=loginV1&id=%d&password=%@",
                     id, [_password text]];
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
                    NSData *urlData=[NSURLConnection sendSynchronousRequest:request
                                                          returningResponse:&response error:&error];
                    
                    NSLog(@"Response code: %d", [response statusCode]);
                    if ([response statusCode] >= 200
                        && [response statusCode] < 300)
                    {
                        NSString *responseData =
                        [[NSString alloc]initWithData:urlData
                                             encoding:NSUTF8StringEncoding];
                        
                        SBJsonParser *jsonParser = [SBJsonParser new];
                        NSDictionary *jsonData = (NSDictionary *) [jsonParser
                                                                   objectWithString:responseData error:nil];
                        NSString *state = [(NSString *) [jsonData
                                                        valueForKey:@"state"] uppercaseString];
                        if ([state isEqual:@"LOG IN: OK"])
                        {
                            [self alertStatus:@"Connection success!":@":-)"];
                            
                            // TODO
                            /* display sqeeds */
                            UITableViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@""];
                            [self presentViewController:view animated:YES completion:nil];
                            
                            
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
                [self alertStatus:@"Connection failed" :@"Error..."];
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login failed." :@"Exception..."];
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

- (IBAction)backgroundClick:(id)sender
{
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}
@end
