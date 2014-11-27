//
//  CreateSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "CreateSqeedViewController.h"
#import "CRequestHandler.h"

@interface CreateSqeedViewController ()

@end

NSDictionary* categories;

@implementation CreateSqeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    categories = [CRequestHandler post:@"function=getCategories"];
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
    return [categories count];
}

- (NSString*)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* uniqueKey = [NSString stringWithFormat:@"%d", (int)row];
    return (NSString*)[[categories valueForKey:uniqueKey] valueForKey:@"title"];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // TODO save category
}

- (IBAction)backgroundClick:(id)sender
{
    [_whatToDoTextField resignFirstResponder];
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
