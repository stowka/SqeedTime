//
//  UIViewController+Activities.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sqeedsTable;

- (void)fetchMySqeeds:(int)userId;
- (void)fetchDiscovered:(int)userId;
- (void)displaySqeeds:(NSDictionary*)data;
- (IBAction)display:(id)sender;
@end
