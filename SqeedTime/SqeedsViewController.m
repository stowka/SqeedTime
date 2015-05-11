//
//  SqeedsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 13/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "SqeedsViewController.h"
#import "DatabaseManager.h"
#import "CacheHandler.h"
#import "AlertHelper.h"
#import "VoteOption.h"

#import "SqeedCollectionViewCell.h"
#import "DetailedSqeedCollectionViewCell.h"
#import "FilterCollectionViewCell.h"

@interface SqeedsViewController ()

@end

@implementation SqeedsViewController

NSArray* sqeeds;
int sqeedFlag = -1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CacheHandler instance] setEditing:NO];
    
    [[self segmentedControl] setSelectedSegmentIndex:1];
    [self fetchSqeeds];
    [[self sqeedsTable] setScrollsToTop:YES];
    
    // Observers for FetchSqeeds (all sqeeds)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:@"FetchSqeedsDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayError)
                                                 name:@"FetchSqeedsDidFail"
                                               object:nil];
    
    // Observers for FetchSqeed (show details)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showDetails:)
                                                 name:@"FetchSqeedDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayError)
                                                 name:@"FetchSqeedDidFail"
                                               object:nil];
    
    // Other observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSqeeds)
                                                 name:@"ParticipateDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSqeeds)
                                                 name:@"NotParticipateDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSqeeds)
                                                 name:@"DeleteSqeedDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchSqeeds)
                                                 name:@"CreateSqeedDidComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayActionSheet:)
                                                 name:@"DisplayMoreDidComplete"
                                               object:nil];
    
    // Pull down to refresh
    [self setRefreshControl :[[UIRefreshControl alloc] init]];
    [[self refreshControl] setTintColor:[UIColor colorWithRed:255 / 255
                                                        green:50 / 255
                                                         blue:3 / 255
                                                        alpha:1]];
    
    [[self refreshControl] addTarget:self
                              action:@selector(fetchSqeeds) forControlEvents:UIControlEventValueChanged];
    [[self sqeedsTable] addSubview:[self refreshControl]];
    
    // Double tap gesture
    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(processDoubleTap:)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [doubleTapFolderGesture setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:doubleTapFolderGesture];
}

- (void)fetchSqeeds {
    NSLog(@"fetching…");
    if ([[self segmentedControl] selectedSegmentIndex] == 0)
        [[[CacheHandler instance] currentUser] fetchMySqeeds];
    else
        [[[CacheHandler instance] currentUser] fetchDiscovered];
}

- (void) refresh {
    sqeedFlag = -1;
    [[CacheHandler instance] setLastUpdate:[NSDate date]];
    
    if ([[self segmentedControl] selectedSegmentIndex] == 0) {
        sqeeds = [[[CacheHandler instance] currentUser] mySqeeds];
    } else {
        sqeeds = [[[CacheHandler instance] currentUser] discovered];
    }
    
    [[self sqeedsTable] reloadData];
    [[self refreshControl] endRefreshing];
    if (1 == [[self segmentedControl] selectedSegmentIndex] && 0 < [sqeeds count])
        [[self sqeedsTable] scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0
                                                                        inSection:1]
                                   atScrollPosition:UICollectionViewScrollPositionTop
                                           animated:YES];
}

- (void) showDetails :(NSNotification *)notification {
    NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
    [[_sqeedsTable cellForItemAtIndexPath:indexPath] setSelected:NO];
    long section = [[self segmentedControl] selectedSegmentIndex];
    int old_flag = sqeedFlag;
    sqeedFlag = (int)[indexPath row];
    if (-1 != old_flag)
        [_sqeedsTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:old_flag inSection:section]]];
    
    #pragma mark - ERROR after creating a sqeed
        [_sqeedsTable reloadItemsAtIndexPaths:@[indexPath]];
    #pragma mark - ERROR after creating a sqeed
    
    [_sqeedsTable scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)displayError {
    [AlertHelper error :@"Network error!\nPlease try again in a moment."];
}

- (void)displayActionSheet:(NSNotification *)notification {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Edit", @"Invite friends", nil];
    [actionSheet showInView:[self view]];
}

-(void)actionSheet :(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (0 == buttonIndex) { // Delete
        [DatabaseManager deleteSqeed:[sqeeds[sqeedFlag] sqeedId]];
    } else if (1 == buttonIndex) { // Edit
        [[CacheHandler instance] setEditing:YES];
        [self performSegueWithIdentifier:@"segueEditSqeed" sender:self];
    } else if (2 == buttonIndex) { // Invite friends
        [self performSegueWithIdentifier:@"segueInviteSqeed" sender:self];
    }
}

- (IBAction)display:(id)sender {
    [self fetchSqeeds];
}

