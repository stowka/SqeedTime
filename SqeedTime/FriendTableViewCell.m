//
//  FriendTableViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"

@interface FriendTableViewCell()

@end

@implementation FriendTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)add:(id)sender {
    if ([_isFriend isEqualToString:@"NO"]) {
        [DatabaseManager addFriend:[self userId]];
        [self setIsFriend:@"YES"];
        [[self buttonAdd] setHighlighted:YES];
    } else {
        [DatabaseManager deleteFriend:[self userId]];
        [self setIsFriend:@"NO"];
        [[self buttonAdd] setHighlighted:NO];
    }
}
@end
