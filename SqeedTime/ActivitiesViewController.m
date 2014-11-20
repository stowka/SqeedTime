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
NSDictionary* myData;
NSArray* myKeys;
NSArray* myValues;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    myData = [self fetchMySqeeds:14];
//    myKeys = [myData ]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(SqeedsTableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [myData count];
}

- (UITableViewCell *)tableView:(SqeedsTableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    SqeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[SqeedTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString* uniqueKey = [NSString stringWithFormat:@"%d",indexPath.row];
    NSLog(@"%@", (NSString*)[[myData valueForKey:uniqueKey] valueForKey:@"title"]);
    cell.eventTitle.text = @"Tennis !";
    cell.eventMinMax.text = [NSString stringWithFormat:@"%d / %d", 11, 22];
    cell.eventCreator.text = [NSString stringWithFormat:@"created by %@", @"Stowka"];
    
    return cell;
}

-(void)tableView:(SqeedsTableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%d Row:%d selected and its data is %@",
          indexPath.section,indexPath.row,cell.textLabel.text);
}

- (NSDictionary*)fetchMySqeeds:(int)userId {
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
//        NSLog(@"%@", jsonData);
//        NSString *description;
//        NSString *place;
//        NSString *title;
//        
//        NSInteger category_id;
//        NSInteger people_max;
//        NSInteger people_min;
//        NSInteger event_id;
        return jsonData;
//        for(id event in jsonData)
//        {
//            NSLog(@"%@", [jsonData objectForKey:event]);
//            description = (NSString*)[[jsonData objectForKey:event] valueForKey:@"description"];
//            place = (NSString*)[[jsonData objectForKey:event] valueForKey:@"place"];
//            title = (NSString*)[[jsonData objectForKey:event] valueForKey:@"title"];
//            category_id = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"category_id"] integerValue];
//            people_max = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"people_max"] integerValue];
//            people_min = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"people_min"] integerValue];
//            event_id = [(NSNumber *) [[jsonData objectForKey:event] objectForKey:@"id"] integerValue];
//           NSLog(@"title: %@\nplace: %@\ndescription: %@\n\n", title, place, description);
//        }
    }
    else
    {
        if (error)
            NSLog(@"Error: %@", error);
        [self alertStatus:@"Connection failed" :@"Error..."];
        return nil;
    }
}

- (NSDictionary*)fetchDiscovered:(int)userId
{
    return nil;
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
