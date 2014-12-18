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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveToCache:(id)sender {
    NSLog(@"Saving people to cache...");
    [[[CacheHandler instance] createSqeed] setPeopleMin:[[self min] text]];
    [[[CacheHandler instance] createSqeed] setPeopleMax:[[self max] text]];
}
@end
