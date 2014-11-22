//
//  SettingsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableView.h"
#import "SettingsTableViewCell.h"
#import "EditSettingsViewController.h"
#import "DisplaySettingsViewController.h"
#import "ProfileViewController.h"
#import "SBJson.h"
#import "GlobalClass.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

NSDictionary* myData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // FETCH USER DATA IF MORE THAN 2 MINUTES ELAPSED SINCE LAST FETCH
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[GlobalClass globalClass] USER_DATA_LC] timeIntervalSinceReferenceDate] > 120)
    {
        [[GlobalClass globalClass] setUSER_DATA:[self fetchUser: [[GlobalClass globalClass] USER_ID]]];
        [[GlobalClass globalClass] setUSER_DATA_LC:[NSDate date]];
    }
    myData = [[GlobalClass globalClass] USER_DATA];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section ? @"More informations" : @"My account";
}

- (NSInteger)tableView:(SettingsTableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? 4 : 6;
}

- (UITableViewCell*)tableView:(SettingsTableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingsCellID";
    SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
    if (cell == nil) {
        cell = [[SettingsTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (!indexPath.section)
    {
        switch(indexPath.row)
        {
            case 0:
                cell.title.text = @"Name";
                cell.value.text = ![[myData valueForKey:@"name"]  isEqual: @"<null>"] ? [NSString stringWithFormat:@"%@", [myData valueForKey:@"name"]] : @"";
                break;
            case 1:
                cell.title.text = @"Forname";
                cell.value.text = ![[myData valueForKey:@"forname"]  isEqual: @"<null>"] ? [NSString stringWithFormat:@"%@", [myData valueForKey:@"forname"]] : @"";
                break;
            case 2:
                cell.title.text = @"E-mail";
                cell.value.text = ![[myData valueForKey:@"email"]  isEqual: @"(null)"] ? [NSString stringWithFormat:@"%@", [myData valueForKey:@"email"]] : @"";
                break;
            case 3:
                cell.title.text = @"Phone";
                cell.value.text = ![[myData valueForKey:@"phone"]  isEqual: @"(null)"] && ![[myData valueForKey:@"phone_ext"] isEqual: @"(null)"] ? [NSString stringWithFormat:@"+%@.%@", [myData valueForKey:@"phone_ext"], [myData valueForKey:@"phone"]] : @"";
                break;
            case 4:
                cell.title.text = @"Facebook URL";
                cell.value.text = ![[myData valueForKey:@"facebook_url"]  isEqual: @"(null)"] ? [NSString stringWithFormat:@"%@", [myData valueForKey:@"facebook_url"]] : @"";
                break;
            case 5:
                cell.title.text = @"Profile";
                cell.value.text = @"❯";
                break;
            default:
                cell.title.text = @"ERROR";
                cell.value.text = @"";
                break;
        }
    }
    else
    {
        switch(indexPath.row)
        {
            case 0:
                cell.title.text = @"Privacy Policy";
                cell.value.text = @"❯";
                break;
            case 1:
                cell.title.text = @"Terms of use";
                cell.value.text = @"❯";
                break;
            case 2:
                cell.title.text = @"Geolocation";
                cell.value.text = @"❯";
                break;
            case 3:
                cell.title.text = @"About us";
                cell.value.text = @"❯";
                break;
            default:
                cell.title.text = @"ERROR";
                cell.value.text = @"";
                break;
        }
    }

    return cell;
}

-(void)tableView:(SettingsTableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* segue;
    if (!indexPath.section) // MY ACCOUNT
        segue = indexPath.row == 5 ? @"segueSelfProfile" : @"segueEditSettings";
    else // MORE INFO
        segue = indexPath.row == 2 ? @"segueMap" : @"segueDisplaySettings";
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:segue sender:self];
}

- (NSDictionary*)fetchUser:(int) userId
{
    NSString *post =
    [[NSString alloc]
     initWithFormat:@"function=getUser&id=%d",
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.settingsTable indexPathForSelectedRow];
    EditSettingsViewController* destViewController = segue.destinationViewController;
    SettingsTableViewCell* cell = (SettingsTableViewCell*)[self.settingsTable cellForRowAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"segueEditSettings"])
    {
        destViewController.key = cell.title.text;
        destViewController.value = cell.value.text;
    }
    
    if ([segue.identifier isEqualToString:@"segueDisplaySettings"])
    {
         // TODO
    }
}

@end
