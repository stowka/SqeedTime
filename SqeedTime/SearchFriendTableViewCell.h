//
//  SearchFriendTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 11/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriendTableViewCell : UITableViewCell
- (IBAction)add:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIButton *button;


@end
