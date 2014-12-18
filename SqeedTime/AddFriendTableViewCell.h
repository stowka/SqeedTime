//
//  AddFriendTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UILabel* username;
@property (strong, nonatomic) IBOutlet NSString* userId;
@end
