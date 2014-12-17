//
//  UITableViewCell+SqeedTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 19/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SqeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *eventCategoryIcon;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventMinMax;
@property (strong, nonatomic) IBOutlet UILabel *eventPlace;
@property (strong, nonatomic) IBOutlet NSString *eventId;
@end
