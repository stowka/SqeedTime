//
//  CreateSqeedViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryPickerView.h"

@interface CreateSqeedViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet CategoryPickerView *categoryPickerView;
@property (strong, nonatomic) IBOutlet UITextField *whatToDoTextField;

- (IBAction)showWherePopUp:(id)sender;
- (IBAction)showHowManyPeoplePopUp:(id)sender;
- (IBAction)showDescriptionPopUp:(id)sender;
- (IBAction)showWhenPopUp:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)backgroundClick:(id)sender;

@end
