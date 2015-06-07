//
//  SearchViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchFriendTableViewCell.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"
#import "AlertHelper.h"

@interface SearchViewController ()

@end

NSArray* result;

@implementation SearchViewController

@synthesize search;
@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self table] setScrollsToTop:YES];
    [[self search] becomeFirstResponder];
    
    // Add observers for search
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:)
                                                 name:@"SearchDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayError)
                                                 name:@"SearchDidFail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:@"AddFriendDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:)
                                                 name:@"DeleteFriendDidComplete"
                                               object:nil];
}

- (void) refresh :(NSNotification *)notification {
    result = [[notification userInfo] objectForKey:@"users"];
    [[self table] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellSearchFriendID";
    SearchFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 cellIdentifier];
    if (cell == nil) {
        cell = [[SearchFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:cellIdentifier];
    }
    
    [[cell name] setText :[NSString stringWithFormat:@"%@",
                           [result[[indexPath row]] name]]];
    
    [cell setUserId:[result[[indexPath row]] userId]];
    
    if ([[[[CacheHandler instance] currentUser] friends] containsObject:result[[indexPath row]]]) {
        [cell setIsFriend:@"YES"];
        UIImage *image = [UIImage imageNamed:@"remove.png"];
        [[cell button] setImage:image forState:UIControlStateNormal];
    } else {
        [cell setIsFriend:@"NO"];
        UIImage *image = [UIImage imageNamed:@"add.png"];
        [[cell button] setImage:image forState:UIControlStateNormal];
    }
    
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search: %@", [searchBar text]);
    [[self search] resignFirstResponder];
    [DatabaseManager searchUser :[searchBar text]];
}

- (void) displayError {
    [AlertHelper error:@"Error! Please try again in a moment."];
}

- (void) reload {
    [DatabaseManager searchUser :[[self search] text]];
}

@end
