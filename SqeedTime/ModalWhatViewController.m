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
@synthesize descriptionField;
@synthesize icon;
@synthesize close;
@synthesize imageOfUnderlyingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[CacheHandler instance] editing]) {
        [descriptionField setText:[[[CacheHandler instance] editSqeed] sqeedDescription]];
    } else {
        [descriptionField setText:[[[CacheHandler instance] createSqeed] sqeedDescription]];
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView* backView = [[UIImageView alloc] initWithFrame:[[self view] frame]];
    backView.image = imageOfUnderlyingView;
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [[self view] addSubview:backView];
    [[self view] addSubview:icon];
    [[self view] addSubview:close];
    [[self view] addSubview:descriptionField];
    [[descriptionField layer] setCornerRadius:8];
    [[self descriptionField] becomeFirstResponder];
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

- (void)saveToCache {
    [[[CacheHandler instance] createSqeed] setSqeedDescription:[[self descriptionField] text]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalDescriptionDidChange"
                      object:nil];
}

- (IBAction)close:(id)sender {
    [self saveToCache];
    [self performSegueWithIdentifier:@"segueDismissWhat"
                              sender:self];
}
@end
