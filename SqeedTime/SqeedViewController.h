//
//  UIViewController+SqeedViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 20/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SqeedViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventMinMax;
@property (strong, nonatomic) IBOutlet UILabel *eventDay;
@property (strong, nonatomic) IBOutlet UILabel *eventPlace;
@property (strong, nonatomic) IBOutlet UILabel *eventCreator;
@property (strong, nonatomic) IBOutlet UISegmentedControl *voteTime;
@property (strong, nonatomic) IBOutlet UISegmentedControl *voteChoice;
@property (strong, nonatomic) IBOutlet UILabel *eventDescription;

@property (strong, nonatomic) IBOutlet NSString *eventId;
@end
