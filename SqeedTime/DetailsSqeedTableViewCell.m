//
//  DetailsSqeedTableViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 17/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "DetailsSqeedTableViewCell.h"

@implementation DetailsSqeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delete:(id)sender {
    NSLog(@"Delete");
}

- (IBAction)answer:(id)sender {
    NSLog(@"Answer");
}
@end
