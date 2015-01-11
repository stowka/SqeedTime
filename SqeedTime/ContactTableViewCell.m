//
//  ContactTableViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 11/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sms:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms:+33676011922"]];
}
@end
