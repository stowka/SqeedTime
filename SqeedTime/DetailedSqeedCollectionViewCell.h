//
//  DetailedSqeedCollectionViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 14/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqeed.h"
#import "MultiSelectSegmentedControl.h"

@interface DetailedSqeedCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *eventCategoryIcon;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventBigBadge;
@property (strong, nonatomic) IBOutlet UILabel *eventSmallBadge;
@property (strong, nonatomic) IBOutlet UILabel *eventPlace;
@property (strong, nonatomic) IBOutlet UILabel *eventCreator;
@property (strong, nonatomic) IBOutlet NSString *eventId;
@property (strong, nonatomic) IBOutlet UITextView *eventDescription;
@property (strong, nonatomic) IBOutlet UISegmentedControl *eventAnswer;
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *eventDateDoodle;
@property (strong, nonatomic) IBOutlet UIButton *eventMore;
@property (strong, nonatomic) IBOutlet UISegmentedControl *eventGoingWaiting;
@property (strong, nonatomic) IBOutlet UITextView *peopleList;
@property (strong, nonatomic) IBOutlet UIImageView *privacyIcon;


@property NSString *phoneExt;
@property NSString *phone;
@property Sqeed *sqeed;

- (IBAction)join:(id)sender;
- (IBAction)decline:(id)sender;
- (IBAction)deleteSqeed:(id)sender;
- (IBAction)answer:(id)sender;
- (IBAction)chooseDate:(id)sender;
- (IBAction)more:(id)sender;
- (IBAction)displayGoingWaiting:(id)sender;

- (void) confirm :(NSString *)message :(NSString *)title;
- (int) hasAnswered;
- (NSArray *)votes;

- (IBAction)facebook:(id)sender;
- (IBAction)phone:(id)sender;
- (IBAction)twitter:(id)sender;
@end
