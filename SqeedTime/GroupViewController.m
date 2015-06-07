//
//  GroupViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 02/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "GroupViewController.h"
#import "CacheHandler.h"
#import "GroupFriendTableViewCell.h"
#import "DatabaseManager.h"

@interface GroupViewController ()

@end

NSArray *friends;
NSArray *friendsInGroup;
BOOL hasChanged;

@implementation GroupViewController

@synthesize groupName;
@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hasChanged = NO;
    
    [groupName setText:[[[CacheHandler instance] currentGroup] title]];
    friends = [[[CacheHandler instance] currentUser] friends];
    friendsInGroup = [[[CacheHandler instance] currentGroup] friends];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getGroups)
                                                 name:@"UpdateGroupDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismiss)
                                                 name:@"GetGroupsDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getGroups)
                                                 name:@"DelGroupDidComplete"
                                               object:nil];
    
    [table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Friends";
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellFriendGroupID";
    GroupFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
    if (cell == nil) {
        cell = [[GroupFriendTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    User *friend = (User *)[[[CacheHandler instance] currentUser] friends][[indexPath row]];
    [cell setUserId:[friend userId]];
    [[cell name] setText:[friend name]];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(67/255.0) green:(157/255.0) blue:(187/255.0) alpha:0.7];
    cell.selectedBackgroundView = selectionColor;
        
    if ([self isInGroup:[friend userId]])
        [table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    return cell;
}

- (void)alertView :(UIAlertView *)alertView clickedButtonAtIndex :(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [DatabaseManager delGroup:[[[CacheHandler instance] currentGroup] groupId] :[[NSArray alloc] init]];
    }
}

- (IBAction)delete:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Delete this group"
                              message:@"Are you sure?"
                              delegate:self
                              cancelButtonTitle:@"Yes"
                              otherButtonTitles:nil];
    
    [alertView addButtonWithTitle:@"No"];
    [alertView show];
}

- (BOOL) isInGroup:(NSString *)friendId {
    for (User *u in friendsInGroup)
        if ([[u userId] isEqualToString:friendId])
            return YES;
    
    return NO;
}
         
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
    hasChanged = YES;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    hasChanged = YES;
}

- (IBAction) save:(id)sender {
    [groupName resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadFriends"
                                                        object:nil];
    
    if (!hasChanged) {
        hasChanged = NO;
        [self dismiss];
    } else {
        NSArray *selectedIndexPaths = [table indexPathsForSelectedRows];
        NSMutableArray *friendIds = [[NSMutableArray alloc] init];
        
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            GroupFriendTableViewCell *tmp_cell = (GroupFriendTableViewCell *)[table cellForRowAtIndexPath:indexPath];
            [friendIds addObject:[tmp_cell userId]];
        }
        [DatabaseManager updateGroup:[[[CacheHandler instance] currentGroup] groupId]
                                    :friendIds];
    }
}

- (void) getGroups {
    [DatabaseManager getGroups];
}

- (void) dismiss {
    [self performSegueWithIdentifier:@"segueGroupDone" sender:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
