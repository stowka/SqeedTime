//
//  ViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "LoginViewController.h"
#import "DatabaseManager.h"
#import "AlertHelper.h"
#import "CacheHandler.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize control;
@synthesize sqeedtime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Manage session
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([[prefs stringForKey:@"remember"] isEqualToString:@"YES"]) {
        [_username setText:[prefs stringForKey:@"username"]];
        [_password setText:[prefs stringForKey:@"password"]];
        [_remember setOn:YES];
        if ([[prefs stringForKey:@"session"] isEqualToString:@"on"]) {
            [[self login] setTitle:@"" forState:UIControlStateNormal];
            [[self gear] setHidden:NO];
            [[self gear] startAnimating];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(showActivities)
                                                         name:@"FetchUserDidComplete"
                                                       object:nil];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(displayFetchError)
                                                         name:@"FetchUserDidFail"
                                                       object:nil];
            
            [[CacheHandler instance] setToken:[prefs stringForKey:@"token"]];
            NSLog(@"Token: %@", [[CacheHandler instance] token]);
            [[CacheHandler instance] setCurrentUserId:[[[CacheHandler instance] token] componentsSeparatedByString:@":"][0]];
            [[[CacheHandler instance] currentUser] setUserId:[[CacheHandler instance] currentUserId]];
            [self fetchUser];
        }
    } else {
        [_username setText:@""];
        [_password setText:@""];
        [_remember setOn:NO];
    }
    
    [[self gear] setHidden:YES];
    
    // Observers for Login
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUser)
                                                 name:@"LoginDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayLoginError)
                                                 name:@"LoginDidFail"
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    [[self gear] setHidden:NO];
    [[self gear] startAnimating];
    [[self login] setTitle:@"" forState:UIControlStateNormal];
    
    // Observers for FetchUser
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActivities)
                                                 name:@"FetchUserDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayFetchError)
                                                 name:@"FetchUserDidFail"
                                               object:nil];
    
    [DatabaseManager login :[_username text] :[_password text]];
}

- (IBAction)switchRemember:(id)sender {
}

- (IBAction)signin:(id)sender {
    // TODO Change URL
//    NSURL *urlSignIn = [NSURL URLWithString:@"http://sqtdbws.net-production.ch"];
//    [[UIApplication sharedApplication] openURL:urlSignIn];
}

- (void)fetchUser {
    [DatabaseManager fetchUser];
}

- (IBAction)dismiss:(id)sender {
    [[self password] resignFirstResponder];
    [[self username] resignFirstResponder];
}

- (void)showActivities {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *remember = [_remember isOn] ? @"YES" : @"NO";
    NSString *username;
    NSString *password;
    
    [prefs setObject:remember forKey:@"remember"];
    
    
    if ([_remember isOn]) {
        username = [_username text];
        password = [_password text];
    } else {
        username = @"";
        password = @"";
    }
    
    [prefs setObject:username forKey:@"username"];
    [prefs setObject:password forKey:@"password"];
    
    [[[CacheHandler instance] currentUser] fetchFriends];
    
    // No further use for Login observers
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchUserDidComplete"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchUserDidFail"
                                                  object:nil];
    
    // Stop animating activity indicator
    [[self gear] stopAnimating];
    [[self gear] setHidden:YES];
    
    NSLog(@"Push notifications token: %@", [[CacheHandler instance] pn_token]);
    
    // Display ActivitiesViewController
    [self performSegueWithIdentifier:@"segueActivities" sender:self];
    
    // Reset the Log in button
    [[self login] setTitle:@"Log in" forState:UIControlStateNormal];
}

- (void)displayLoginError {
    [[self gear] stopAnimating];
    [[self gear] setHidden:YES];
    [[self login] setTitle:@"Log in" forState:UIControlStateNormal];
    
    [AlertHelper error :@"Failed to log in: wrong username or password!"];
}

- (void)displayFetchError {
    [[self gear] stopAnimating];
    [[self gear] setHidden:YES];
    [[self login] setTitle:@"Log in" forState:UIControlStateNormal];
    
    [AlertHelper error :@"Failed to connect to the server, please try again in a moment."];
}

- (IBAction)backgroundClick:(id)sender {
    [[self username] resignFirstResponder];
    [[self password] resignFirstResponder];
}

- (IBAction)startEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1]; // 0.37
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    control.frame = CGRectMake(control.frame.origin.x, (control.frame.origin.y - 80.0), control.frame.size.width, control.frame.size.height);
    
    [UIView commitAnimations];
}

- (IBAction)endEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    control.frame = CGRectMake(control.frame.origin.x, (control.frame.origin.y + 80.0), control.frame.size.width, control.frame.size.height);
    
    [UIView commitAnimations];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
