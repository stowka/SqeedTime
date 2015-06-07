//
//  InviteTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 04/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong) NSString *userId;

@end
