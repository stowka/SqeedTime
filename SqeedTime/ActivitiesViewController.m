//
//  UIViewController+Activities.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 18/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "SqeedTableViewCell.h"
#import "DetailsSqeedTableViewCell.h"
#import "SqeedViewController.h"
#import "SettingsViewController.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController

NSArray* sqeeds;
int flag = -1;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[CacheHandler instance] lastUpdate] timeIntervalSinceReferenceDate] > 120)
        [[CacheHandler instance] setLastUpdate:[NSDate date]];
    if (NULL == [[[CacheHandler instance] currentUser] username])
        [[CacheHandler instance] setCurrentUser:[[CacheHandler instance] tmpUser]];
    
    [self handleRefresh:self];
    
    // PULL DOWN TO REFRESH
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor colorWithRed:255 / 255 green:50 / 255 blue:3 / 255 alpha:1];
    self.refreshControl.tintColor = [UIColor colorWithRed:255 / 255 green:50 / 255 blue:3 / 255 alpha:1];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.sqeedsTable addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - REFRESH HANDLER
- (void)handleRefresh:(id)sender {
//    if (self.refreshControl) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"MMM d, h:mm a"];
//        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
//        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor grayColor]
//                                                                    forKey:NSForegroundColorAttributeName];
//        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
//        self.refreshControl.attributedTitle = attributedTitle;
//    }
    if ([[self segmentedControl] selectedSegmentIndex] == 0)
        [[[CacheHandler instance] currentUser] fetchMySqeeds];
    else
        [[[CacheHandler instance] currentUser] fetchDiscovered];
}

- (IBAction)display:(id)sender {
    [self handleRefresh:sender];
}

- (IBAction)createSqeed:(id)sender {
    
}

- (void) refresh {
    if ([[NSDate date] timeIntervalSinceReferenceDate] - [[[CacheHandler instance] lastUpdate] timeIntervalSinceReferenceDate] > 1) {
        flag = -1;
        [[CacheHandler instance] setLastUpdate:[NSDate date]];
        if ([[self segmentedControl] selectedSegmentIndex] == 0) {
            sqeeds = [[[CacheHandler instance] currentUser] mySqeeds];
        } else {
            sqeeds = [[[CacheHandler instance] currentUser] discovered];
        }
        [self.sqeedsTable reloadData];
    }
    [self.refreshControl endRefreshing];
    NSLog(@"Refreshing...");
}

#pragma mark - PASS DATA BY SEGUE
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueSqeed"]) {
        NSIndexPath *indexPath = [self.sqeedsTable indexPathForCell:sender];
        SqeedViewController* destViewController = segue.destinationViewController;
        SqeedTableViewCell* cell = (SqeedTableViewCell*)[self.sqeedsTable cellForRowAtIndexPath:indexPath];
        destViewController.eventId = cell.eventId;
    }
}


