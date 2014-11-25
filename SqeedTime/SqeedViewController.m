//
//  UIViewController+SqeedViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 20/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "SqeedViewController.h"
#import "CCacheHandler.h"

@interface SqeedViewController()

@end

@implementation SqeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.eventId integerValue])
        [[CCacheHandler instance] setCache_currentSqeed:[[MSqeed alloc] initWithId:(int)[self.eventId integerValue]]];
    
    
    self.eventTitle.text = [[[CCacheHandler instance] cache_currentSqeed] sTitle];
    self.eventPlace.text = [[[CCacheHandler instance] cache_currentSqeed] sPlace];
    self.eventMinMax.text = [NSString stringWithFormat:@"%d / %d", [[[CCacheHandler instance] cache_currentSqeed] sPeopleMin], [[[CCacheHandler instance] cache_currentSqeed] sPeopleMax]];
    self.eventDescription.text = [[[CCacheHandler instance] cache_currentSqeed] sDescription];
}

@end
