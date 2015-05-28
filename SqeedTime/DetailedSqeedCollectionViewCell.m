//
//  DetailedSqeedCollectionViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 14/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "DetailedSqeedCollectionViewCell.h"
#import "MultiSelectSegmentedControl.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"
#import "AlertHelper.h"
#import "User.h"

@implementation DetailedSqeedCollectionViewCell

@synthesize phoneExt;
@synthesize phone;

@synthesize sqeed;

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
    [DatabaseManager vote:[sqeed sqeedId] :[[sqeed dateOptions][[[self eventDateDoodle] selectedSegmentIndex]] voteId]];
}

- (void)alertView :(UIAlertView *)alertView clickedButtonAtIndex :(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([_eventAnswer selectedSegmentIndex] == 1) {
            [DatabaseManager notParticipate:[self eventId]];
        } else {
            [DatabaseManager deleteSqeed:_eventId];
        }
    } else if (buttonIndex == 1) {
        if ([_eventAnswer selectedSegmentIndex] == 1) {
            [[self eventAnswer] setSelectedSegmentIndex:-1];
        }
        NSLog(@"NO");
    }
}

- (IBAction)join:(id)sender {
    [DatabaseManager participate:[self eventId]];
}

- (IBAction)decline:(id)sender {
    [self confirm:@"Are you sure you want to decline this Sqeed?" :@"Decline Sqeed"];
}

- (IBAction)deleteSqeed:(id)sender {
    [self confirm:@"Are you sure you want to delete this Sqeed?" :@"Delete Sqeed"];
}

- (IBAction)answer:(id)sender {
    if ([_eventAnswer selectedSegmentIndex] == 0) {
        [DatabaseManager participate:[self eventId]];
    } else if ([_eventAnswer selectedSegmentIndex] == 1) {
        [self confirm:@"Are you sure you want to decline this Sqeed?" :@"Decline Sqeed"];
    }
}

- (int) hasAnswered {
    for(User *u in [sqeed waiting])
        if ([[u userId] isEqualToString:[[CacheHandler instance] currentUserId]])
            return -1;
    
    for(User *u in [sqeed going])
        if ([[u userId] isEqualToString:[[CacheHandler instance] currentUserId]])
            return 0;
    
//    if ([[sqeed waiting] containsObject:[[CacheHandler instance] currentUser]])
//        return -1;
//    else if ([[sqeed going] containsObject:[[CacheHandler instance] currentUser]])
//        return 0;
    return 1;
}

- (NSArray *)votes {
    NSMutableArray *votes = [[NSMutableArray alloc] init];
    for (VoteOption *vo in [sqeed dateOptions]) {
        for (VoteOption *option in [sqeed voteIds]) {
            if ([vo.voteId isEqualToString:option.voteId]) {
                [votes addObject:[vo voteId]];
            }
        }
    }
    return votes;
}

- (IBAction)more:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayMoreDidComplete"
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObject:[self eventId]
                                                                                           forKey:@"sqeedId"]];
}

- (IBAction)displayGoingWaiting:(id)sender {
    NSMutableString *list = [[NSMutableString alloc] initWithString:@""];
    int n = 0;
    if ([_eventGoingWaiting selectedSegmentIndex] == 0) { // GOING
        for (User *u in [sqeed going]) {
            if (0 == n)
                [list setString:[NSString stringWithFormat:@"%@", [u name]]];
            else
                [list setString:[NSString stringWithFormat:@"%@\n%@", list, [u name]]];
            n += 1;
        }
    } else { // WAITING
        for (User *u in [sqeed waiting]) {
            if (0 == n)
                [list setString:[NSString stringWithFormat:@"%@", [u name]]];
            else
                [list setString:[NSString stringWithFormat:@"%@\n%@", list, [u name]]];
            n += 1;
        }
    }
    [_peopleList setText:list];
}

- (IBAction)facebook:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"fb://"]];
}

- (IBAction)phone:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+%@%@", phoneExt, phone]]];
}

- (IBAction)twitter:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://post?message=%@%%20%%23SqeedTime", [[_eventTitle text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}
@end
