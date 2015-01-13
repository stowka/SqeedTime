//
//  ViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "LoginViewController.h"
#import "AlertHelper.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self activityIndicator] setHidden:true];
    
    // Observers for LoginRequest
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(login)
                                                 name:@"LoginRequestDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayError)
                                                 name:@"LoginRequestDidFail"
                                               object:nil];
    
    // Observers for Login
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUser)
                                                 name:@"LoginDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayError)
                                                 name:@"LoginDidFail"
                                               object:nil];
    
    // Observers for FetchUser
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActivities)
                                                 name:@"FetchUserDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUser) // Be careful with that!
                                                 name:@"FetchUserDidFail"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)loginRequest:(id)sender {
    if([[_username text] isEqualToString :@""]
       || [[_password text] isEqualToString :@""]) {
        [AlertHelper error:@"Please enter both username and password"];
    } else {
        
        // Start animating activity indicator
        [[self activityIndicator] setHidden :NO];
        [[self activityIndicator] startAnimating];
        
        // Send loginRequest to server (will store id, username and password into cache)
        [DatabaseManager loginRequest :[_username text] :[_password text]];
    }
}

- (void)login {
    
    // Observers for FetchUser
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActivities)
                                                 name:@"FetchUserDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUser) // Be careful with that!
                                                 name:@"FetchUserDidFail"
                                               object:nil];
    
    [DatabaseManager login :[_username text] :[_password text]];
}

- (IBAction)signin:(id)sender {
    // TODO Change URL
    NSURL *urlSignIn = [NSURL URLWithString:@"http://sqtdbws.net-production.ch"];
    [[UIApplication sharedApplication] openURL:urlSignIn];
}

- (IBAction)backgroundClick :(id)sender {
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}

- (void)fetchUser {
    [DatabaseManager fetchUser:[[CacheHandler instance] tmpUser]];
}

- (void)showActivities {
    // No further use for LoginRequest observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchUserDidComplete"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchUserDidFail"
                                                  object:nil];
    // Stop animating activity indicator
    [[self activityIndicator] stopAnimating];
    [[self activityIndicator] setHidden:YES];
    
    // Display ActivitiesViewController
    [self performSegueWithIdentifier:@"segueActivities" sender:self];
}

- (void)displayError {
    [[self activityIndicator] stopAnimating];
    [[self activityIndicator] setHidden:YES];
    [AlertHelper error :@"Failed to log in: wrong username or password!"];
}
@end
