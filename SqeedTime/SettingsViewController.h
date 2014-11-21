//
//  SettingsViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsTableView.h"

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet NSNumber *userId;
@property (strong, nonatomic) IBOutlet SettingsTableView* settingsTable;

- (NSDictionary*)fetchUser:(int) userId;
- (void) alertStatus:(NSString *)msg :(NSString *)title;
@end
