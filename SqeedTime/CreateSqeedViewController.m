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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return (NSString*)[[[CacheHandler instance] categories][[NSString stringWithFormat:@"%d", row]] label];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[[CacheHandler instance] createSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithId:[NSString stringWithFormat:@"%d", row]]];
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
    [_whereLabel setText:[[[CacheHandler instance] createSqeed] place]];
    [_whatLabel setText:[[[CacheHandler instance] createSqeed] sqeedDescription]];
    NSString *peopleLabel = [NSString stringWithFormat:@"%@ / %@", [[[CacheHandler instance] createSqeed] peopleMin], [[[CacheHandler instance] createSqeed] peopleMax]];
    [_whoLabel setText:peopleLabel];
    [_whereLabel setText:[[[[CacheHandler instance] createSqeed] dateStart] description]];
}

- (IBAction)showWherePopUp:(id)sender {
}

- (IBAction)showHowManyPeoplePopUp:(id)sender {
}

- (IBAction)showDescriptionPopUp:(id)sender {
}

- (IBAction)showWhenPopUp:(id)sender {
}

- (IBAction)save:(id)sender {
}
@end
