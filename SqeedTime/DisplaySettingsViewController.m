//
//  DisplaySettingsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "DisplaySettingsViewController.h"

@interface DisplaySettingsViewController ()

@end

@implementation DisplaySettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://tobi.oetiker.ch/lshort/lshort.pdf"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
