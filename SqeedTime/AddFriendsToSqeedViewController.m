//
//  AddFriendsToSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "AddFriendsToSqeedViewController.h"
#import "CacheHandler.h"
#import "FriendTableViewCell.h"

@interface AddFriendsToSqeedViewController ()

@end

@implementation AddFriendsToSqeedViewController

NSArray* myFriends;
NSMutableArray* selectedFriends;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DISPLAY SQEEDS IN A TABLE VIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cellFriendID";
    FriendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [[cell name] setText:[NSString stringWithFormat:@"%@ %@", [[myFriends objectAtIndex:indexPath.row] valueForKey:@"forname"], [[myFriends objectAtIndex:indexPath.row] valueForKey:@"name"]]];
    [[cell username] setText:[[myFriends objectAtIndex:indexPath.row] valueForKey:@"username"]];
    return cell;
}

- (IBAction)save:(id)sender {
}
@end
