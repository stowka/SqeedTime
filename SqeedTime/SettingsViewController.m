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
#import "SBJson.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

NSDictionary* myData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // FETCH USER DATA
    myData = [self fetchUser: [self.userId integerValue]];
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
    
    NSLog(@"%d", indexPath.row);
    
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
                cell.value.text = ![[myData valueForKey:@"email"]  isEqual: @"<null>"] ? [NSString stringWithFormat:@"%@", [myData valueForKey:@"email"]] : @"";
                break;
            case 3:
                cell.title.text = @"Phone";
                cell.value.text = ![[myData valueForKey:@"phone"]  isEqual: @"<null>"] && ![[myData valueForKey:@"phone_ext"] isEqual: @"<null>"] ? [NSString stringWithFormat:@"+%@.%@", [myData valueForKey:@"phone_ext"], [myData valueForKey:@"phone"]] : @"";
                break;
            case 4:
                cell.title.text = @"Facebook URL";
                cell.value.text = ![[myData valueForKey:@"facebook_url"]  isEqual: @"<null>"] ? [NSString stringWithFormat:@"%@", [myData valueForKey:@"facebook_url"]] : @"";
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

-(void)tableView:(SettingsTableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) // MY ACCOUNT
    {
        switch(indexPath.row)
        {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            case 3:
                
                break;
            case 4:
               
                break;
            case 5:
               
                break;
            default:
                
                break;
        }
    }
    else // MORE INFO
    {
        switch(indexPath.row)
        {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            case 3:
                
                break;
            default:
                
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"segueEditSettings" sender:self];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
