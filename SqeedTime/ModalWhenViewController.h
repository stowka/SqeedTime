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

- (IBAction)saveToCache:(id)sender;
@end
