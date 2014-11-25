//
//  UIViewController+Activities.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "SqeedsTableView.h"
#import "SqeedTableViewCell.h"
#import "SqeedViewController.h"
#import "SettingsViewController.h"
#import "CCacheHandler.h"

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

NSDictionary* myData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[CCacheHandler instance] cache_lastUpdate] timeIntervalSinceReferenceDate] > 120)
    {
        [[[CCacheHandler instance] cache_currentUser] fetchMySqeeds];
        [[CCacheHandler instance] setCache_lastUpdate:[NSDate date]];
    }
    myData = [[[CCacheHandler instance] cache_currentUser] uMySqeeds];
    
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
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[CCacheHandler instance] cache_lastUpdate] timeIntervalSinceReferenceDate] > 1)
    {
        [[[CCacheHandler instance] cache_currentUser] fetchMySqeeds];
        [[CCacheHandler instance] setCache_lastUpdate:[NSDate date]];
        myData = [[[CCacheHandler instance] cache_currentUser] uMySqeeds];
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


// DISPLAY SQEED AFTER SELECTION
//-(void)tableView:(SqeedsTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SqeedTableViewCell *cell = (SqeedTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    NSNumber* eventId = cell.eventId;
//    //[self performSegueWithIdentifier:@"segueSqeed" sender:self];
//}
@end
