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

@interface AddFriendsViewController ()

@end

NSArray* friends;

@implementation AddFriendsViewController
@synthesize navigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [[[CacheHandler instance] currentUser] friends];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        cell.username.text = [NSString stringWithFormat:@"%@", [friends[indexPath.row - 1] username]];
        cell.userId = [friends[indexPath.row - 1] userId];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(67/255.0) green:(157/255.0) blue:(187/255.0) alpha:0.7];
    cell.selectedBackgroundView = selectionColor;
    return cell;
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
            [[[CacheHandler instance] createSqeed] setDateEnd:[NSDate dateWithTimeInterval:1800 sinceDate:[[[CacheHandler instance] createSqeed] dateStart]]];
        
        NSArray *selectedIndexPaths = [_friendTable indexPathsForSelectedRows];
        NSMutableArray *friendIds = [[NSMutableArray alloc] init];
        NSMutableArray *dateOptions = [[NSMutableArray alloc] init];
        
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            if (0 != indexPath.row) {
                AddFriendTableViewCell *tmp_cell = (AddFriendTableViewCell *)[_friendTable cellForRowAtIndexPath:indexPath];
                [friendIds addObject:[tmp_cell userId]];
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
    BOOL allSelected = YES;
    for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
        if (0 != ip.row && ![[_friendTable cellForRowAtIndexPath:ip] isSelected]) {
            allSelected = NO;
            break;
        }
    }
    if (0 != indexPath.row && !allSelected) {
        [_friendTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
        [[_friendTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if (0 == indexPath.row) {
        for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
            [_friendTable deselectRowAtIndexPath:ip animated:YES];
            [[_friendTable cellForRowAtIndexPath:ip] setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[_friendTable cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    BOOL allSelected = YES;
    for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
        if (0 != ip.row && ![[_friendTable cellForRowAtIndexPath:ip] isSelected]) {
            allSelected = NO;
            break;
        }
    }
    
    if (0 != indexPath.row && allSelected) {
        [_friendTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [[_friendTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    if (0 == indexPath.row) {
        for (NSIndexPath *ip in [_friendTable indexPathsForVisibleRows]) {
            [_friendTable selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
            [[_friendTable cellForRowAtIndexPath:ip] setAccessoryType:UITableViewCellAccessoryCheckmark];
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
    [[[CacheHandler instance] createSqeed] setTitle:@""];
    [[[CacheHandler instance] createSqeed] setPeopleMax:@"10"];
    [[[CacheHandler instance] createSqeed] setPrivateAccess:@"0"];
    [[[CacheHandler instance] createSqeed] setDateStart:[NSDate date]];
    [[[CacheHandler instance] createSqeed] setDateEnd:[NSDate dateWithTimeIntervalSinceNow:1800]];
    [[[CacheHandler instance] createSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:0]];
    
    [[[CacheHandler instance] currentUser] fetchMySqeeds];
    [[[CacheHandler instance] currentUser] fetchDiscovered];
}

- (void)fetchSqeeds:(NSNotification *)notification {
    [[self activityIndicator] stopAnimating];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchSqeedsDidComplete"
                                                  object:nil];
    
    [self performSegueWithIdentifier:@"segueInviteFriendsDidComplete" sender:self];
}

- (void)addNextOption:(NSNotification *)notification {
    int index = (int)[[notification userInfo][@"index"] integerValue];
    
    if ([[[[CacheHandler instance] createSqeed] dateOptions] count] == 0) { // NO OPTION AT ALL
        [DatabaseManager invite :[[[CacheHandler instance] createSqeed] sqeedId] :[[CacheHandler instance] friendIds]];
    }
    
    if ([[[[CacheHandler instance] createSqeed] dateOptions] count] == index) { // NO MORE OPTION
        [DatabaseManager invite :[[[CacheHandler instance] createSqeed] sqeedId] :[[CacheHandler instance] friendIds]];
    } else {
        [DatabaseManager addDatetimeOption :[[[CacheHandler instance] createSqeed] sqeedId] :[[[CacheHandler instance] createSqeed] dateOptions][index] :index];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
