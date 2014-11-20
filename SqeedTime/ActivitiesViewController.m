//
//  UIViewController+Activities.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "SBJson.h"
#import "SqeedsTableView.h"
#import "SqeedTableViewCell.h"

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMySqeeds:(int)userId {
    NSString *post =
    [[NSString alloc]
     initWithFormat:@"function=eventsByUser&id=%d",
     userId];
    
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
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response error:&error];
    //NSLog(@"Response code: %d", [response statusCode]);
    if ([response statusCode] >= 200
        && [response statusCode] < 300)
    {
        NSString *responseData =
        [[NSString alloc]initWithData:urlData
                             encoding:NSUTF8StringEncoding];
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary *jsonData = (NSDictionary *) [jsonParser
                                                   objectWithString:responseData error:nil];
        // iterates over sqeed events:
        NSLog(@"%@", jsonData);
        NSString *description;
        NSString *place;
        NSString *title;
        
        NSInteger category_id;
        NSInteger people_max;
        NSInteger people_min;
        NSInteger event_id;
        for(id event in jsonData)
        {
            NSLog(@"%@", [jsonData objectForKey:event]);
            description = (NSString*)[[jsonData objectForKey:event] valueForKey:@"description"];
            place = (NSString*)[[jsonData objectForKey:event] valueForKey:@"place"];
            title = (NSString*)[[jsonData objectForKey:event] valueForKey:@"title"];
            category_id = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"category_id"] integerValue];
            people_max = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"people_max"] integerValue];
            people_min = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"people_min"] integerValue];
            event_id = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"id"] integerValue];
           NSLog(@"title: %@\nplace: %@\ndescription: %@\n\n", title, place, description);
           // NSLog(@"category_id: %d\npeople_max: %d\npeople_min: %d\nevent_id: %d", category_id, people_max, people_min, event_id);
            
            // TODO
            // display event in uitableview cells!
        }
    }
    else
    {
        if (error)
            NSLog(@"Error: %@", error);
        [self alertStatus:@"Connection failed" :@"Error..."];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SqeedTableViewCell *cell = [[SqeedTableViewCell alloc]init];
    cell.eventTitle.text = @"ANTOINE";
    
    return cell;
}

- (void)fetchDiscovered:(int)userId
{
    return;
}



- (void)displaySqeeds:(NSDictionary*)data
{
    return;
}

- (IBAction)display:(id)sender {
    long segment = [sender selectedSegmentIndex];
    if (segment == 0)
    {
        [self fetchMySqeeds:14];
    } else if (segment == 1)
    {
        [self fetchDiscovered:14];
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
