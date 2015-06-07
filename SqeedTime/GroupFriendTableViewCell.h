//
//  GroupFriendTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 02/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupFriendTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet NSString* userId;

@end
