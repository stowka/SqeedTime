//
//  GroupTableViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 28/05/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property NSString *groupId;

@end
