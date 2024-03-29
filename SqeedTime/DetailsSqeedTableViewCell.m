//
//  DetailsSqeedTableViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 17/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "DetailsSqeedTableViewCell.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"
#import "AlertHelper.h"

@implementation DetailsSqeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

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

- (void)alertView :(UIAlertView *)alertView clickedButtonAtIndex :(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [DatabaseManager deleteSqeed:_eventId];
    } else if (buttonIndex == 1) {
        NSLog(@"NO");
    }
}

- (IBAction)join:(id)sender {
    [DatabaseManager participate:[self eventId]];
}

- (IBAction)decline:(id)sender {
    [DatabaseManager notParticipate:[self eventId]];
}

- (IBAction)deleteSqeed:(id)sender {
    [self confirm:@"Are you sure you want to delete this Sqeed?" :@"Delete Sqeed"];
}

- (IBAction)answer:(id)sender {
    if ([_eventAnswer selectedSegmentIndex] == 0) {
        [DatabaseManager participate:[self eventId]];
    } else if ([_eventAnswer selectedSegmentIndex] == 1) {
        [DatabaseManager notParticipate:[self eventId]];
    }
}

- (IBAction)showPeople:(id)sender {
    NSMutableString *people = [NSMutableString stringWithCapacity:2000];
    if ([_eventPeopleGoingWaiting selectedSegmentIndex] == 0) {
        for (User *user in [[[CacheHandler instance] tmpSqeed] going])
            [people appendFormat:@"%@\n", [user name]];
        [AlertHelper show:[NSString stringWithFormat:@"%@", people] :@"Going"];
    } else {
        for (User *user in [[[CacheHandler instance] tmpSqeed] waiting])
            [people appendFormat:@"%@\n", [user name]];
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

@end
