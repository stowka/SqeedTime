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
    self.refreshControl.backgroundColor = [UIColor colorWithRed:255 / 255 green:50 / 255 blue:3 / 255 alpha:1];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.sqeedsTable addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - REFRESH HANDLER
- (void)handleRefresh:(id)sender {
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
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
        [[CacheHandler instance] setLastUpdate:[NSDate date]];
        if ([[self segmentedControl] selectedSegmentIndex] == 0) {
            sqeeds = [[[CacheHandler instance] currentUser] mySqeeds];
        } else {
            sqeeds = [[[CacheHandler instance] currentUser] discovered];
        }
        [self.sqeedsTable reloadData];
    }
    [self.refreshControl endRefreshing];
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
        //DetailsSqeedTableViewCell *cell = (DetailsSqeedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        return 300;
    } else {
        //SqeedTableViewCell *cell = (SqeedTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
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
        if ([cell.eventCreator.text isEqualToString:[NSString stringWithFormat:@"by %@ %@",[[[CacheHandler instance] currentUser] forname], [[[CacheHandler instance] currentUser] name]]]) {
            cell.eventDeleteButton.hidden = NO;
        } else {
            cell.eventDeleteButton.hidden = YES;
        }
        cell.eventDescription.text = [sqeeds[indexPath.row] sqeedDescription];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, HH:mm"];
        cell.eventDate.text = [NSString stringWithFormat:@"%@ — %@",[formatter stringFromDate:[sqeeds[indexPath.row] dateStart]],[formatter stringFromDate:[sqeeds[indexPath.row] dateEnd]]];
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


// DISPLAY SQEED AFTER SELECTION
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [tableView indexPathsForVisibleRows]
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    if (flag == indexPath.row) {
        flag = -1;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        int old_flag = flag;
        flag = indexPath.row;
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:old_flag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
