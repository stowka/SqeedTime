//
//  UIViewController+Activities.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SqeedTableViewCell.h"
#import "SqeedsTableView.h"

@interface ActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet SqeedsTableView* sqeedsTable;
@property (strong, nonatomic) IBOutlet SqeedTableViewCell* cell;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end
