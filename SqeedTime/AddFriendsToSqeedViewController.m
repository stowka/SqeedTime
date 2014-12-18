//
//  AddFriendsToSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "AddFriendsToSqeedViewController.h"
#import "CacheHandler.h"
#import "AddFriendTableViewCell.h"

@interface AddFriendsToSqeedViewController ()

@end

@implementation AddFriendsToSqeedViewController

NSArray* friends;

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [[[CacheHandler instance] currentUser] friends];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DISPLAY SQEEDS IN A TABLE VIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellAddFriendID";
    AddFriendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
    if (cell == nil) {
        cell = [[AddFriendTableViewCell alloc]initWithStyle:
       
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [friends[indexPath.row] forname], [friends[indexPath.row] name]];
    cell.username.text = [NSString stringWithFormat:@"%@", [friends[indexPath.row] username]];
    return cell;
}

- (IBAction)save:(id)sender {
    
}

- (IBAction)addToList:(id)sender {
    
}
@end
