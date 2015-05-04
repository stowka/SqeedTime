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

    if ([[CacheHandler instance] editing]) {
        [min setText:[[[CacheHandler instance] editSqeed] peopleMin]];
        [max setText:[[[CacheHandler instance] editSqeed] peopleMax]];
    } else {
        [min setText:[[[CacheHandler instance] createSqeed] peopleMin]];
        [max setText:[[[CacheHandler instance] createSqeed] peopleMax]];
    }
    
    
    [min setText:[min.text isEqualToString:@""] ? @"1" : [min text]];
    [max setText:[max.text isEqualToString:@""] ? @"10" : [max text]];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    UIImageView* backView = [[UIImageView alloc] initWithFrame:[[self view] frame]];
    [backView setImage:imageOfUnderlyingView];
    [backView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [[self view] addSubview:backView];
    [[self view] addSubview:icon];
    [[self view] addSubview:close];
    [[self view] addSubview:min];
    [[self view] addSubview:max];
    [[min layer] setCornerRadius:8];
    [[max layer] setCornerRadius:8];
    [[self min] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //first, check if the new string is numeric only. If not, return NO;
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([newString rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
        return NO;
    }
    
    return [newString doubleValue] < 30 && [newString doubleValue] > 1;
}

- (IBAction)saveToCache:(id)sender {
    NSLog(@"saved");
    if ([[CacheHandler instance] editing]) {
        [[[CacheHandler instance] editSqeed] setPeopleMin:[[self min] text]];
        [[[CacheHandler instance] editSqeed] setPeopleMax:[[self max] text]];
    } else {
        [[[CacheHandler instance] createSqeed] setPeopleMin:[[self min] text]];
        [[[CacheHandler instance] createSqeed] setPeopleMax:[[self max] text]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalPeopleMinMaxDidChange"
                                                        object:nil];
}

- (IBAction)close:(id)sender {
    [self saveToCache:sender];
    [self performSegueWithIdentifier:@"segueDismissWho"
                              sender:self];
}
@end
