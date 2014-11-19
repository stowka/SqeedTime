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

@end
