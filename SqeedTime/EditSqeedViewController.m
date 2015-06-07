//
//  EditSqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "EditSqeedViewController.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"

@interface EditSqeedViewController ()

@end

@implementation EditSqeedViewController

@synthesize whatToDo;
@synthesize categoryPicker;

@synthesize where;
@synthesize who;
@synthesize what;
@synthesize when;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [whatToDo setText:[[[CacheHandler instance] editSqeed] title]];
    [categoryPicker selectRow:[[[[[CacheHandler instance] editSqeed] sqeedCategory] categoryId] integerValue] inComponent:0 animated:YES];
    
    // Add observers to update labels
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlaceLabel)
                                                 name:@"EditPlaceDidChange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePeopleMaxLabel)
                                                 name:@"EditPeopleMaxDidChange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDescriptionLabel)
                                                 name:@"EditDescriptionDidChange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDateLabel)
                                                 name:@"EditDateDidChange"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSqeeds)
                                                 name:@"UpdateEventDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismiss)
                                                 name:@"FetchSqeedsDidComplete"
                                               object:nil];
    
    [self updateDateLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) updatePlaceLabel {
    if ([[[[CacheHandler instance] editSqeed] place] isEqualToString:@""])
        [where setText :@"Place"];
    else
        [where setText :[[[CacheHandler instance] editSqeed] place]];

}

- (void) updatePeopleMaxLabel {
    NSString *peopleLabel = [NSString stringWithFormat:@"%@", [[[CacheHandler instance] editSqeed] peopleMax]];
    [who setText :peopleLabel];
}

- (void) updateDescriptionLabel {
    if ([[[[CacheHandler instance] editSqeed] sqeedDescription] isEqualToString:@""])
        [what setText :@"Description"];
    else
        [what setText :[[[CacheHandler instance] editSqeed] sqeedDescription]];
}

- (void) updateDateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, HH:mm"];
    [when setText :[formatter stringFromDate:[[[CacheHandler instance] editSqeed] dateStart]]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [[[CacheHandler instance] categories] count] + 1;
}

- (NSString*)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return row == 0 ? @"Pick a category" : (NSString*)[[[CacheHandler instance] categories][row - 1] label];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [whatToDo resignFirstResponder];
    
    if (0 != row)
        [[[CacheHandler instance] editSqeed] setSqeedCategory:[[SqeedCategory alloc] initWithIndex:((int)row - 1)]];
}

- (IBAction)backgroundClick:(id)sender {
    [whatToDo resignFirstResponder];
}

- (IBAction)saveToCache:(id)sender {
    [[[CacheHandler instance] editSqeed] setTitle:[whatToDo text]];
}

- (IBAction)save:(id)sender {
    [DatabaseManager updateEvent:[[[CacheHandler instance] editSqeed] sqeedId]
                                :[[[CacheHandler instance] editSqeed] title]
                                :[[[CacheHandler instance] editSqeed] place]
                                :[[[CacheHandler instance] editSqeed] sqeedDescription]
                                :[[[CacheHandler instance] editSqeed] peopleMax]
                                :[[[CacheHandler instance] editSqeed] sqeedCategory]];
}

- (void)fetchSqeeds {
    [[[CacheHandler instance] currentUser] fetchMySqeeds];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"EditPlaceDidChange"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"EditPeopleMaxDidChange"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"EditDescriptionDidChange"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"EditDateDidChange"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UpdateEventDidComplete"
                                                  object:nil];
    
    
    [self performSegueWithIdentifier:@"segueDismissEdit" sender:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
