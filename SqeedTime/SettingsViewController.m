//
//  SettingsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "EditSettingsViewController.h"
#import "DisplaySettingsViewController.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

NSDictionary* myData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLogin)
                                                 name:@"LogoutDidComplete"
                                               object:nil];
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
    return section ? 4 : 4;
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
                cell.title.text = @"Username"; // NON MUTABLE
                cell.value.text = [[[CacheHandler instance] currentUser] username];
                cell.value.font = [UIFont italicSystemFontOfSize:16.0f];
                cell.key = @"username";
                break;
            case 1:
                cell.title.text = @"Phone"; // NON MUTABLE
                cell.value.text = [[[CacheHandler instance] currentUser] phoneNumber];
                cell.value.font = [UIFont italicSystemFontOfSize:16.0f];
                cell.key = @"phone";
                break;
            case 2:
                cell.title.text = @"Name";
                cell.value.text = [[[CacheHandler instance] currentUser] name];
                cell.key = @"name";
                break;
            case 3:
                cell.title.text = @"E-mail";
                cell.value.text = [[[CacheHandler instance] currentUser] email];
                cell.key = @"email";
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
                cell.title.text = @"Geolocation";
                cell.value.text = @"❯";
                break;
            case 3:
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
    NSString* segue;
    if (!indexPath.section && (indexPath.row >= 2 && indexPath.row <= 4))       // MY ACCOUNT
        segue = @"segueEditSettings";
    else if (indexPath.section)                                                 // MORE INFO
        segue = @"segueDisplaySettings";
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    //[self performSegueWithIdentifier:segue sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.settingsTable indexPathForSelectedRow];
    EditSettingsViewController* destViewController = segue.destinationViewController;
    SettingsTableViewCell* cell = (SettingsTableViewCell*)[self.settingsTable cellForRowAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"segueEditSettings"]) {
        destViewController.key = cell.key;
        destViewController.value = cell.value.text;
    }
    
    if ([segue.identifier isEqualToString:@"segueDisplaySettings"]) {
         // TODO
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
