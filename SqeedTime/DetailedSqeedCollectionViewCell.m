//
//  DetailedSqeedCollectionViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 14/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "DetailedSqeedCollectionViewCell.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"
#import "AlertHelper.h"
#import "User.h"

@implementation DetailedSqeedCollectionViewCell

- (void) confirm :(NSString *)message :(NSString *)title {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:self
                              cancelButtonTitle:@"Yes"
                              otherButtonTitles:nil];
    
    [alertView addButtonWithTitle:@"No"];
    [alertView show];
}

- (IBAction)chooseDate:(id)sender {
}

- (void)alertView :(UIAlertView *)alertView clickedButtonAtIndex :(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [DatabaseManager deleteSqeed:_eventId];
    } else if (buttonIndex == 1) {
        NSLog(@"NO");
    }
}

- (IBAction)join:(id)sender {
    [DatabaseManager participate:[[CacheHandler instance] currentUserId] :_eventId];
}

- (IBAction)decline:(id)sender {
    [DatabaseManager notParticipate:[[CacheHandler instance] currentUserId] :_eventId];
}

- (IBAction)deleteSqeed:(id)sender {
    [self confirm:@"Are you sure you want to delete this Sqeed?" :@"Delete Sqeed"];
}

- (IBAction)answer:(id)sender {
    if ([_eventAnswer selectedSegmentIndex] == 0) {
        [DatabaseManager participate:[[CacheHandler instance] currentUserId] :_eventId];
    } else if ([_eventAnswer selectedSegmentIndex] == 1) {
        [DatabaseManager notParticipate:[[CacheHandler instance] currentUserId] :_eventId];
    }
}

- (IBAction)showPeople:(id)sender {
    NSMutableString *people = [NSMutableString stringWithCapacity:2000];
    if ([_eventPeopleGoingWaiting selectedSegmentIndex] == 0) {
        for (User *user in [[[CacheHandler instance] tmpSqeed] going])
            [people appendFormat:@"%@ %@\n", [user forname], [user name]];
        [AlertHelper show:[NSString stringWithFormat:@"%@", people] :@"Going"];
    } else {
        for (User *user in [[[CacheHandler instance] tmpSqeed] waiting])
            [people appendFormat:@"%@ %@\n", [user forname], [user name]];
        [AlertHelper show:[NSString stringWithFormat:@"%@", people] :@"Waiting"];
    }
    [_eventPeopleGoingWaiting setSelectedSegmentIndex:-1];
}

- (int) hasAnswered {
    if ([[[[CacheHandler instance] tmpSqeed] waiting] containsObject:[[CacheHandler instance] currentUser]])
        return -1;
    else if ([[[[CacheHandler instance] tmpSqeed] going] containsObject:[[CacheHandler instance] currentUser]])
        return 0;
    return -1;
}

- (IBAction)more:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayMoreDidComplete"
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:[self eventId]
                                                                                           forKey:@"sqeedId"]];
}

- (IBAction)facebook:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"fb://profile/netprod"]];
}

- (IBAction)phone:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel:+33676011922"]];
}

- (IBAction)twitter:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@%%20%%23SqeedTime", [[_eventTitle text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}
@end