#pragma mark - DISPLAY SQEEDS IN A TABLE VIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sqeeds count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == flag) {
        return 300;
    } else {
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == flag) {
        static NSString *cellIdentifier = @"cellDetailsID";
        DetailsSqeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                               cellIdentifier];
        if (cell == nil) {
            cell = [[DetailsSqeedTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
            
        NSString* categoryIconPath = [NSString stringWithFormat:@"%@.png", [[sqeeds[indexPath.row] sqeedCategory] categoryId]];
        UIImage *image = [UIImage imageNamed: categoryIconPath];
        [cell.eventCategoryIcon setImage:image];
        cell.eventTitle.text = (NSString*)[sqeeds[indexPath.row] title];
        cell.eventMinMax.text = [NSString stringWithFormat:@"%@ / %@", [sqeeds[indexPath.row] peopleMin], [sqeeds[indexPath.row] peopleMax]];
        cell.eventPlace.text = (NSString*)[sqeeds[indexPath.row] place];
        cell.eventCreator.text = [NSString stringWithFormat:@"by %@ %@", [sqeeds[indexPath.row] creatorFirstName], [sqeeds[indexPath.row] creatorName]];
        cell.eventId = [sqeeds[indexPath.row] sqeedId];
        cell.eventDescription.text = [[[CacheHandler instance] tmpSqeed] sqeedDescription];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        cell.eventDate.text = [NSString stringWithFormat:@"%@ — %@",[formatter stringFromDate:[sqeeds[indexPath.row] dateStart]],[formatter stringFromDate:[sqeeds[indexPath.row] dateEnd]]];

        cell.eventAnswer.selectedSegmentIndex = -1;
        cell.eventDecline.hidden = YES;
        cell.eventJoin.hidden = YES;
        if ([cell.eventCreator.text isEqualToString:[NSString stringWithFormat:@"by %@ %@",[[[CacheHandler instance] currentUser] forname], [[[CacheHandler instance] currentUser] name]]]) {
            cell.eventDeleteButton.hidden = NO;
            cell.eventAnswer.hidden = YES;
            cell.eventPeopleGoingWaiting.hidden = NO;
            cell.eventPeopleGoingWaiting.selectedSegmentIndex = -1;
            [cell.eventPeopleGoingWaiting setTitle:[NSString stringWithFormat:@"%d going", [[[[CacheHandler instance] tmpSqeed] going] count]] forSegmentAtIndex:0];
            [cell.eventPeopleGoingWaiting setTitle:[NSString stringWithFormat:@"%d waiting", [[[[CacheHandler instance] tmpSqeed] waiting] count]] forSegmentAtIndex:1];
        } else {
            cell.eventDeleteButton.hidden = YES;
            cell.eventAnswer.hidden = NO;
            cell.eventAnswer.selectedSegmentIndex = cell.hasAnswered;
            if (cell.eventAnswer.selectedSegmentIndex == 0) {
                cell.eventPeopleGoingWaiting.hidden = NO;
                cell.eventPeopleGoingWaiting.selectedSegmentIndex = -1;
                [cell.eventPeopleGoingWaiting setTitle:[NSString stringWithFormat:@"%d going", [[[[CacheHandler instance] tmpSqeed] going] count]] forSegmentAtIndex:0];
                [cell.eventPeopleGoingWaiting setTitle:[NSString stringWithFormat:@"%d waiting", [[[[CacheHandler instance] tmpSqeed] waiting] count]] forSegmentAtIndex:1];
                cell.eventAnswer.hidden = YES;
                cell.eventDecline.hidden = NO;
            } else {
                cell.eventPeopleGoingWaiting.hidden = YES;
            }
            
            if ([[self segmentedControl] selectedSegmentIndex] == 1) {
                cell.eventAnswer.hidden = YES;
                cell.eventPeopleGoingWaiting.hidden = YES;
                cell.eventJoin.hidden = NO;
            }
        }
        
        return cell;
    } else {
        static NSString *cellIdentifier = @"cellID";
        SqeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
        if (cell == nil) {
            cell = [[SqeedTableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    
        NSString* categoryIconPath = [NSString stringWithFormat:@"%@.png", [[sqeeds[indexPath.row] sqeedCategory] categoryId]];
        UIImage *image = [UIImage imageNamed: categoryIconPath];
        [cell.eventCategoryIcon setImage:image];
        cell.eventTitle.text = (NSString*)[sqeeds[indexPath.row] title];
        cell.eventMinMax.text = [NSString stringWithFormat:@"%@ / %@", [sqeeds[indexPath.row] peopleMin], [sqeeds[indexPath.row] peopleMax]];
        cell.eventPlace.text = (NSString*)[sqeeds[indexPath.row] place];
        cell.eventCreator.text = [NSString stringWithFormat:@"by %@ %@", [sqeeds[indexPath.row] creatorFirstName], [sqeeds[indexPath.row] creatorName]];
        cell.eventId = [sqeeds[indexPath.row] sqeedId];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        cell.eventDate.text = [NSString stringWithFormat:@"%@ — %@",[formatter stringFromDate:[sqeeds[indexPath.row] dateStart]],[formatter stringFromDate:[sqeeds[indexPath.row] dateEnd]]];
        return cell;
    }
}

- (void) showDetails :(NSIndexPath *)indexPath {
    // [tableView indexPathsForVisibleRows]
    [[_sqeedsTable cellForRowAtIndexPath:indexPath] setSelected:NO];
    int old_flag = flag;
    flag = indexPath.row;
    [_sqeedsTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:old_flag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_sqeedsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


// DISPLAY SQEED AFTER SELECTION
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    if (flag != indexPath.row) {
        [DatabaseManager fetchSqeed:sqeeds[indexPath.row] :indexPath];
    } else {
        flag = -1;
        [_sqeedsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
