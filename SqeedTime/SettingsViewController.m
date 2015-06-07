//
//  SettingsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "DisplaySettingsViewController.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize settingsTable;

NSDictionary* myData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLogin)
                                                 name:@"LogoutDidComplete"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchUser)
                                                 name:@"UpdateUserDidComplete"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:@"FetchUserDidComplete"
                                               object:nil];
}

- (void)fetchUser {
    [DatabaseManager fetchUser];
}

- (void)reload {
    [settingsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section ? @"More informations" : @"My account";
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return section ? 3 : 3;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *name = [[alertView textFieldAtIndex:0] text];
        NSLog(@"%@ %@ %@ %@ %@", [[[CacheHandler instance] currentUser] email],
              name,
              [[[CacheHandler instance] currentUser] phoneExt],
              [[[CacheHandler instance] currentUser] phone],
              [[[CacheHandler instance] currentUser] facebookUrl]);
        
        [DatabaseManager updateUser:[[[CacheHandler instance] currentUser] email]
                                   :name
                                   :@"33"
                                   :[[[CacheHandler instance] currentUser] phone]
                                   :@""];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    static NSString *cellIdentifier = @"settingsCellID";
    SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
    if (cell == nil) {
        cell = [[SettingsTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (!indexPath.section) {
        switch(indexPath.row) {
            case 0:
                cell.title.text = @"Phone"; // NON MUTABLE
                cell.value.text = [[[CacheHandler instance] currentUser] phoneNumber];
                cell.value.font = [UIFont italicSystemFontOfSize:16.0f];
                cell.key = @"phone";
                break;
            case 1:
                cell.title.text = @"E-mail";
                cell.value.text = [[[CacheHandler instance] currentUser] email];
                cell.value.font = [UIFont italicSystemFontOfSize:16.0f];
                cell.key = @"email";
                break;
            case 2:
                cell.title.text = @"Name";
                cell.value.text = [[[CacheHandler instance] currentUser] name];
                cell.key = @"name";
                break;
            default:
                cell.title.text = @"ERROR";
                cell.value.text = @"";
                break;
        }
    }
    else {
        switch(indexPath.row) {
            case 0:
                cell.title.text = @"Privacy Policy";
                cell.value.text = @"❯";
                break;
            case 1:
                cell.title.text = @"Terms of use";
                cell.value.text = @"❯";
                break;
            case 2:
                cell.title.text = @"About us";
                cell.value.text = @"❯";
                break;
            default:
                cell.title.text = @"ERROR";
                cell.value.text = @"";
                break;
        }
    }

    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    //NSString* segue;
    if (!indexPath.section && indexPath.row == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit your name"
                                                        message:@"The name that will be displayed to your friends"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Save", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.placeholder = @"Name";
        tf.text = [[[CacheHandler instance] currentUser] name];
        [alert show];
    } else if (indexPath.section) {
        //segue = @"segueDisplaySettings";
        //[self performSegueWithIdentifier:segue sender:self];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.settingsTable indexPathForSelectedRow];
    
    switch (indexPath.row) {
        case 0:
            NSLog(@"");
            break;
            
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)logout:(id)sender {
    // Destroy local data
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *session = @"off";
    NSString *userId = @"";
    NSString *token = @"";
    [prefs setObject:session forKey:@"session"];
    [prefs setObject:userId forKey:@"userId"];
    [prefs setObject:token forKey:@"token"];
    [DatabaseManager logout];
}

- (void)showLogin {
    [self performSegueWithIdentifier:@"segueLogout" sender:self];
}
@end