- (IBAction)createSqeed:(id)sender {
    // TODO
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if ([[self segmentedControl] selectedSegmentIndex] == 0)
        return [sqeeds count];
    else {
        if (section == 0)
            return 1;
        else
            return [sqeeds count];
    }
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if ([[self segmentedControl] selectedSegmentIndex] == 0)
        return 1;
    else
        return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == [[self segmentedControl] selectedSegmentIndex] && 0 == [indexPath section]) {
        FilterCollectionViewCell *cell;
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"filterCellID" forIndexPath:indexPath];
        [[cell filter] removeAllSegments];
        [[cell filter] insertSegmentWithTitle:@"All" atIndex:0 animated:NO];
        int index = 1;
        for (SqeedCategory *category in [[CacheHandler instance] categories]) {
            NSString* categoryIconPath = [NSString stringWithFormat:@"%@.png", [category categoryId]];
            UIImage *image = [UIImage imageNamed: categoryIconPath];
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
            [image drawInRect:CGRectMake(0, 0, 20, 20)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [[cell filter] insertSegmentWithImage:newImage atIndex:index animated:NO];
            index += 1;
        }
        index = (int)[[[CacheHandler instance] categoryFilter] integerValue];
        [[cell filter] setSelectedSegmentIndex:index];
        return cell;
    }
    
    if ([indexPath row] != sqeedFlag) {
        SqeedCollectionViewCell *cell;
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"sqeedCellID" forIndexPath:indexPath];
        [cell setBackgroundColor :[UIColor whiteColor]];
        
        // COLORS
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
        
        [[cell eventCreator] setTextColor:[UIColor grayColor]];
        [[cell eventTitle] setTextColor:[UIColor blackColor]];
        [[cell eventPlace] setTextColor:[UIColor blackColor]];
        [[cell eventDate] setTextColor:[UIColor blackColor]];
        
        // CATEGORY ICON
        NSString* categoryIconPath = [NSString stringWithFormat:@"%@.png", [[sqeeds[[indexPath row]] sqeedCategory] categoryId]];
        UIImage *image = [UIImage imageNamed: categoryIconPath];
        [[cell eventCategoryIcon] setImage:image];
        [[cell eventTitle] setText:(NSString*)[sqeeds[indexPath.row] title]];
        
        // PRIVACY
        if ([[sqeeds[[indexPath row]] privateAccess] isEqualToString:@"0"]) {
            image = [UIImage imageNamed:@"public.png"];
            [[cell privacyIcon] setImage:image];
        } else if ([[sqeeds[[indexPath row]] privateAccess] isEqualToString:@"1"]) {
            image = [UIImage imageNamed:@"private.png"];
            [[cell privacyIcon] setImage:image];
        }
        
        // BADGES
        [[cell eventSmallBadge] setHidden:NO];
        NSString *bigBadgeText;
        NSString *smallBadgeText;
        
        if ([[sqeeds[[indexPath row]] goingCount] integerValue] < 10)
            bigBadgeText = [NSString stringWithFormat:@" %@", [sqeeds[[indexPath row]] goingCount]];
        else
            bigBadgeText = [sqeeds[[indexPath row]] goingCount];
        
        smallBadgeText = [NSString stringWithFormat:@"%ld", ([[sqeeds[[indexPath row]] goingCount] integerValue] + [[sqeeds[[indexPath row]] waitingCount] integerValue])];
        
        [[cell eventBigBadge] setText:bigBadgeText];
        [[cell eventSmallBadge] setText:smallBadgeText];
        
        // DO NOT DISPLAY SMALL BADGE IF DISCOVERED
        if (1 == [[self segmentedControl] selectedSegmentIndex])
            [[cell eventSmallBadge] setHidden:YES];
        
        [[[cell eventBigBadge] layer] setCornerRadius:8];
        [[[cell eventBigBadge] layer] setMasksToBounds:YES];
        
        // PLACE + CREATOR
        [[cell eventPlace] setText:(NSString*)[sqeeds[indexPath.row] place]];
        [[cell eventCreator] setText:[NSString stringWithFormat:@"by %@", [sqeeds[[indexPath row]] creatorName]]];
        
        [cell setEventId:[sqeeds[[indexPath row]] sqeedId]];
        
        // DATE
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        [[cell eventDate] setText:[NSString stringWithFormat:@"%@ — %@",[formatter stringFromDate:[sqeeds[[indexPath row]] dateStart]],[formatter stringFromDate:[sqeeds[[indexPath row]] dateEnd]]]];
        
        if ([[[cell eventCreator] text] isEqualToString:[NSString stringWithFormat:@"by %@",
                                                         [[[CacheHandler instance] currentUser] name]]]) {
            
            [[cell contentView] setBackgroundColor:[UIColor colorWithRed:178.0 / 255.0
                                                                   green:178.0 / 255.0
                                                                    blue:178.0 / 255.0
                                                                   alpha:1]];
            
            [[cell eventCreator] setTextColor:[UIColor whiteColor]];
            [[cell eventTitle] setTextColor:[UIColor whiteColor]];
            [[cell eventPlace] setTextColor:[UIColor whiteColor]];
            [[cell eventDate] setTextColor:[UIColor whiteColor]];
        }
        [[cell layer] setCornerRadius:10.0f];
