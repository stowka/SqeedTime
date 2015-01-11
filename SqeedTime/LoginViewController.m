//
//  ViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "LoginViewController.h"
#import "ActivitiesViewController.h"
#import "CacheHandler.h"
#import "AlertHelper.h"
#import "User.h"
#import "AFNetworking.h"
#import "DatabaseManager.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self activityIndicator] setHidden:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    if([[_username text] isEqualToString:@""]
    || [[_password text] isEqualToString:@""])
        [AlertHelper error:@"Please enter both username and password"];
    else
        [[self activityIndicator] setHidden:false];
        [[self activityIndicator] startAnimating];
        [DatabaseManager loginRequest:[_username text] :[_password text]];
}

- (IBAction)signin:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://sqtdbws.net-production.ch"]];
}

- (IBAction)backgroundClick:(id)sender {
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
