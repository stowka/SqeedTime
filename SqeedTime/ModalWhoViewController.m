//
//  ModalWhoViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ModalWhoViewController.h"
#import "CacheHandler.h"
#import "AlertHelper.h"

@interface ModalWhoViewController ()

@end

@implementation ModalWhoViewController
@synthesize imageOfUnderlyingView;
@synthesize icon;
@synthesize close;
@synthesize max;

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[CacheHandler instance] editing]) {
        [max setText:[[[CacheHandler instance] editSqeed] peopleMax]];
    } else {
        [max setText:[[[CacheHandler instance] createSqeed] peopleMax]];
    }
    
    
    [max setText:[max.text isEqualToString:@""] ? @"" : [max text]];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    UIImageView* backView = [[UIImageView alloc] initWithFrame:[[self view] frame]];
    [backView setImage:imageOfUnderlyingView];
    [backView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [[self view] addSubview:backView];
    [[self view] addSubview:icon];
    [[self view] addSubview:close];
    [[self view] addSubview:max];
    [[max layer] setCornerRadius:8];
    [[self max] becomeFirstResponder];
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
    [[[CacheHandler instance] createSqeed] setPeopleMax:[[self max] text]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalPeopleMaxDidChange"
                                                        object:nil];
}

- (IBAction)close:(id)sender {
    if ([[[self max] text] integerValue] > 30
        || [[[self max] text] integerValue] <= 0) {
        [AlertHelper error:@"This value is bound between 1 and 30"];
    } else {
        [self saveToCache:sender];
        [self performSegueWithIdentifier:@"segueDismissWho"
                                  sender:self];
    }
}
@end