//        CGRect shadowFrame = [[cell layer] bounds];
//        CGPathRef shadowPath = [[UIBezierPath bezierPathWithRect:shadowFrame] CGPath];
//        [[cell layer] setShadowPath:shadowPath];
//        [[cell layer] setShadowColor:[[UIColor blackColor] CGColor]];
//        [[cell layer] setShadowOffset:CGSizeMake(3.0f, 3.0f)];
//        [[cell layer] setShadowRadius:5.0f];
//        [[cell layer] setShadowOpacity:0.50f];
        return cell;
    } else {
        DetailedSqeedCollectionViewCell *cell;
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"detailedSqeedCellID" forIndexPath:indexPath];
        
        [cell setSqeed:sqeeds[[indexPath row]]];
        [[CacheHandler instance] setEditSqeed:[cell sqeed]];
        
        NSString* categoryIconPath = [NSString stringWithFormat:@"%@.png", [[sqeeds[[indexPath row]] sqeedCategory] categoryId]];
        UIImage *image = [UIImage imageNamed: categoryIconPath];
        [[cell eventCategoryIcon] setImage:image];
        [[cell eventTitle] setText:(NSString*)[sqeeds[[indexPath row]] title]];
        
        
        // ANSWER SEGMENTS
        [[cell eventAnswer] removeAllSegments];
        [[cell eventAnswer] insertSegmentWithTitle:@"Join!" atIndex:0 animated:NO];
        [[cell eventAnswer] insertSegmentWithTitle:@"Sorry…" atIndex:1 animated:NO];
        
        // COLORS
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
        
        [[cell eventCreator] setTextColor:[UIColor grayColor]];
        [[cell eventTitle] setTextColor:[UIColor blackColor]];
        [[cell eventPlace] setTextColor:[UIColor blackColor]];
        [[cell eventDescription] setTextColor:[UIColor blackColor]];
        [[cell eventDateDoodle] setTintColor:[UIColor colorWithRed:35.0 / 255.0
                                                             green:186.0 / 255.0
                                                              blue:18.0 / 255.0
                                                             alpha:1]];
        [[cell eventAnswer] setTintColor:[UIColor colorWithRed:255.0 / 255.0
                                                         green:50.0 / 255.0
                                                          blue:3.0 / 255.0
                                                         alpha:1]];
        [[cell eventGoingWaiting] setTintColor:[UIColor colorWithRed:67.0 / 255.0
                                                               green:157.0 / 255.0
                                                                blue:187.0 / 255.0
                                                               alpha:1]];
        
        [[cell peopleList] setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [[cell peopleList] setTextColor:[UIColor blackColor]];
        [[cell peopleList] setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]];
        
        // BADGES
        [[cell eventSmallBadge] setHidden:NO];
        NSString *bigBadgeText;
        
        if ([[sqeeds[[indexPath row]] goingCount] integerValue] < 10)
            bigBadgeText = [NSString stringWithFormat:@" %@", [sqeeds[[indexPath row]] goingCount]];
        else
            bigBadgeText = [sqeeds[[indexPath row]] goingCount];
        
        [[cell eventBigBadge] setText:bigBadgeText];
        [[cell eventSmallBadge] setText:[sqeeds[[indexPath row]] waitingCount]];
        
        // DO NOT DISPLAY SMALL BADGE IF DISCOVERED
        if (1 == [[self segmentedControl] selectedSegmentIndex])
            [[cell eventSmallBadge] setHidden:YES];
        
        [[[cell eventBigBadge] layer] setCornerRadius:8];
        [[[cell eventBigBadge] layer] setMasksToBounds:YES];
        
        // PLACE + CREATOR
        [[cell eventPlace] setText:(NSString*)[sqeeds[indexPath.row] place]];
        [[cell eventCreator] setText:[NSString stringWithFormat:@"by %@", [sqeeds[[indexPath row]] creatorName]]];
        
        [cell setEventId:[sqeeds[[indexPath row]] sqeedId]];
        [[cell eventDescription] setText:[[[CacheHandler instance] tmpSqeed] sqeedDescription]];
        
        // DATES
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        
        [[cell eventAnswer] setSelectedSegmentIndex:-1];
        [cell displayGoingWaiting:self];
        
        [cell setPhoneExt:[[sqeeds[[indexPath row]] creator] phoneExt]];
        [cell setPhone:[[sqeeds[[indexPath row]] creator] phone]];
        
        int n = 0;
        [[cell eventDateDoodle] removeAllSegments];
        
        for (VoteOption *vo in [sqeeds[[indexPath row]] dateOptions]) {
            [[cell eventDateDoodle] insertSegmentWithTitle:[NSString stringWithFormat:@"%@ (%@)", [formatter stringFromDate:[vo datetimeStart]], [vo voteCount]] atIndex:n animated:NO];
            n += 1;
        }
        
        if ([[sqeeds[[indexPath row]] dateOptions] count] == 1) {
            [[cell eventDateDoodle] setSelectedSegmentIndex:0];
        } else {
            int n = 0;
            for (VoteOption *vo in [[cell sqeed] dateOptions]) {
                NSLog(@"voteOption = %@", [vo voteId]);
                for (VoteOption *optionId in [[cell sqeed] voteIds]) {
                    if ([optionId.voteId isEqualToString:vo.voteId]) {
                        [[cell eventDateDoodle] setSelectedSegmentIndex:n];
                    }
                }
                n += 1;
            }
        }
        
        // IF CREATED BY CURRENT USER
        if ([[[cell eventCreator] text] isEqualToString:[NSString stringWithFormat:@"by %@",
                                                         [[[CacheHandler instance] currentUser] name]]]) {
            
            [[cell contentView] setBackgroundColor:[UIColor colorWithRed:178.0 / 255.0
                                                                   green:178.0 / 255.0
                                                                    blue:178.0 / 255.0
                                                                   alpha:1]];
            
            [[cell eventCreator] setTextColor:[UIColor whiteColor]];
            [[cell eventTitle] setTextColor:[UIColor whiteColor]];
            [[cell eventPlace] setTextColor:[UIColor whiteColor]];
            [[cell eventDescription] setTextColor:[UIColor whiteColor]];
            [[cell eventMore] setTintColor:[UIColor whiteColor]];
            [[cell eventMore] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[cell eventDateDoodle] setTintColor:[UIColor whiteColor]];
            [[cell eventAnswer] setTintColor:[UIColor whiteColor]];
            [[cell eventGoingWaiting] setTintColor:[UIColor whiteColor]];
            [[cell peopleList] setTextColor:[UIColor whiteColor]];
            [[cell peopleList] setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]];
            
            [[cell eventMore] setHidden:NO];
            [[cell eventAnswer] setSelectedSegmentIndex:0];
            if (0 == [[self segmentedControl] selectedSegmentIndex])
                [[cell eventAnswer] setEnabled:NO forSegmentAtIndex:1];
            
        } else { // CREATED BY SOMEONE ELSE
            [[cell eventMore] setHidden:YES];
            [[cell eventAnswer] setHidden:NO];
            
            [[cell eventAnswer] setSelectedSegmentIndex:[cell hasAnswered]];
            
            if (1 == [[self segmentedControl] selectedSegmentIndex]) {
                [[cell eventAnswer] removeSegmentAtIndex:1 animated:NO];
            }
        }
        [[cell layer] setCornerRadius:10.0f];
