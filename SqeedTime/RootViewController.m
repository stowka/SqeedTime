//
//  RootViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "RootViewController.h"
#import "ActivitiesViewController.h"
#import "CreateSqeedViewController.h"
#import "AddFriendsToSqeedViewController.h"
#import "CacheHandler.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeViewController"];
    self.swipeViewController.dataSource = self;
    
    ActivitiesViewController* startingViewController = [self viewActivities];
    NSArray *viewControllers = @[startingViewController];
    [self.swipeViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.swipeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_swipeViewController];
    [self.view addSubview:_swipeViewController.view];
    [self.swipeViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController*)viewController
{
    if ([viewController class] == [ActivitiesViewController class])
        return nil;
    else if ([viewController class] == [CreateSqeedViewController class])
        return [self viewActivities];
    return [self viewCreateSqeed];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController class] == [AddFriendsToSqeedViewController class])
        return nil;
    if ([viewController class] == [CreateSqeedViewController class]) {
        if ([[[[CacheHandler instance] createSqeed] title] isEqualToString:@""])
            return [self viewAddFriends];
        else
            return nil;
    }
    return [self viewCreateSqeed];
}

- (ActivitiesViewController*)viewActivities
{
    ActivitiesViewController *activitiesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivitiesViewController"];
    return activitiesVC;
}

- (CreateSqeedViewController*)viewCreateSqeed
{
    CreateSqeedViewController *createSqeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateSqeedViewController"];
    return createSqeedVC;
}

- (AddFriendsToSqeedViewController*)viewAddFriends
{
    AddFriendsToSqeedViewController *addFriendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddFriendsToSqeedViewController"];
    return addFriendsVC;
}

@end
