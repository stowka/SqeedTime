//
//  ModalWhoViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ModalWhoViewController.h"
#import "CacheHandler.h"

@interface ModalWhoViewController ()

@end

@implementation ModalWhoViewController
@synthesize imageOfUnderlyingView;
@synthesize icon;
@synthesize close;
@synthesize min;
@synthesize max;

- (void)viewDidLoad {
    [super viewDidLoad];
    min.text = [[[CacheHandler instance] createSqeed] peopleMin];
    max.text = [[[CacheHandler instance] createSqeed] peopleMax];
    min.text = [min.text isEqualToString:@""] ? @"1" : min.text;
    max.text = [max.text isEqualToString:@""] ? @"10" : max.text;
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = imageOfUnderlyingView;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:backView];
    [self.view addSubview:icon];
    [self.view addSubview:close];
    [self.view addSubview:min];
    [self.view addSubview:max];
    [[self min] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveToCache:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalPeopleMinMaxDidChange"
                                                        object:nil];
    [[[CacheHandler instance] createSqeed] setPeopleMin:[[self min] text]];
    [[[CacheHandler instance] createSqeed] setPeopleMax:[[self max] text]];
}
@end
