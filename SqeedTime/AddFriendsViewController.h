//
//  AddFriendsViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIImageView *publicPrivate;
@property (strong, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic) IBOutlet UITableView *friendTable;
- (IBAction)save:(id)sender;
- (IBAction)switchAccess:(id)sender;


@end
