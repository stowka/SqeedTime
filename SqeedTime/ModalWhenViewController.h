//
//  ModalWhenViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalWhenViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIButton *close;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *startPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *endPicker;
@property (strong) UIImage* imageOfUnderlyingView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *dateChoice;
@property (strong, nonatomic) IBOutlet UISwitch *active;
@property (strong, nonatomic) IBOutlet UILabel *activeLabel;

@property BOOL date2Active;
@property BOOL date3Active;

- (IBAction)switchDate:(id)sender;
- (IBAction)activate:(id)sender;
- (IBAction)saveToCache:(id)sender;
- (IBAction)close:(id)sender;
@end
