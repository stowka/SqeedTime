//
//  ModalWhatViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ModalWhatViewController.h"
#import "CacheHandler.h"

@interface ModalWhatViewController ()

@end

@implementation ModalWhatViewController
@synthesize description;
@synthesize icon;
@synthesize close;
@synthesize imageOfUnderlyingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = imageOfUnderlyingView;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:backView];
    [self.view addSubview:icon];
    [self.view addSubview:close];
    [self.view addSubview:description];
    [[self description] becomeFirstResponder];
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
    NSLog(@"Saving description to cache...");
    [[[CacheHandler instance] createSqeed] setSqeedDescription:[[self description] text]];
}
@end
