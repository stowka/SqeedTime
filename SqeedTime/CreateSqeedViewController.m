//
//  CreateSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "CreateSqeedViewController.h"
#import "CacheHandler.h"
#import "SwipeViewController.h"
#import "UIImage+ImageEffects.h"

#import "ModalWhatViewController.h"
#import "ModalWhenViewController.h"
#import "ModalWhereViewController.h"
#import "ModalWhoViewController.h"

@interface CreateSqeedViewController ()

@end

NSDictionary* categories;

@implementation CreateSqeedViewController
@synthesize whatLabel;
@synthesize whenLabel;
@synthesize whereLabel;
@synthesize whoLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[[CacheHandler instance] currentUser] fetchFriends];
    [[[CacheHandler instance] currentUser] fetchFriendRequests];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [[[CacheHandler instance] categories] count];
}

- (NSString*)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return (NSString*)[[[CacheHandler instance] categories][row] label];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_whatToDoTextField resignFirstResponder];
    [[[CacheHandler instance] createSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:(int)row]];
}

- (IBAction)backgroundClick:(id)sender
{
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)saveToCache:(id)sender {
    [[[CacheHandler instance] createSqeed] setTitle:[[self whatToDoTextField] text]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"segueAddFriends"])
        return ![[_whatToDoTextField text] isEqualToString:@""];
    else
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIImage* imageOfUnderlyingView = [UIImage imageNamed:@"blurbg.jpg"];
    imageOfUnderlyingView = [imageOfUnderlyingView applyBlurWithRadius:30
                                                             tintColor:[UIColor colorWithWhite:1.0 alpha:0.3]
                                                 saturationDeltaFactor:1.3
                                                             maskImage:nil];
    if ([[segue identifier] isEqualToString:@"segueWhen"]) {
        ModalWhenViewController* destViewController = [segue destinationViewController];
        [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
    }
    if ([[segue identifier] isEqualToString:@"segueWhere"]) {
        ModalWhereViewController* destViewController = [segue destinationViewController];
        [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
    }
    if ([[segue identifier] isEqualToString:@"segueWho"]) {
        ModalWhoViewController* destViewController = [segue destinationViewController];
        [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
    }
    if ([[segue identifier] isEqualToString:@"segueWhat"]) {
        ModalWhatViewController* destViewController = [segue destinationViewController];
        [destViewController setImageOfUnderlyingView:imageOfUnderlyingView];
    }
}

- (void) updateLabels {
    NSLog(@"Updating labels: %@", [[[CacheHandler instance] createSqeed] place]);
    NSLog(@"%@", whatLabel.text);
    whereLabel.text = [[[CacheHandler instance] createSqeed] place];
    whatLabel.text = [[[CacheHandler instance] createSqeed] sqeedDescription];
    NSString *peopleLabel = [NSString stringWithFormat:@"%@ / %@", [[[CacheHandler instance] createSqeed] peopleMin], [[[CacheHandler instance] createSqeed] peopleMax]];
    whoLabel.text = peopleLabel;
    whereLabel.text = [[[[CacheHandler instance] createSqeed] dateStart] description];
}

- (IBAction)showWherePopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)showHowManyPeoplePopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)showDescriptionPopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)showWhenPopUp:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (IBAction)save:(id)sender {
    [_whatToDoTextField resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
