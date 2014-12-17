//
//  UIViewController+SqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 20/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SqeedViewController.h"
#import "CacheHandler.h"

@interface SqeedViewController()

@end

@implementation SqeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[CacheHandler instance] setCurrentSqeed:[[Sqeed alloc] init:self.eventId]];
    
    self.eventTitle.text = [[[CacheHandler instance] currentSqeed] title];
    self.eventPlace.text = [[[CacheHandler instance] currentSqeed] place];
    self.eventMinMax.text = [NSString stringWithFormat:@"%@ / %@", [[[CacheHandler instance] currentSqeed] peopleMin], [[[CacheHandler instance] currentSqeed] peopleMax]];
    self.eventDescription.text = [[[CacheHandler instance] currentSqeed] sqeedDescription];
}

@end
