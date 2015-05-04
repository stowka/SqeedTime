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
@synthesize dateChoice;
@synthesize active;
@synthesize activeLabel;
@synthesize close;
@synthesize startLabel;
@synthesize endLabel;
@synthesize startPicker;
@synthesize endPicker;

@synthesize date2Active;
@synthesize date3Active;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView* backView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backView.image = imageOfUnderlyingView;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:backView];
    [self.view addSubview:icon];
    [[self view] addSubview:dateChoice];
    [[self view] addSubview:active];
    [[self view] addSubview:activeLabel];
    [active setHidden:YES];
    [active setOn:NO];
    [self.view addSubview:close];
    [self.view addSubview:startLabel];
    [self.view addSubview:startPicker];
    [startPicker setMinimumDate:[NSDate date]];
    [self.endPicker setDate:[NSDate dateWithTimeIntervalSinceNow:(1800)]];
    [self.view addSubview:endLabel];
    [self.view addSubview:endPicker];
    [endPicker setMinimumDate:[NSDate dateWithTimeIntervalSinceNow:(1800)]];
    date2Active = NO;
    date3Active = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)switchDate:(id)sender {
    if ([[self dateChoice] selectedSegmentIndex] == 0) {
        [startPicker setDate:[[[CacheHandler instance] createSqeed] dateStart]];
        [[self endPicker] setMinimumDate:[NSDate dateWithTimeInterval:(60 * 15) sinceDate:[[[CacheHandler instance] createSqeed] dateStart]]];
        [endPicker setDate:[[[CacheHandler instance] createSqeed] dateEnd]];
        [[self active] setHidden:YES];
        [[self activeLabel] setHidden:YES];
    } else {
        [[self active] setHidden:NO];
        [[self activeLabel] setHidden:NO];
    }
    
    if ([[self dateChoice] selectedSegmentIndex] == 1) {
        if (date2Active) {
            [[self active] setOn:YES];
            [startPicker setDate:[[[CacheHandler instance] createSqeed] dateStart2]];
            [[self endPicker] setMinimumDate:[NSDate dateWithTimeInterval:(60 * 15) sinceDate:[[[CacheHandler instance] createSqeed] dateStart2]]];
            [endPicker setDate:[[[CacheHandler instance] createSqeed] dateEnd2]];
        } else {
            [[self active] setOn:NO];
        }
    }
    
    if ([[self dateChoice] selectedSegmentIndex] == 2) {
        if (!date2Active)
            [dateChoice setSelectedSegmentIndex:1];
        if (date3Active) {
            [[self active] setOn:YES];
            [startPicker setDate:[[[CacheHandler instance] createSqeed] dateStart3]];
            [[self endPicker] setMinimumDate:[NSDate dateWithTimeInterval:(60 * 15) sinceDate:[[[CacheHandler instance] createSqeed] dateStart3]]];
            [endPicker setDate:[[[CacheHandler instance] createSqeed] dateEnd3]];
        } else {
            [[self active] setOn:NO];
        }
    }
    
    [self saveToCache:self];
}

- (IBAction)activate:(id)sender {
    if ([[self dateChoice] selectedSegmentIndex] == 1) {
        date2Active = [active isOn];
        if (!date2Active) {
            date3Active = NO;
        }
    }
    
    if ([[self dateChoice] selectedSegmentIndex] == 2) {
        date3Active = [active isOn];
    }
}

- (IBAction)saveToCache:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalDateDidChange"
                                                        object:nil];
    
    if ([[self dateChoice] selectedSegmentIndex] == 0) {
        [[[CacheHandler instance] createSqeed] setDateStart:[[self startPicker] date]];
        [[[CacheHandler instance] createSqeed] setDateEnd:[[self endPicker] date]];
        [[self endPicker] setMinimumDate:[NSDate dateWithTimeInterval:(60 * 15) sinceDate:[[self startPicker] date]]];
    } else if ([[self dateChoice] selectedSegmentIndex] == 1 && date2Active) {
        [[[CacheHandler instance] createSqeed] setDateStart2:[[self startPicker] date]];
        [[[CacheHandler instance] createSqeed] setDateEnd2:[[self endPicker] date]];
        [[self endPicker] setMinimumDate:[NSDate dateWithTimeInterval:(60 * 15) sinceDate:[[self startPicker] date]]];
    } else if ([[self dateChoice] selectedSegmentIndex] == 2 && date2Active && date3Active) {
        [[[CacheHandler instance] createSqeed] setDateStart3:[[self startPicker] date]];
        [[[CacheHandler instance] createSqeed] setDateEnd3:[[self endPicker] date]];
        
        [[self endPicker] setMinimumDate:[NSDate dateWithTimeInterval:(60 * 15) sinceDate:[[self startPicker] date]]];
    }
    
    if (!date2Active) {
        [[[CacheHandler instance] createSqeed] setDateStart2:nil];
        [[[CacheHandler instance] createSqeed] setDateEnd2:nil];
    }
    
    if (!date3Active) {
        [[[CacheHandler instance] createSqeed] setDateStart3:nil];
        [[[CacheHandler instance] createSqeed] setDateEnd3:nil];
    }
}

- (IBAction)close:(id)sender {
    [self performSegueWithIdentifier:@"segueDismissWhen" sender:self];
}
@end
