//
//  SqeedsViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectSegmentedControl.h"

@interface SqeedsViewController : UIViewController<UIActionSheetDelegate, MultiSelectSegmentedControlDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView* sqeedsTable;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UINavigationBar *navbar;

- (IBAction)display:(id)sender;
- (void)showDetails :(NSNotification *)notification;
- (void)displayError;
- (void)refresh;
- (void)reload;
- (void)attempt;
- (void)voteFailed:(NSNotification *)notif;
@end
