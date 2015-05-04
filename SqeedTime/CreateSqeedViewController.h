//
//  CreateSqeedViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateSqeedViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPickerView;
@property (strong, nonatomic) IBOutlet UITextField *whatToDoTextField;

@property (strong, nonatomic) IBOutlet UILabel *whereLabel;
@property (strong, nonatomic) IBOutlet UILabel *whoLabel;
@property (strong, nonatomic) IBOutlet UILabel *whatLabel;
@property (strong, nonatomic) IBOutlet UILabel *whenLabel;
@property (strong, nonatomic) IBOutlet UITableView *autocompleteTableView;

@property (strong, nonatomic) NSArray *allSuggestions;
@property (strong, nonatomic) NSMutableArray *suggestions;

- (void) updatePlaceLabel;
- (void) updatePeopleMinMaxLabel;
- (void) updateDescriptionLabel;
- (void) updateDateLabel;

- (IBAction)showWherePopUp:(id)sender;
- (IBAction)showHowManyPeoplePopUp:(id)sender;
- (IBAction)showDescriptionPopUp:(id)sender;
- (IBAction)showWhenPopUp:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)backgroundClick:(id)sender;
- (IBAction)saveToCache:(id)sender;

@end