//        CGRect shadowFrame = [[cell layer] bounds];
//        CGPathRef shadowPath = [[UIBezierPath bezierPathWithRect:shadowFrame] CGPath];
//        [[cell layer] setShadowPath:shadowPath];
//        [[cell layer] setShadowColor:[[UIColor blackColor] CGColor]];
//        [[cell layer] setShadowOffset:CGSizeMake(3.0f, 3.0f)];
//        [[cell layer] setShadowRadius:5.0f];
//        [[cell layer] setShadowOpacity:0.50f];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] != sqeedFlag) {
        [DatabaseManager fetchSqeed:sqeeds[indexPath.row] :indexPath];
    } else {
        sqeedFlag = -1;
        [_sqeedsTable reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == [[self segmentedControl] selectedSegmentIndex] && 0 == [indexPath section]) {
        return CGSizeMake(320.0f, 50.0f);
    }
    
    if([indexPath row] == sqeedFlag) {
        NSString *text = [[[CacheHandler instance] tmpSqeed] sqeedDescription];
        CGSize constraint = CGSizeMake(283.0f, 100.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        return CGSizeMake(302.0f, 350.0f + size.height);
    } else {
        return CGSizeMake(302.0f, 104);
    }
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

#pragma mark - Light status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) processDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:[self sqeedsTable]];
        NSIndexPath *indexPath = [[self sqeedsTable] indexPathForItemAtPoint:point];
        NSLog(@"%d, %d", indexPath.row, sqeedFlag);
        if (indexPath.row == sqeedFlag) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(displayChat)
                                                         name:@"WillDisplayChat"
                                                       object:nil];
        }
    }
}

- (void)displayChat {
    [[NSNotificationCenter defaultCenter] removeObserver:@"WillDisplayChat"];
    [self performSegueWithIdentifier:@"segueChat" sender:self];
}

@end
