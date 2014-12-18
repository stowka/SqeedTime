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
    cell.userId = [friends[indexPath.row] userId];
    return cell;
}
- (IBAction)save:(id)sender {
    if (![[[[CacheHandler instance] createSqeed] title] isEqualToString:@""]) {
        if (nil == [[[CacheHandler instance] createSqeed] sqeedDescription])
            [[[CacheHandler instance] createSqeed] setSqeedDescription: @""];
    
        if (nil == [[[CacheHandler instance] createSqeed] place])
            [[[CacheHandler instance] createSqeed] setPlace: @""];
    
        if (nil == [[[CacheHandler instance] createSqeed] peopleMin])
            [[[CacheHandler instance] createSqeed] setPeopleMin: @""];
    
        if (nil == [[[CacheHandler instance] createSqeed] peopleMax])
            [[[CacheHandler instance] createSqeed] setPeopleMax: @""];
    
        NSArray *selectedIndexPaths = [_friendTable indexPathsForSelectedRows];
        NSMutableArray *friendIds = [[NSMutableArray alloc] init];
    
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            AddFriendTableViewCell *tmp_cell = (AddFriendTableViewCell *)[_friendTable cellForRowAtIndexPath:indexPath];
            [friendIds addObject:[tmp_cell userId]];
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
            :friendIds];
    } else {
        NSLog(@"Error: You are a dumbass!");
    }
}
@end
