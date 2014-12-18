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
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)display:(id)sender;
- (IBAction)createSqeed:(id)sender;
- (UITableViewCell *)tableView:(UITableView *)tableView getDetailsSqeedCell:(NSIndexPath *)indexPath;

- (void) refresh;
@end
