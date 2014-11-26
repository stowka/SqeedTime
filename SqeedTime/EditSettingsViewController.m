//
//  EditSettingsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "EditSettingsViewController.h"
#import "CCacheHandler.h"

@interface EditSettingsViewController ()

@end

@implementation EditSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationBar] setTitle:[self key]];
    [[self textField] setText:[self value]];
    [[self textField] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![[self value] isEqualToString:[[self textField] text]])
        [[[CCacheHandler instance] cache_currentUser] update:[self key] :[[self textField] text]];
    [self performSegueWithIdentifier:@"segueEditSettingsSave" sender:self];
    return YES;
}

@end
