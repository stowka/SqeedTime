//
//  EditSqeedViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSqeedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *whatToDo;
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) IBOutlet UILabel *where;
@property (strong, nonatomic) IBOutlet UILabel *who;
@property (strong, nonatomic) IBOutlet UILabel *what;
@property (strong, nonatomic) IBOutlet UILabel *when;

- (void) updatePlaceLabel;
- (void) updatePeopleMaxLabel;
- (void) updateDescriptionLabel;
- (void) updateDateLabel;
- (void) fetchSqeeds;


- (IBAction)save:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)saveToCache:(id)sender;

@end
