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
@end
