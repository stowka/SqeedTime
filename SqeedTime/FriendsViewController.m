//
//  FriendsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"
#import "CacheHandler.h"

@interface FriendsViewController ()

@end

NSArray* friends;

@implementation FriendsViewController

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
    static NSString *cellIdentifier = @"cellFriendID";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                cellIdentifier];
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [friends[indexPath.row] forname], [friends[indexPath.row] name]];
    cell.username.text = [NSString stringWithFormat:@"%@", [friends[indexPath.row] username]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)remove:(id)sender {
    NSLog(@"Remove friend: %@",@"");
}
@end
