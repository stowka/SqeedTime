//
//  UITableViewCell+SqeedTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 19/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SqeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventCategoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *eventMinMax;
@property (weak, nonatomic) IBOutlet UILabel *eventDateStart;
@property (weak, nonatomic) IBOutlet UILabel *eventDateEnd;
@property (weak, nonatomic) IBOutlet UILabel *eventPlace;
@property (weak, nonatomic) IBOutlet UILabel *eventCreator;
@end
