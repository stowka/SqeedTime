//
//  LoadingViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 04/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "LoadingViewController.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

@synthesize loader;

- (void)viewDidLoad {
    [super viewDidLoad];
    [loader startAnimating];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismiss)
                                                 name:@"FetchSqeedsDidComplete"
                                               object:nil];
    
    [[[CacheHandler instance] currentUser] fetchMySqeeds];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FetchSqeedsDidComplete"
                                                  object:nil];
    
    [self performSegueWithIdentifier:@"segueFinishedLoading" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
