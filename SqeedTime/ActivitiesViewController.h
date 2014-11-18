//
//  UIViewController+Activities.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitiesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *sqeedsTable;

- (void)displayMySqeeds:(int)userId;
- (void)displayDiscovered:(int)userId;
- (IBAction)display:(id)sender;
@end
