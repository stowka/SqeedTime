//
//  RootViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 24/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "RootViewController.h"
#import "SqeedsViewController.h"
#import "CreateSqeedViewController.h"
#import "FriendsViewController.h"
#import "ChatViewController.h"
#import "CacheHandler.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(message)
                                                 name:@"PressNextDidComplete"
                                               object:nil];
    
    self.swipeViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.swipeViewController.dataSource = self;
    
    SqeedsViewController* startingViewController = [self viewSqeeds];
    NSArray *viewControllers = @[startingViewController];
    
    [self.swipeViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    [self.swipeViewController.view setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height + 600)];
    
    [self addChildViewController:_swipeViewController];
    [self.view addSubview:_swipeViewController.view];
    [self.swipeViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source
- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController*)viewController {
    if ([viewController class] == [ChatViewController class])
        return nil;
    else if ([viewController class] == [SqeedsViewController class])
        return nil;//[self viewChat];
    else if ([viewController class] == [CreateSqeedViewController class])
        return [self viewSqeeds];
    return [self viewCreateSqeed];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController class] == [FriendsViewController class])
        return nil;
    if ([viewController class] == [CreateSqeedViewController class])
        return [self viewFriends];
    if ([viewController class] == [SqeedsViewController class])
        return [self viewCreateSqeed];
    return [self viewSqeeds];
}

- (ChatViewController*)viewChat {
    ChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    return chatVC;
}

- (SqeedsViewController*)viewSqeeds {
    SqeedsViewController *sqeedsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SqeedsViewController"];
    return sqeedsVC;
}

- (CreateSqeedViewController*)viewCreateSqeed {
    CreateSqeedViewController *createSqeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateSqeedViewController"];
    return createSqeedVC;
}

- (FriendsViewController*)viewFriends {
    FriendsViewController *friendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    return friendsVC;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
