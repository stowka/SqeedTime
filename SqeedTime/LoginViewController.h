//
//  ViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField* username;
@property (weak, nonatomic) IBOutlet UITextField* password;
@property (weak, nonatomic) IBOutlet UISwitch* remember;
@property (strong, nonatomic) IBOutlet NSNumber* userId;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)login:(id)sender;
- (IBAction)backgroundClick:(id)sender;
@end

