//
//  DetailsSqeedTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 17/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsSqeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *eventCategoryIcon;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventMinMax;
@property (strong, nonatomic) IBOutlet UILabel *eventPlace;
@property (strong, nonatomic) IBOutlet UILabel *eventDate;
@property (strong, nonatomic) IBOutlet UILabel *eventCreator;
@property (strong, nonatomic) IBOutlet NSString *eventId;
@property (strong, nonatomic) IBOutlet UILabel *eventDescription;
@property (strong, nonatomic) IBOutlet UISegmentedControl *eventAnswer;
@property (strong, nonatomic) IBOutlet UISegmentedControl *eventPeopleGoingWaiting;
@property (strong, nonatomic) IBOutlet UIButton *eventDeleteButton;
@property (strong, nonatomic) IBOutlet UIButton *eventDecline;
@property (strong, nonatomic) IBOutlet UIButton *eventJoin;

- (IBAction)join:(id)sender;
- (IBAction)decline:(id)sender;
- (IBAction)deleteSqeed:(id)sender;
- (IBAction)answer:(id)sender;
- (IBAction)showPeople:(id)sender;
- (void) confirm :(NSString *)message :(NSString *)title;
- (int) hasAnswered;
@end
