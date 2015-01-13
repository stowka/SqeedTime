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

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [[[CacheHandler instance] currentUser] friends];
    [[self friendTable] setScrollsToTop:YES];
    [_switchButton setOn:NO animated:NO];
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
        cell.name.text = [NSString stringWithFormat:@"%@ %@", [friends[indexPath.row - 1] forname], [friends[indexPath.row - 1] name]];
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
    if (![[[[CacheHandler instance] createSqeed] title] isEqualToString:@""]) {
        NSLog(@"Saving...");
        [_saveButton setTitle:@""];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        [self navigationItem].rightBarButtonItem = barButton;
        [activityIndicator startAnimating];
        
        if (nil == [[[CacheHandler instance] createSqeed] sqeedDescription])
            [[[CacheHandler instance] createSqeed] setSqeedDescription: @""];
    
        if (nil == [[[CacheHandler instance] createSqeed] place])
            [[[CacheHandler instance] createSqeed] setPlace: @""];
    
        if (nil == [[[CacheHandler instance] createSqeed] peopleMin])
            [[[CacheHandler instance] createSqeed] setPeopleMin: @"1"];
        
        if (nil == [[[CacheHandler instance] createSqeed] peopleMax])
            [[[CacheHandler instance] createSqeed] setPeopleMax: @"10"];
        
        if (nil == [[[CacheHandler instance] createSqeed] dateStart])
            [[[CacheHandler instance] createSqeed] setDateStart: [NSDate date]];
        
        if (nil == [[[CacheHandler instance] createSqeed] dateEnd])
            [[[CacheHandler instance] createSqeed] setDateEnd:[NSDate dateWithTimeIntervalSinceNow:3600]];
    
        NSArray *selectedIndexPaths = [_friendTable indexPathsForSelectedRows];
        NSMutableArray *friendIds = [[NSMutableArray alloc] init];
    
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            if (0 != indexPath.row) {
                AddFriendTableViewCell *tmp_cell = (AddFriendTableViewCell *)[_friendTable cellForRowAtIndexPath:indexPath];
                [friendIds addObject:[tmp_cell userId]];
            }
        }
    
        [DatabaseManager createSqeed
            :[[[CacheHandler instance] createSqeed] title]
            :[[[CacheHandler instance] createSqeed] place]
            :[[CacheHandler instance] currentUser]
            :[[[CacheHandler instance] createSqeed] sqeedDescription]
            :[[[CacheHandler instance] createSqeed] peopleMax]
            :[[[CacheHandler instance] createSqeed] peopleMin]
            :[[[CacheHandler instance] createSqeed] sqeedCategory]
            :[[[CacheHandler instance] createSqeed] dateStart]
            :[[[CacheHandler instance] createSqeed] dateEnd]
            :[[[CacheHandler instance] createSqeed] privateAccess]
            :friendIds];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
