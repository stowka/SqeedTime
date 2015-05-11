//
//  ChatViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 23/02/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatCollectionViewCell.h"

@interface ChatViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *outbox;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UICollectionView *messageList;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *sendbox;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSString *sqeedId;
@property (strong, nonatomic) IBOutlet UIControl *control;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UILabel *bigBadge;
@property (strong, nonatomic) IBOutlet UILabel *smallBadge;

- (IBAction)textTyped:(id)sender;
- (IBAction)send:(id)sender;
- (void)reload;
- (void)displayNoMessage;
- (void)displayError;
- (void)fetchMessages;
- (IBAction)startEditing:(id)sender;
- (IBAction)endEditing:(id)sender;
@end
