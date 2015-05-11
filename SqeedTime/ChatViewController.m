//
//  ChatViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 23/02/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCollectionViewCell.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"
#import "Message.h"
#import "AlertHelper.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize messageList;
@synthesize sendButton;
@synthesize outbox;
@synthesize scrollView;
@synthesize sendbox;
@synthesize messages;
@synthesize sqeedId;
@synthesize control;
@synthesize navigationBar;
@synthesize bigBadge;
@synthesize smallBadge;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    messages = [[NSArray alloc] init];
    
    sqeedId = [[[CacheHandler instance] tmpSqeed] sqeedId];
    [self fetchMessages];
    
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor colorWithRed:67.0f/255.0f
                                              green:157.0f/255.0f
                                               blue:187.0f/255.0f
                                              alpha:1]
                     forState:UIControlStateNormal];
    [sendButton setEnabled:NO];
    [[outbox layer] setCornerRadius:5];
    [outbox setText:@""];
    [scrollView setScrollsToTop:NO];
    
    [messageList setScrollsToTop:YES];
    
    NSString *bigBadgeText;
    NSString *smallBadgeText;
    if ([[[[CacheHandler instance] tmpSqeed] goingCount] integerValue] < 10)
        bigBadgeText = [NSString stringWithFormat:@" %@", [[[CacheHandler instance] tmpSqeed] goingCount]];
    else
        bigBadgeText = [[[CacheHandler instance] tmpSqeed] goingCount];
    
    [[bigBadge layer] setCornerRadius:8];
    [[bigBadge layer] setMasksToBounds:YES];
    [bigBadge setText:bigBadgeText];
    
    smallBadgeText = [NSString stringWithFormat:@"%d", ([[[[CacheHandler instance] tmpSqeed] waitingCount] integerValue] + [[[[CacheHandler instance] tmpSqeed] goingCount] integerValue])];
    
    [smallBadge setText:smallBadgeText];
    
    [[navigationBar topItem] setTitle:[[[CacheHandler instance] tmpSqeed] title]];
    
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(dismissKeyboard)];
    
    [messageList addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:@"FetchMessagesDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayError)
                                                 name:@"FetchMessagesDidFail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchMessages)
                                                 name:@"MessageReceived"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchMessages)
                                                 name:@"PostMessageDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayNoMessage)
                                                 name:@"NoMessage"
                                               object:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)sv {
    if ([sv isKindOfClass:[UICollectionView class]])
         [self dismissKeyboard];
}

-(void)dismissKeyboard {
    [outbox resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatCollectionViewCell *cell;
    
    if ([(Message *)messages[[indexPath section]] fromMe]) {
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"chatMeCellID" forIndexPath:indexPath];
        [[cell layer] setCornerRadius:10];
        [[cell message] setScrollEnabled:NO];
        [[cell message] setTextColor:[UIColor whiteColor]];
        
        [cell setFromMe:[(Message *)messages[[indexPath section]] fromMe]];
        
        [[cell message] setText:[(Message *)messages[[indexPath section]] message]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        
        if ([(Message *)messages[[indexPath section]] pending]) {
            [[cell time] setText:@"Sending…"];
        } else {
            [[cell time] setText:[NSString stringWithFormat:@"%@",
                                  [formatter stringFromDate:[messages[[indexPath section]] datetime]]]];
        }
        
        [[cell message] setTextAlignment:NSTextAlignmentRight];
        [[cell message] setTextColor:[UIColor whiteColor]];
        [[cell from] setText:@"Me"];
        [[cell contentView] setBackgroundColor:[UIColor colorWithRed:67.0f/255.0f
                                                               green:157.0f/255.0f
                                                                blue:187.0f/255.0f
                                                               alpha:1]];
    } else {
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"chatOtherCellID" forIndexPath:indexPath];
        [[cell layer] setCornerRadius:10];
        [[cell message] setScrollEnabled:NO];
        [[cell message] setTextColor:[UIColor whiteColor]];
        
        [cell setFromMe:[(Message *)messages[[indexPath section]] fromMe]];
        
        [[cell from] setText:[NSString stringWithFormat:@"%@", [(Message *)messages[[indexPath section]] name]]];
        
        [[cell message] setText:[(Message *)messages[[indexPath section]] message]];
        [[cell message] setTextColor:[UIColor blackColor]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        [[cell time] setText:[NSString stringWithFormat:@"%@",
                              [formatter stringFromDate:[messages[[indexPath section]] datetime]]]];
        [[cell message] setTextAlignment:NSTextAlignmentLeft];
        [[cell contentView] setBackgroundColor:[UIColor colorWithRed:213.0f/255.0f
                                                               green:213.0f/255.0f
                                                                blue:213.0f/255.0f
                                                               alpha:1]];
    }
    
    [[cell message] setScrollsToTop:NO];
    
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text;
    text = [(Message *)messages[[indexPath section]] message];

    CGSize constraint = CGSizeMake(289.0f, 55.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return CGSizeMake(240.0f, 55.0f + size.height);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([(Message *)messages[section] fromMe]) {
        return UIEdgeInsetsMake(10, 60, 10, 0);
    } else {
        return UIEdgeInsetsMake(10, 0, 10, 60);
    }
}

- (IBAction)startEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2]; // 0.37
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    control.frame = CGRectMake(control.frame.origin.x, (control.frame.origin.y - 216.0), control.frame.size.width, control.frame.size.height);
    
    if (0 < [messageList numberOfSections])
        [messageList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:([messageList numberOfSections] - 1)] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    
    [UIView commitAnimations];
}

- (IBAction)endEditing:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    control.frame = CGRectMake(control.frame.origin.x, (control.frame.origin.y + 216.0), control.frame.size.width, control.frame.size.height);
    
    //scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height + 216.0);
    
    [UIView commitAnimations];
    
    if (0 < [messageList numberOfSections])
        [messageList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:([messageList numberOfSections] - 1)] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [outbox resignFirstResponder];
}

- (IBAction)textTyped:(id)sender {
    if (![[outbox text] isEqualToString:@""]) {
        [sendButton setEnabled:YES];
    } else {
        [sendButton setEnabled:NO];
    }
}

- (IBAction)send:(id)sender {
    [sendButton setEnabled:NO];
    
    Message *pending = [[Message alloc] init];
    [pending setMessage:[outbox text]];
    [pending setDatetime:[NSDate date]];
    [pending setFromMe:YES];
    [pending setName:@""];
    [pending setPending:YES];
    
    [messages addObject:pending];
    [messageList reloadData];
    
    // Scroll to bottom
    if (0 < [messageList numberOfSections])
        [messageList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:([messageList numberOfSections] - 1)] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    
    if (![[outbox text] isEqualToString:@""])
        [DatabaseManager postMessage:sqeedId :[outbox text]];
}

- (void)reload {
    messages = [[CacheHandler instance] chatMessages];
    [messageList reloadData];
    
    // Scroll to bottom
    if (0 < [messageList numberOfSections])
        [messageList scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:([messageList numberOfSections] - 1)] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    
}

- (void)fetchMessages {
    [DatabaseManager fetchMessages:sqeedId];
    [outbox setText:@""];
}

- (void)displayError {
    [AlertHelper error:@"Failed to fetch messages! Please try again in a moment."];
}

- (void)displayNoMessage {
    [AlertHelper alert:@"Be the first to talk about this Sqeed!" :@"No message"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
