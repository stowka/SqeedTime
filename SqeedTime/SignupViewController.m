//
//  SignupViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 28/05/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "SignupViewController.h"
#import "DatabaseManager.h"
#import "AlertHelper.h"
#import "CacheHandler.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUser)
                                                 name:@"SignupDidComplete"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchStuff)
                                                 name:@"FetchUserDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSqeeds)
                                                 name:@"FetchFriendsDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(errorSignup:)
                                                 name:@"SignupDidFail"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signup:(id)sender {
    NSString *email = self.email.text;
    NSString *password = self.password.text;
    NSString *phoneExt = self.phoneExt.text;
    NSString *phone = self.phone.text;
    NSString *gender = [NSString stringWithFormat:@"%ld", (long)self.gender.selectedSegmentIndex];
    NSString *birthYear = self.birthYear.text;
    
    if (![email isEqualToString:@""]
        && ![password isEqualToString:@""]
        && ![phoneExt isEqualToString:@""]
        && ![phone isEqualToString:@""]
        && ![birthYear isEqualToString:@""]) {
        [DatabaseManager signup:email :password :phone :phoneExt :gender :birthYear];
    } else {
        [AlertHelper error:@"Please fulfill all the fields!"];
    }
}

- (void)fetchUser {
    [DatabaseManager fetchUser];
}

- (void)fetchStuff {
    [[[CacheHandler instance] currentUser] fetchGroups];
    [[[CacheHandler instance] currentUser] fetchFriends];
}
    
- (void)showSqeeds {
    [self performSegueWithIdentifier:@"segueSignup" sender:self];
}

- (void) errorSignup:(NSNotification *)notif {
    [AlertHelper error:[[notif userInfo] objectForKey:@"message"]];
}
@end
