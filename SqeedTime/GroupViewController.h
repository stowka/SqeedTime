//
//  GroupViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 02/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *groupName;
@property (strong, nonatomic) IBOutlet UITableView *table;

- (IBAction)delete:(id)sender;
- (BOOL) isInGroup :(NSString *)friendId;
- (IBAction) save:(id)sender;
- (void) getGroups;
- (void) dismiss;

@end
