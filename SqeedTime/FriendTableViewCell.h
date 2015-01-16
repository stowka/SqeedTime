//
//  FriendTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell

- (IBAction)add:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdd;
@property (strong, nonatomic) IBOutlet UILabel* name;
@property (strong, nonatomic) IBOutlet UILabel* username;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *isFriend;
@end
