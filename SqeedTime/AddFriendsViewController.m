//
//  AddFriendsToSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "CacheHandler.h"
#import "AddFriendTableViewCell.h"

@interface AddFriendsViewController ()

@end

NSArray* friends;

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    friends = [[[CacheHandler instance] currentUser] friends];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellInviteFriendID";
    AddFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 cellIdentifier];
    if (cell == nil) {
        cell = [[AddFriendTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [friends[indexPath.row] forname], [friends[indexPath.row] name]];
    cell.username.text = [NSString stringWithFormat:@"%@", [friends[indexPath.row] username]];
    return cell;
}
@end
