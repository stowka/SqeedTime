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

#import "SqeedCollectionViewCell.h"
#import "DetailedSqeedCollectionViewCell.h"

@interface SqeedsViewController ()

@end

@implementation SqeedsViewController

NSArray* sqeeds;
int sqeedFlag = -1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[CacheHandler instance] lastUpdate] timeIntervalSinceReferenceDate] > 120)
        [[CacheHandler instance] setLastUpdate:[NSDate date]];
    if (NULL == [[[CacheHandler instance] currentUser] username])
        [[CacheHandler instance] setCurrentUser:[[CacheHandler instance] tmpUser]];
    
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
}

- (void)fetchSqeeds {
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
    NSLog(@"Reloading data");
}

- (void) showDetails :(NSNotification *)notification {
    NSIndexPath *indexPath = [[notification userInfo] objectForKey:@"indexPath"];
    [[_sqeedsTable cellForItemAtIndexPath:indexPath] setSelected:NO];
    int old_flag = sqeedFlag;
    sqeedFlag = (int)[indexPath row];
    if (-1 != old_flag)
        [_sqeedsTable reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:old_flag inSection:0]]];
    [_sqeedsTable reloadItemsAtIndexPaths:@[indexPath]];
    [_sqeedsTable scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)displayError {
    [AlertHelper error :@"Error!\nPlease try again in a moment."];
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
        // TODO
    } else if (2 == buttonIndex) { // Invite friends
        // TODO
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
    return [sqeeds count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] != sqeedFlag) {
        SqeedCollectionViewCell *cell;
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"sqeedCellID" forIndexPath:indexPath];
        [cell setBackgroundColor :[UIColor whiteColor]];
        
        NSString* categoryIconPath = [NSString stringWithFormat:@"%@.png", [[sqeeds[[indexPath row]] sqeedCategory] categoryId]];
        UIImage *image = [UIImage imageNamed: categoryIconPath];
        [[cell eventCategoryIcon] setImage:image];
        [[cell eventTitle] setText:(NSString*)[sqeeds[indexPath.row] title]];
        
        NSString *bigBadgeText;
        
        if ([[sqeeds[[indexPath row]] peopleMin] integerValue] < 10)
            bigBadgeText = [NSString stringWithFormat:@" %@", [sqeeds[[indexPath row]] peopleMin]];
        else
            bigBadgeText = [sqeeds[[indexPath row]] peopleMin];
            
        [[cell eventBigBadge] setText:bigBadgeText];
        [[cell eventSmallBadge] setText:[sqeeds[[indexPath row]] peopleMax]];
        [[[cell eventBigBadge] layer] setCornerRadius:8];
        [[[cell eventBigBadge] layer] setMasksToBounds:YES];
        [[cell eventPlace] setText:(NSString*)[sqeeds[indexPath.row] place]];
        [[cell eventCreator] setText:[NSString stringWithFormat:@"by %@ %@", [sqeeds[[indexPath row]] creatorFirstName], [sqeeds[[indexPath row]] creatorName]]];
        [cell setEventId:[sqeeds[[indexPath row]] sqeedId]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        [[cell eventDate] setText:[NSString stringWithFormat:@"%@ — %@",[formatter stringFromDate:[sqeeds[[indexPath row]] dateStart]],[formatter stringFromDate:[sqeeds[[indexPath row]] dateEnd]]]];
        
        if ([[[cell eventCreator] text] isEqualToString:[NSString stringWithFormat:@"by %@ %@",
                                                     [[[CacheHandler instance] currentUser] forname],
                                                     [[[CacheHandler instance] currentUser] name]]]) {
            
            [cell setBackgroundColor :[UIColor whiteColor]];
            UIView *selectionColor = [[UIView alloc] init];
            [selectionColor setBackgroundColor :[UIColor colorWithRed:35 / 255.0
                                                                green:186 / 255.0
                                                                 blue:18 / 255.0
                                                                alpha:0.1]];
            [cell setBackgroundView:selectionColor];
            [selectionColor setBackgroundColor:[UIColor whiteColor]];
        }
        return cell;
    } else {
        DetailedSqeedCollectionViewCell *cell;
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"detailedSqeedCellID" forIndexPath:indexPath];
        
        NSString* categoryIconPath = [NSString stringWithFormat:@"%@.png", [[sqeeds[[indexPath row]] sqeedCategory] categoryId]];
        UIImage *image = [UIImage imageNamed: categoryIconPath];
        [[cell eventCategoryIcon] setImage:image];
        [[cell eventTitle] setText:(NSString*)[sqeeds[indexPath.row] title]];
        
        NSString *bigBadgeText;
        
        if ([[sqeeds[[indexPath row]] peopleMin] integerValue] < 10)
            bigBadgeText = [NSString stringWithFormat:@" %@", [sqeeds[[indexPath row]] peopleMin]];
        else
            bigBadgeText = [sqeeds[[indexPath row]] peopleMin];
        
        [[cell eventBigBadge] setText:bigBadgeText];
        [[cell eventSmallBadge] setText:[sqeeds[[indexPath row]] peopleMax]];
        [[[cell eventBigBadge] layer] setCornerRadius:8];
        [[[cell eventBigBadge] layer] setMasksToBounds:YES];
        [[cell eventPlace] setText:(NSString*)[sqeeds[indexPath.row] place]];
        [[cell eventCreator] setText:[NSString stringWithFormat:@"by %@ %@", [sqeeds[[indexPath row]] creatorFirstName], [sqeeds[[indexPath row]] creatorName]]];
        [cell setEventId:[sqeeds[[indexPath row]] sqeedId]];
        [[cell eventDescription] setText:[[[CacheHandler instance] tmpSqeed] sqeedDescription]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        [[cell eventDate] setText:[NSString stringWithFormat:@"%@ — %@",[formatter stringFromDate:[sqeeds[[indexPath row]] dateStart]],[formatter stringFromDate:[sqeeds[[indexPath row]] dateEnd]]]];
        
        [[cell eventAnswer] setSelectedSegmentIndex:-1];
        
        if ([[[cell eventCreator] text] isEqualToString:[NSString stringWithFormat:@"by %@ %@",
                                                     [[[CacheHandler instance] currentUser] forname],
                                                     [[[CacheHandler instance] currentUser] name]]]) {
            
            [cell setBackgroundColor :[UIColor whiteColor]];
            UIView *selectionColor = [[UIView alloc] init];
            [selectionColor setBackgroundColor :[UIColor colorWithRed:35 / 255.0
                                                                green:186 / 255.0
                                                                 blue:18 / 255.0
                                                                alpha:0.1]];
            [cell setBackgroundView:selectionColor];
            [selectionColor setBackgroundColor:[UIColor whiteColor]];
            
            [[cell eventMore] setHidden:NO];
            [[cell eventAnswer] setHidden:YES];
            [[cell eventPeopleGoingWaiting] setHidden:NO];
            [[cell eventPeopleGoingWaiting] setSelectedSegmentIndex:-1];
            [[cell eventPeopleGoingWaiting] setTitle:[NSString stringWithFormat:@"%d going",
                                                    [[[[CacheHandler instance] tmpSqeed] going] count]]
                                   forSegmentAtIndex:0];
            [[cell eventPeopleGoingWaiting] setTitle:[NSString stringWithFormat:@"%d waiting",
                                                    [[[[CacheHandler instance] tmpSqeed] waiting] count]]
                                   forSegmentAtIndex:1];
        } else {
            [[cell eventMore] setHidden:YES];
            [[cell eventAnswer] setHidden:NO];
            [[cell eventAnswer] setSelectedSegmentIndex:[cell hasAnswered]];
            if (0 == [[cell eventAnswer]selectedSegmentIndex]) {
                [[cell eventPeopleGoingWaiting] setHidden:NO];
                [[cell eventPeopleGoingWaiting] setSelectedSegmentIndex:-1];
                [[cell eventPeopleGoingWaiting] setTitle:[NSString stringWithFormat:@"%d going",
                                                        [[[[CacheHandler instance] tmpSqeed] going] count]]
                                       forSegmentAtIndex:0];
                [cell.eventPeopleGoingWaiting setTitle:[NSString stringWithFormat:@"%d waiting",
                                                        [[[[CacheHandler instance] tmpSqeed] waiting] count]]
                                     forSegmentAtIndex:1];
                [[cell eventAnswer] setHidden:YES];
            } else {
                [[cell eventPeopleGoingWaiting] setHidden:YES];
            }
            
            if (1 == [[self segmentedControl] selectedSegmentIndex]) {
                [[cell eventAnswer] setHidden:YES];
                [[cell eventPeopleGoingWaiting] setHidden:YES];
            }
        }
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

    if([indexPath row] == sqeedFlag) {
        return CGSizeMake(302, 322);
    } else {
        return CGSizeMake(302, 104);
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

@end
