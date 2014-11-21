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
#import "SqeedViewController.h"
#import "SettingsViewController.h"
#import "GlobalClass.h"

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

NSDictionary* myData;
NSArray* myKeys;
NSArray* myValues;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // STORE GLOBAL USER ID AND TOKEN
    if ([self.userId integerValue])
        [[GlobalClass globalClass] setUSER_ID:(int)[self.userId integerValue]];
    
    // FETCH DATA
    myData = [self fetchMySqeeds: [[GlobalClass globalClass] USER_ID]];
    
    //NSLog(@"%@", myData); /* for testing purpose only */
    
    // SWIPE LEFT TO ADD NEW SQEED
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// PASS DATA BY SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueSqeed"])
    {
        NSIndexPath *indexPath = [self.sqeedsTable indexPathForCell:sender];
        SqeedViewController* destViewController = segue.destinationViewController;
        SqeedTableViewCell* cell = (SqeedTableViewCell*)[self.sqeedsTable cellForRowAtIndexPath:indexPath];
        destViewController.eventId = cell.eventId;
    }
    
    if ([segue.identifier isEqualToString:@"segueSettings"])
    {
        SettingsViewController* destViewController = segue.destinationViewController;
        destViewController.userId = self.userId;
    }
}

// PERFORM CALL SEGUE ON SWIPE LEFT
- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint velocity = [panRecognizer velocityInView:self.view];
    if (velocity.x < 0)
        [self performSegueWithIdentifier:@"segueNewSqeed1" sender:panRecognizer];
}


// DISPLAY SQEEDS IN A TABLE VIEW
- (NSInteger)tableView:(SqeedsTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myData count];
}

- (UITableViewCell *)tableView:(SqeedsTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    SqeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[SqeedTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString* uniqueKey = [NSString stringWithFormat:@"%d",indexPath.row];
    
    cell.eventTitle.text = (NSString*)[[myData valueForKey:uniqueKey] valueForKey:@"title"];
    cell.eventMinMax.text = [NSString stringWithFormat:@"%@ / %@", (NSNumber *)[[myData valueForKey:uniqueKey] valueForKey:@"people_min"], (NSNumber *)[[myData valueForKey:uniqueKey] valueForKey:@"people_max"]];
    cell.eventPlace.text = (NSString*)[[myData valueForKey:uniqueKey] valueForKey:@"place"];
    cell.eventId = (NSNumber *)[[myData valueForKey:uniqueKey] valueForKey:@"id"];
    return cell;
}


// DISPLAY SQEED AFTER SELECTION
//-(void)tableView:(SqeedsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SqeedTableViewCell *cell = (SqeedTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    NSNumber* eventId = cell.eventId;
//    //[self performSegueWithIdentifier:@"segueSqeed" sender:self];
//}


// FETCH DATA FROM MYSQEEDS
- (NSDictionary*)fetchMySqeeds:(int)userId
{
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

- (NSDictionary*)fetchDiscovered:(int)userId
{
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



- (void)displaySqeeds:(NSDictionary*)data
{
    return;
}

- (IBAction)display:(id)sender
{
    long segment = [sender selectedSegmentIndex];
    if (segment == 0)
    {
        [self fetchMySqeeds: [self.userId integerValue]];
    } else if (segment == 1)
    {
        [self fetchDiscovered: [self.userId integerValue]];
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
