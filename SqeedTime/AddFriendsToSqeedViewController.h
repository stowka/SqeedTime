//
//  AddFriendsToSqeedViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 29/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsToSqeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendTable;
- (IBAction)save:(id)sender;
- (IBAction)addToList:(id)sender;
@end