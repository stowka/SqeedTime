//
//  FriendsViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/12/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendTable;
- (IBAction)remove:(id)sender;

@end
