//
//  InviteViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "InviteViewController.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"
#import "InviteTableViewCell.h"

@interface InviteViewController ()

@end

NSArray *friends;
NSArray *going;
NSArray *waiting;

@implementation InviteViewController

@synthesize table;
@synthesize switchButton;
@synthesize accessImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    friends = [[[CacheHandler instance] currentUser] friends];
    going = [[[CacheHandler instance] editSqeed] going];
    waiting = [[[CacheHandler instance] editSqeed] waiting];
    
    [table setScrollsToTop:YES];
    
    if ([[[[CacheHandler instance] editSqeed] privateAccess] isEqualToString:@"1"]) {
        [switchButton setOn:YES animated:NO];
        accessImage.image = [UIImage imageNamed:@"private.png"];
    } else {
        [switchButton setOn:NO animated:NO];
        accessImage.image = [UIImage imageNamed:@"public.png"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateAccess)
                                                 name:@"InviteDidComplete"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSqeeds)
                                                 name:@"UpdateEventAccessDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismiss)
                                                 name:@"FetchSqeedsDidComplete"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isAlreadyInvited :(NSString *)friendId {
    for (User *u in going)
        if ([[u userId] isEqualToString:friendId])
            return YES;
    
    for (User *u in waiting)
        if ([[u userId] isEqualToString:friendId])
            return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Friends";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellInviteFriendsID";
    InviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                    cellIdentifier];
    if (cell == nil) {
        cell = [[InviteTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (0 == indexPath.row) {
        cell.name.text = @"Invite all";
    } else {
        cell.name.text = [NSString stringWithFormat:@"%@", [friends[indexPath.row - 1] name]];
        cell.userId = [friends[indexPath.row - 1] userId];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(67/255.0) green:(157/255.0) blue:(187/255.0) alpha:0.7];
    cell.selectedBackgroundView = selectionColor;
    
    if ([self isAlreadyInvited:cell.userId])
        [table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[table cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    
    BOOL allSelected = YES;
    for (NSIndexPath *ip in [table indexPathsForVisibleRows]) {
        if (0 != ip.row
            && ![[table cellForRowAtIndexPath:ip] isSelected]) {
            allSelected = NO;
            break;
        }
    }
    if (0 != indexPath.row && !allSelected) {
        [table deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
        [[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    if (0 == indexPath.row) {
        for (NSIndexPath *ip in [table indexPathsForVisibleRows]) {
            [table deselectRowAtIndexPath:ip animated:YES];
            [[table cellForRowAtIndexPath:ip] setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[table cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    BOOL allSelected = YES;
    for (NSIndexPath *ip in [table indexPathsForVisibleRows]) {
        if (0 != ip.row
            && ![[table cellForRowAtIndexPath:ip] isSelected]) {
            allSelected = NO;
            break;
        }
    }
    
    if (0 != indexPath.row && allSelected) {
        [table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    if (0 == indexPath.row) {
        for (NSIndexPath *ip in [table indexPathsForVisibleRows]) {
            [table selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
            [[table cellForRowAtIndexPath:ip] setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
}

- (IBAction)save:(id)sender {
    NSArray *selectedIndexPaths = [table indexPathsForSelectedRows];
    NSMutableArray *friendIds = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        if (0 != indexPath.row) {
            InviteTableViewCell *tmp_cell = (InviteTableViewCell *)[table cellForRowAtIndexPath:indexPath];
            [friendIds addObject:[tmp_cell userId]];
        }
    }
    
    [DatabaseManager invite:[[[CacheHandler instance] editSqeed] sqeedId]
                           :friendIds];
}

- (void)updateAccess {
    [DatabaseManager updateEventAccess:[[[CacheHandler instance] editSqeed] sqeedId]
                                      :[[[CacheHandler instance] editSqeed] privateAccess]];
}

- (void)fetchSqeeds {
    [[[CacheHandler instance] currentUser] fetchMySqeeds];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"InviteDidComplete"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UpdateEventAccessDidComplete"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchSqeedsDidComplete"
                                                  object:nil];
    [self performSegueWithIdentifier:@"segueDismissInvite" sender:self];
}

- (IBAction)switchAccess:(id)sender {
    UISwitch *switchPublicPrivate = sender;
    if ([switchPublicPrivate isOn]) {
        accessImage.image = [UIImage imageNamed:@"private.png"];
        [[[CacheHandler instance] editSqeed] setPrivateAccess:@"1"];
    } else {
        accessImage.image = [UIImage imageNamed:@"public.png"];
        [[[CacheHandler instance] editSqeed] setPrivateAccess:@"0"];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
