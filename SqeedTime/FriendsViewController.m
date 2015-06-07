//
//  FriendsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "FriendsViewController.h"
#import "GroupTableViewCell.h"
#import "FriendTableViewCell.h"
#import "ContactTableViewCell.h"
#import "FriendGroup.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"
#import "Contact.h"
#import <MessageUI/MessageUI.h>

@import AddressBook;

@interface FriendsViewController ()

@end

NSArray *groups;
NSArray *friends;
NSArray *requests;
NSArray *pending;
NSArray *phoneMatches;

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    groups = [[[CacheHandler instance] currentUser] groups];
    friends = [[[CacheHandler instance] currentUser] friends];
    requests = [[[CacheHandler instance] currentUser] requests];
    pending = [[[CacheHandler instance] currentUser] pending];
    phoneMatches = [[CacheHandler instance] phoneMatches];
    
    [[self friendTable] setScrollsToTop:YES];
    [[self friendTable] setAllowsMultipleSelectionDuringEditing:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetch)
                                                 name:@"AddFriendDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"SearchByPhonesDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetch)
                                                 name:@"DeleteFriendDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"FetchFriendDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getGroups:)
                                                 name:@"AddGroupDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"GetGroupsDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"DelGroupDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"ReloadFriends"
                                               object:nil];
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"Access to address book denied.");
            return;
        }
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
        CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                                   CFArrayGetCount(people),
                                                                   people);
        
        
        CFArraySortValues(peopleMutable,
                          CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                          (CFComparatorFunction) ABPersonComparePeopleByName,
                          (void *)ABPersonGetSortOrdering());
        
        NSArray *abArray = (__bridge_transfer NSArray *)peopleMutable;
        
        NSMutableArray *contacts = [[NSMutableArray alloc] init];
        Contact *contact;
        NSString *lastName;
        NSString *firstName;
        NSString *phone;
        ABRecordRef person;
        ABMultiValueRef phones;
        
        for (int i = 0; i < CFArrayGetCount(peopleMutable); i += 1) {
            contact = [[Contact alloc] init];
            
            person = (__bridge ABRecordRef)([abArray objectAtIndex:i]);
            phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty));
            
            phone = @"";
            
            for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
                phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, j);
            
            lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            if (lastName == nil)
                lastName = @"";
            firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            if (firstName == nil)
                firstName = @"";
            [contact setName:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
            [contact setPhone:phone];
            if (![phone isEqualToString:@""])
                [contacts addObject:contact];
        }
        [[CacheHandler instance] setContacts:contacts];
        
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        for (Contact *contact in [[CacheHandler instance] contacts]) {
            [phoneArray addObject:contact.phone];
        }
        
        [DatabaseManager searchByPhones:phoneArray];
        
        [[self friendTable] reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Groups";
    } else if (section == 1) {
        return @"Friends";
    } else if (section == 2) {
        return @"Friend requests";
    } else if (section == 3) {
        return @"Pending";
    } else if (section == 4) {
        return @"Contacts using SqeedTime";
    } else if (section == 5) {
        return @"Address book";
    }
    else return @"";
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [groups count] + 1;
    } else if (section == 1) {
        return [friends count];
    } else if (section == 2) {
        return [requests count];
    } else if (section == 3) {
        return [pending count];
    } else if (section == 4) {
        return [phoneMatches count];
    } else if (section == 5) {
        return [[[CacheHandler instance] contacts] count];
    }
    else return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete");
        [DatabaseManager delGroup:[(GroupTableViewCell *)[[self friendTable] cellForRowAtIndexPath:indexPath] groupId]
                                 :[[NSArray alloc] init]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellGroupID";
        GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
        if (cell == nil) {
            cell = [[GroupTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) { // NEW GROUP BUTTON
            [[cell title] setText:@"New group..."];
            [cell setGroupId:@"0"];
        } else {
            FriendGroup *group = (FriendGroup *)groups[[indexPath row] - 1];
            
            [[cell title] setText:[NSString stringWithFormat:@"%@ (%d)", [group title], [[group friends] count]]];
            [cell setGroupId:[group groupId]];
        }
        
        return cell;
    } else if (1 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellFriendID";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    
        [[cell name] setText:[NSString stringWithFormat:@"%@", [friends[[indexPath row]] name]]];
        
        [cell setUserId:[friends [[indexPath row]] userId]];
        
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateHighlighted];
        [[cell buttonAdd] setHighlighted:YES];
        [[cell buttonAdd] setHidden:YES];
        
        [cell setIsFriend:@"YES"];
        
        return cell;
    } else if (2 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellFriendID";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [[cell name] setText:[NSString stringWithFormat:@"%@", [requests[[indexPath row]] name]]];
        
        [cell setUserId:[requests [[indexPath row]] userId]];
        
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateHighlighted];
        [[cell buttonAdd] setHighlighted:NO];
        [[cell buttonAdd] setHidden:YES];
        
        [cell setIsFriend:@"NO"];
        
        return cell;
    } else if (3 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellFriendID";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [[cell name] setText:[NSString stringWithFormat:@"%@", [pending[[indexPath row]] name]]];
        
        [cell setUserId:[pending [[indexPath row]] userId]];
        
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateHighlighted];
        [[cell buttonAdd] setHighlighted:YES];
        [[cell buttonAdd] setHidden:YES];
        
        [cell setIsFriend:@"YES"];
        
        return cell;
    } else if (4 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellFriendID";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [[cell name] setText:[NSString stringWithFormat:@"%@", [phoneMatches[[indexPath row]] name]]];
        
        [cell setUserId:[phoneMatches [[indexPath row]] userId]];
        
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [[cell buttonAdd] setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateHighlighted];
        [[cell buttonAdd] setHighlighted:NO];
        [[cell buttonAdd] setHidden:YES];
        
        [cell setIsFriend:@"NO"];
        
        return cell;
    } else if (5 == [indexPath section]) {
        static NSString *cellIdentifier = @"cellContactID";
        ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                      cellIdentifier];
        if (cell == nil) {
            cell = [[ContactTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [[cell name] setText:[[[CacheHandler instance] contacts][indexPath.row] name]];
        [[cell phoneNumber] setText:[[[CacheHandler instance] contacts][indexPath.row] phone]];
        
        return cell;
    } else {
        return nil;
    }
}

- (void)refresh {
    groups = [[[CacheHandler instance] currentUser] groups];
    friends = [[[CacheHandler instance] currentUser] friends];
    requests = [[[CacheHandler instance] currentUser] requests];
    pending = [[[CacheHandler instance] currentUser] pending];
    [[self friendTable] reloadData];
}

- (void)fetch {
    [[[CacheHandler instance] currentUser] fetchFriends];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [DatabaseManager addGroup:[[alertView textFieldAtIndex:0] text] :[[NSArray alloc] init]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            [[CacheHandler instance] setCurrentGroup:[[FriendGroup alloc] init]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New group"
                                                            message:@"Enter a name for the group"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Add", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        } else {
            [[CacheHandler instance] setCurrentGroup:groups[indexPath.row - 1]];
            [self performSegueWithIdentifier:@"segueGroup" sender:self];
        }
    }
    if (indexPath.section != 0 && [indexPath section] <= 4) {
        [[((FriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]) buttonAdd] setHidden:NO];
    } else if ([indexPath section] == 5) {
        [self showSMS:indexPath];
    } else
        [_friendTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_friendTable deselectRowAtIndexPath:[_friendTable indexPathForSelectedRow] animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[((FriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]) buttonAdd] setHidden:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[((FriendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]) buttonAdd] setHidden:YES];
    return indexPath;
}

- (void)showSMS:(NSIndexPath *) indexPath {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    NSString *phone = [[(ContactTableViewCell *)[_friendTable cellForRowAtIndexPath:indexPath] phoneNumber] text];
    NSArray *recipents = @[phone];
    NSString *message = @"Hi mate, Sqeedtime's fantastic! Check it out: www.sqeedtime.ch";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)remove:(id)sender {
    NSLog(@"Remove friend!");
}

- (void) getGroups:(NSNotification *)notif {
    [DatabaseManager getGroups];
}

//- (void) showGroup:(NSNotification *)notif {
//    [[CacheHandler instance] setCurrentGroup:[notif userInfo][@"groupId"]];
//    [self performSegueWithIdentifier:@"segueGroup" sender:self];
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end

