//
//  FriendTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UILabel* username;
@property (strong, nonatomic) IBOutlet UIImageView* picture;
@end
