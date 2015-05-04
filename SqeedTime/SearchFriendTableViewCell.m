//
//  SearchFriendTableViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 11/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "SearchFriendTableViewCell.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"

@implementation SearchFriendTableViewCell

@synthesize userId;
@synthesize isFriend;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
}

- (IBAction)add:(id)sender {
    if ([isFriend isEqualToString:@"NO"]) {
        [DatabaseManager addFriend:userId];
        [self setIsFriend:@"YES"];
        [[self button] setHighlighted:YES];
    } else {
        [DatabaseManager deleteFriend:userId];
        [self setIsFriend:@"NO"];
        [[self button] setHighlighted:NO];
    }
}
@end
