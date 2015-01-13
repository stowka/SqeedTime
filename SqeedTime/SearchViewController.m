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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh:)
                                                 name:@"SearchDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayError)
                                                 name:@"SearchDidFail"
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
    
    [[cell name] setText :[NSString stringWithFormat:@"%@ %@",
                           [result[[indexPath row]] forname],
                           [result[[indexPath row]] name]]];
    
    [[cell username] setText :[NSString stringWithFormat:@"%@",
                               [result[[indexPath row]] username]]];
    
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

@end
