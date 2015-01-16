//
//  SqeedsViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SqeedsViewController : UIViewController<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView* sqeedsTable;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)display:(id)sender;
- (void) showDetails :(NSNotification *)notification;
- (void)displayError;
- (void) refresh;
@end
