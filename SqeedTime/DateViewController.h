//
//  DateViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UIDatePicker *dtst;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtnd;

@property (strong, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property BOOL date2Active;
@property BOOL date3Active;

- (IBAction)close:(id)sender;
- (IBAction)activate:(id)sender;
- (IBAction)dateOptionChanged:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (void)save;

@end
