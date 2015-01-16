//
//  FriendsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"
#import "ContactTableViewCell.h"
#import "CacheHandler.h"

@import AddressBook;

@interface FriendsViewController ()

@end

NSArray* friends;
NSArray* friendRequests;

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [[[CacheHandler instance] currentUser] friends];
    friendRequests = [[[CacheHandler instance] currentUser] friendRequests];
    
    [[self friendTable] setScrollsToTop:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetch)
                                                 name:@"AddFriendDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetch)
                                                 name:@"DeleteFriendDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"FetchUserDidComplete"
                                               object:nil];
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"Access to address book denied.");
            return;
        }
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
        [[CacheHandler instance] setContacts:(__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef)];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Friends";
    } else if (section == 1) {
        return @"Friend requests";
    } else if (section == 2) {
        return @"Contacts";
    }
    else return @"";
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [friends count];
    } else if (section == 1) {
        return [friendRequests count];
    } else if (section == 2) {
        return [[[CacheHandler instance] contacts] count];
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d %d", [indexPath section], [indexPath row]);
    if (0 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellFriendID";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    
        [[cell name] setText:[NSString stringWithFormat:@"%@ %@", [friends[[indexPath row]] forname], [friends[[indexPath row]] name]]];
        [[cell username] setText:[NSString stringWithFormat:@"%@", [friends[[indexPath row]] username]]];
        
        [cell setUserId:[friends [[indexPath row]] userId]];
        
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateHighlighted];
        [[cell buttonAdd] setHighlighted:YES];
        
        [cell setIsFriend:@"YES"];
        
        return cell;
    } else if (1 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellFriendID";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [[cell name] setText:[NSString stringWithFormat:@"%@ %@", [friendRequests[[indexPath row]] forname], [friendRequests[[indexPath row]] name]]];
        [[cell username] setText:[NSString stringWithFormat:@"%@", [friendRequests[[indexPath row]] username]]];
        
        [cell setUserId:[friendRequests [[indexPath row]] userId]];
    
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateHighlighted];
        [[cell buttonAdd] setHighlighted:NO];
        
        [cell setIsFriend:@"NO"];
        
        return cell;
    } else if (2 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellContactID";
        ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
        if (cell == nil) {
            cell = [[ContactTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([[[CacheHandler instance] contacts] objectAtIndex:[indexPath row]]), kABPersonLastNameProperty);
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([[[CacheHandler instance] contacts] objectAtIndex:[indexPath row]]), kABPersonFirstNameProperty);
        //NSString *phone = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)([[[CacheHandler instance] contacts] objectAtIndex:[indexPath row]]), kABPersonPhoneProperty);
        [[cell name] setText:[NSString stringWithFormat:@"%@ %@", lastName, firstName]];
        return cell;
    } else {
        return nil;
    }
}

- (void)refresh {
    friends = [[[CacheHandler instance] currentUser] friends];
    friendRequests = [[[CacheHandler instance] currentUser] friendRequests];
    [[self friendTable] reloadData];
}

- (void)fetch {
    [[[CacheHandler instance] currentUser] fetchFriends];
    [[[CacheHandler instance] currentUser] fetchFriendRequests];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    [_friendTable deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)remove:(id)sender {
    NSLog(@"Remove friend: %@",@"");
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end

