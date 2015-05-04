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
@property (strong, nonatomic) IBOutlet NSNumber* userId;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *gear;
@property (strong, nonatomic) IBOutlet UIButton *login;
@property (strong, nonatomic) IBOutlet UIButton *signin;
@property (strong, nonatomic) IBOutlet UISwitch *remember;
@property (strong, nonatomic) IBOutlet UIControl *control;
@property (strong, nonatomic) IBOutlet UILabel *sqeedtime;

- (IBAction)signin:(id)sender;
- (IBAction)startEditing:(id)sender;
- (IBAction)endEditing:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)login:(id)sender;
@end

