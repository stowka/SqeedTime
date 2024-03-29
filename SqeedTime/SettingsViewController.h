//
//  SettingsViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)logout:(id)sender;

- (void)fetchUser;
- (void)reload;

@property (strong, nonatomic) IBOutlet UITableView* settingsTable;
@end
