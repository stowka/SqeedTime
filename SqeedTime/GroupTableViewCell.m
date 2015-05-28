//
//  GroupTableViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 28/05/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "GroupTableViewCell.h"

@implementation GroupTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    // Segue modal to group
}

@end
