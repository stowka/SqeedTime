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
