//
//  UIViewController+Activities.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqeedTableViewCell.h"

@interface ActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView* sqeedsTable;
@property (strong, nonatomic) IBOutlet SqeedTableViewCell* cell;
@property (strong, nonatomic) IBOutlet NSNumber* userId;


- (NSDictionary*)fetchMySqeeds:(int)userId;
- (NSDictionary*)fetchDiscovered:(int)userId;
- (void)displaySqeeds:(NSDictionary*)data;
- (IBAction)display:(id)sender;
@end
