//
//  ViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "LoginViewController.h"
#import "ActivitiesViewController.h"
#import "CRequestHandler.h"
#import "CCacheHandler.h"
#import "MUser.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender
{
    if([[_username text] isEqualToString:@""]
    || [[_password text] isEqualToString:@""])
        [CRequestHandler alertStatus:@"Please enter both username and password" :@"Login failed!"];
    else
    {
        NSString* request = [NSString stringWithFormat:@"function=loginRequestV1&username=%@", [_username text]];
        NSDictionary* data = [CRequestHandler post:request];
        NSInteger userId = [[data valueForKey:@"id"] integerValue];
        if (userId)
        {
            request = [NSString stringWithFormat:@"function=login&username=%@&password=%@", [_username text], [_password text]];
            NSDictionary* data = [CRequestHandler post:request];
            NSInteger code = [[data valueForKey:@"code"] integerValue];
            NSString* message = [data valueForKey:@"message"];
            NSLog(@"%@", message);
            if (200 == code)
            {
                [[CCacheHandler instance] setCache_token:[NSString stringWithFormat:@"%@", [data valueForKey:@"token"]]];
                [[CCacheHandler instance] setCache_currentUser:[[MUser alloc] initWithId:userId]];
                [self performSegueWithIdentifier: @"segueActivities" sender: self];
            }
        }
    }
}

- (IBAction)backgroundClick:(id)sender
{
    [_password resignFirstResponder];
    [_username resignFirstResponder];
}
@end
