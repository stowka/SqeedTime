//
//  AddFriendsToSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"
#import "AddFriendTableViewCell.h"
#import "AlertHelper.h"

@interface AddFriendsViewController ()

@end

NSArray* friends;
NSArray* groups;

@implementation AddFriendsViewController
@synthesize navigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [[[CacheHandler instance] currentUser] friends];
    groups = [[[CacheHandler instance] currentUser] groups];
    [[self friendTable] setScrollsToTop:YES];
    [_switchButton setOn:NO animated:NO];
    [[self loadingView] setHidden:YES];
    
    [[navigationBar topItem] setTitle:@"Propose to"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNextOption:)
                                                 name:@"CreateSqeedDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNextOption:)
                                                 name:@"AddDatetimeOptionDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSqeeds:)
                                                 name:@"InviteDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSqeed:)
                                                 name:@"FetchSqeedsDidComplete"
                                               object:nil];
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideLoader)
                                                 name:@"CreateSqeedDidFail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideLoader)
                                                 name:@"AddDatetimeOptionDidFail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideLoader)
                                                 name:@"InviteDidFail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideLoader)
                                                 name:@"FetchSqeedsDidFail"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"Groups";
    } else {
        return @"Friends";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return [groups count];
    } else {
        return [friends count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        static NSString *cellIdentifier = @"cellInviteFriendID";
        AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        cellIdentifier];
        if (cell == nil) {
            cell = [[AddFriendTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.name.text = [NSString stringWithFormat:@"%@ (%d)", [groups[indexPath.row] title], [[groups[indexPath.row] friends] count]];
        cell.username.text = [NSString stringWithFormat:@""];
        cell.userId = [groups[indexPath.row] groupId];

        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(67/255.0) green:(157/255.0) blue:(187/255.0) alpha:0.7];
        
        cell.selectedBackgroundView = selectionColor;
        return cell;
    } else {
        static NSString *cellIdentifier = @"cellInviteFriendID";
        AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     cellIdentifier];
        if (cell == nil) {
            cell = [[AddFriendTableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (0 == indexPath.row) {
            cell.name.text = @"Invite all";
            cell.username.text = @"";
        } else {
            cell.name.text = [NSString stringWithFormat:@"%@", [friends[indexPath.row - 1] name]];
            cell.username.text = [NSString stringWithFormat:@""];
            cell.userId = [friends[indexPath.row - 1] userId];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(67/255.0) green:(157/255.0) blue:(187/255.0) alpha:0.7];
        cell.selectedBackgroundView = selectionColor;
        return cell;
    }
}
- (IBAction)save:(id)sender {
    [[self loadingView] setHidden:NO];
    [[self activityIndicator] startAnimating];
    if (![[[[CacheHandler instance] createSqeed] title] isEqualToString:@""]) {
        NSLog(@"Saving...");

        if (nil == [[[CacheHandler instance] createSqeed] sqeedDescription])
            [[[CacheHandler instance] createSqeed] setSqeedDescription: @""];
    
        if (nil == [[[CacheHandler instance] createSqeed] place])
            [[[CacheHandler instance] createSqeed] setPlace: @""];
        
        if (nil == [[[CacheHandler instance] createSqeed] peopleMax])
            [[[CacheHandler instance] createSqeed] setPeopleMax: @"10"];
        
        if (nil == [[[CacheHandler instance] createSqeed] dateStart])
            [[[CacheHandler instance] createSqeed] setDateStart: [NSDate date]];
        
        if (nil == [[[CacheHandler instance] createSqeed] dateEnd])
            [[[CacheHandler instance] createSqeed] setDateEnd:[NSDate dateWithTimeInterval:1800
                                                                                 sinceDate:[[[CacheHandler instance] createSqeed] dateStart]]];
        
        NSArray *selectedIndexPaths = [_friendTable indexPathsForSelectedRows];
        NSMutableArray *friendIds = [[NSMutableArray alloc] init];
        NSMutableArray *groupIds = [[NSMutableArray alloc] init];
        NSMutableArray *dateOptions = [[NSMutableArray alloc] init];
        
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            if (0 == indexPath.section) {
                AddFriendTableViewCell *tmp_cell = (AddFriendTableViewCell *)[_friendTable cellForRowAtIndexPath:indexPath];
                [groupIds addObject:[tmp_cell userId]];
            } else {
                if (0 != indexPath.row) {
                    AddFriendTableViewCell *tmp_cell = (AddFriendTableViewCell *)[_friendTable cellForRowAtIndexPath:indexPath];
                    [friendIds addObject:[tmp_cell userId]];
                }
            }
        }
        
        BOOL isAlreadyInvited = NO;
        
        for (FriendGroup *g in groups) {
            for (NSString *groupId in groupIds) {
                if ([[g groupId] isEqualToString:groupId]) {
                    for (User *u in [g friends]) {
                        for (NSString *friendId in friendIds) {
                            if ([[u userId] isEqualToString:friendId]) {
                                isAlreadyInvited = YES;
                            }
                        }
                        if (!isAlreadyInvited)
                            [friendIds addObject:[u userId]];
                        isAlreadyInvited = NO;
                    }
                }
            }
        }
        
        if (nil != [[[CacheHandler instance] createSqeed] dateStart2]) {
            [dateOptions addObject:[[VoteOption alloc] init :@"0" :[[[CacheHandler instance] createSqeed] dateStart2] :[[[CacheHandler instance] createSqeed] dateEnd2] :@"0"]];
        }
        
        if (nil != [[[CacheHandler instance] createSqeed] dateStart3]) {
            [dateOptions addObject:[[VoteOption alloc] init :@"0" :[[[CacheHandler instance] createSqeed] dateStart3] :[[[CacheHandler instance] createSqeed] dateEnd3] :@"0"]];
        }
        
        [[CacheHandler instance] setFriendIds:friendIds];
        [[[CacheHandler instance] createSqeed] setDateOptions:dateOptions];
    
        [DatabaseManager createSqeed
            :[[[CacheHandler instance] createSqeed] title]
            :[[[CacheHandler instance] createSqeed] place]
            :[[[CacheHandler instance] createSqeed] sqeedDescription]
            :[[[CacheHandler instance] createSqeed] peopleMax]
            :[[[CacheHandler instance] createSqeed] sqeedCategory]
            :[[[CacheHandler instance] createSqeed] dateStart]
            :[[[CacheHandler instance] createSqeed] dateEnd]
            :[[[CacheHandler instance] createSqeed] privateAccess]];
        
    } else {
        NSLog(@"Error: You are a dumbass!");
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[_friendTable cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    
    if (0 == indexPath.section) {
        
    } else {
        BOOL allSelected = YES;
        for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
            if (1 == ip.section
                && 0 != ip.row
                && ![[_friendTable cellForRowAtIndexPath:ip] isSelected]) {
                allSelected = NO;
                break;
            }
        }
        if (0 != indexPath.row && !allSelected) {
            [_friendTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES];
            [[_friendTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        if (0 == indexPath.row) {
            for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
                [_friendTable deselectRowAtIndexPath:ip animated:YES];
                [[_friendTable cellForRowAtIndexPath:ip] setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[_friendTable cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if (0 == indexPath.section) {
        
    } else {
        BOOL allSelected = YES;
        for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
            if (1 == ip.section
                && 0 != ip.row
                && ![[_friendTable cellForRowAtIndexPath:ip] isSelected]) {
                allSelected = NO;
                break;
            }
        }
        
        if (0 != indexPath.row && allSelected) {
            [_friendTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [[_friendTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        
        if (0 == indexPath.row) {
            for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
                [_friendTable selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
                [[_friendTable cellForRowAtIndexPath:ip] setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
    }
}

- (IBAction)switchAccess:(id)sender {
    UISwitch *switchPublicPrivate = sender;
    if ([switchPublicPrivate isOn]) {
        self.publicPrivate.image = [UIImage imageNamed:@"private.png"];
        [[[CacheHandler instance] createSqeed] setPrivateAccess:@"1"];
    } else {
        self.publicPrivate.image = [UIImage imageNamed:@"public.png"];
        [[[CacheHandler instance] createSqeed] setPrivateAccess:@"0"];
    }
}

- (void)showSqeed:(NSNotification *)notification {
    [[self activityIndicator] stopAnimating];
    
    // EMPTY createSqeed in cache
    [[CacheHandler instance] setCreateSqeed:[[Sqeed alloc] init]];
    [[[CacheHandler instance] createSqeed] setSqeedId:@"0"];
    [[[CacheHandler instance] createSqeed] setTitle:@""];
    [[[CacheHandler instance] createSqeed] setPeopleMax:@"10"];
    [[[CacheHandler instance] createSqeed] setPrivateAccess:@"0"];
    [[[CacheHandler instance] createSqeed] setDateStart:[NSDate date]];
    [[[CacheHandler instance] createSqeed] setDateEnd:[NSDate dateWithTimeIntervalSinceNow:1800]];
    [[[CacheHandler instance] createSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:0]];
}

- (void)fetchSqeeds:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchSqeedsDidComplete"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CreateSqeedDidComplete"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"AddDatetimeOptionDidComplete"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"InviteDidComplete"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchSqeedsDidFail"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CreateSqeedDidFail"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"AddDatetimeOptionDidFail"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"InviteDidFail"
                                                  object:nil];
    
    [[CacheHandler instance] setCreated:YES];
    
    [self performSegueWithIdentifier:@"segueInviteFriendsDidComplete" sender:self];
}

- (void)addNextOption:(NSNotification *)notification {
    int index = (int)[[notification userInfo][@"index"] integerValue];
    
    if ([[[[CacheHandler instance] createSqeed] dateOptions] count] == 0) { // NO OPTION AT ALL
        [DatabaseManager invite :[[[CacheHandler instance] createSqeed] sqeedId]
                                :[[CacheHandler instance] friendIds]];
    } else {
        if ([[[[CacheHandler instance] createSqeed] dateOptions] count] == index) { // NO MORE OPTION
            [DatabaseManager invite :[[[CacheHandler instance] createSqeed] sqeedId]
                                    :[[CacheHandler instance] friendIds]];
        } else {
            [DatabaseManager addDatetimeOption :[[[CacheHandler instance] createSqeed] sqeedId]
                                               :[[[CacheHandler instance] createSqeed] dateOptions][index]
                                               :index];
        }
    }
}

-(void)hideLoader {
    [[self loadingView] setHidden:YES];
    [[self activityIndicator] stopAnimating];
    [AlertHelper error:@"The network connection was lost. Please try again in a moment."];
    if (![[[[CacheHandler instance] createSqeed] sqeedId] isEqualToString:@"0"]) {
        [self deleteFailedSqeed];
    }
}

-(void)deleteFailedSqeed {
    [DatabaseManager deleteSqeed:[[[CacheHandler instance] createSqeed] sqeedId]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
