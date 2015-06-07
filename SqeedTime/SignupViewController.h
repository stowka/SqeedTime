//
//  SignupViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 28/05/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *phoneExt;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gender;
@property (strong, nonatomic) IBOutlet UITextField *birthYear;

- (IBAction)signup:(id)sender;
- (void) fetchUser;
- (void) fetchStuff;
- (void) showSqeeds;
- (void) errorSignup :(NSNotification *)notif;

@end
