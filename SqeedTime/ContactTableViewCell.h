//
//  ContactTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 11/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

- (IBAction)sms:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
