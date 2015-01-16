//
//  ModalWhenViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ModalWhenViewController.h"
#import "CacheHandler.h"

@interface ModalWhenViewController ()

@end

@implementation ModalWhenViewController
@synthesize imageOfUnderlyingView;
@synthesize icon;
@synthesize close;
@synthesize startLabel;
@synthesize endLabel;
@synthesize startPicker;
@synthesize endPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = imageOfUnderlyingView;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:backView];
    [self.view addSubview:icon];
    [self.view addSubview:close];
    [self.view addSubview:startLabel];
    [self.view addSubview:startPicker];
    [self.endPicker setDate:[NSDate dateWithTimeIntervalSinceNow:(3600 * 3)]];
    [self.view addSubview:endLabel];
    [self.view addSubview:endPicker];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalDateDidChange"
                                                        object:nil];
    [[[CacheHandler instance] createSqeed] setDateStart:[[self startPicker] date]];
    [[[CacheHandler instance] createSqeed] setDateEnd:[[self endPicker] date]];
    [[self endPicker] setMinimumDate:[NSDate dateWithTimeInterval:(60 * 15) sinceDate:[[self startPicker] date]]];
}

- (IBAction)close:(id)sender {
    [self performSegueWithIdentifier:@"segueDimissWhen" sender:self];
}
@end
