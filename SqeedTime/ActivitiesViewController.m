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
    
    // FETCH DATA IF MORE THAN 2 MINUTES ELAPSED SINCE LAST FETCH
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[GlobalClass globalClass] MY_SQEEDS_DATA_LC] timeIntervalSinceReferenceDate] > 120)
    {
        [[GlobalClass globalClass] setMY_SQEEDS_DATA:[self fetchMySqeeds: [[GlobalClass globalClass] USER_ID]]];
        [[GlobalClass globalClass] setMY_SQEEDS_DATA_LC:[NSDate date]];
    }
    myData = [[GlobalClass globalClass] MY_SQEEDS_DATA];
    
    // PULL DOWN TO REFRESH
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:255 / 255 green:50 / 255 blue:3 / 255 alpha:1];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.sqeedsTable addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - REFRESH HANDLER
- (void)handleRefresh:(id)sender
{
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[GlobalClass globalClass] MY_SQEEDS_DATA_LC] timeIntervalSinceReferenceDate] > 1)
    {
        [[GlobalClass globalClass] setMY_SQEEDS_DATA:[self fetchMySqeeds: [[GlobalClass globalClass] USER_ID]]];
        [[GlobalClass globalClass] setMY_SQEEDS_DATA_LC:[NSDate date]];
        myData = [[GlobalClass globalClass] MY_SQEEDS_DATA];
        [self.sqeedsTable reloadData];
        if (self.refreshControl)
        {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
        }
    }
    [self.refreshControl endRefreshing];
}

#pragma mark - PASS DATA BY SEGUE
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


#pragma mark - DISPLAY SQEEDS IN A TABLE VIEW
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
    
    NSString* uniqueKey = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    
    cell.eventTitle.text = (NSString*)[[myData valueForKey:uniqueKey] valueForKey:@"title"];
    cell.eventMinMax.text = [NSString stringWithFormat:@"%@ / %@", (NSNumber *)[[myData valueForKey:uniqueKey] valueForKey:@"people_min"], (NSNumber *)[[myData valueForKey:uniqueKey] valueForKey:@"people_max"]];
    cell.eventPlace.text = (NSString*)[[myData valueForKey:uniqueKey] valueForKey:@"place"];
    cell.eventId = (NSNumber *)[[myData valueForKey:uniqueKey] valueForKey:@"id"];
    return cell;
}

- (IBAction)swipe:(id)sender
{
    [self performSegueWithIdentifier:@"segueCreateSqeed" sender:self];
}


// DISPLAY SQEED AFTER SELECTION
//-(void)tableView:(SqeedsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SqeedTableViewCell *cell = (SqeedTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    NSNumber* eventId = cell.eventId;
//    //[self performSegueWithIdentifier:@"segueSqeed" sender:self];
//}


#pragma mark - FETCH DATA FROM MYSQEEDS
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
                            (int)[postData length]];
    
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
                            (int)[postData length]];
    
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

- (IBAction)display:(id)sender
{
    long segment = [sender selectedSegmentIndex];
    if (segment == 0)
    {
        [self fetchMySqeeds: (int)[self.userId integerValue]];
    } else if (segment == 1)
    {
        [self fetchDiscovered: (int)[self.userId integerValue]];
    }
}


#pragma mark - PROVIDES AN ALERT MESSAGE
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
