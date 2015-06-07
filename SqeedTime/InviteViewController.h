//
//  InviteViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *accessImage;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UISwitch *switchButton;

- (void)fetchSqeeds;
- (void)updateAccess;
- (void)dismiss;
- (BOOL)isAlreadyInvited :(NSString *)friendId;

- (IBAction)save:(id)sender;
- (IBAction)switchAccess:(id)sender;

@end
