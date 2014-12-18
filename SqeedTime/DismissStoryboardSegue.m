//
//  DismissStoryboardSegue.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "DismissStoryboardSegue.h"
#import "CreateSqeedViewController.h"

@implementation DismissStoryboardSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    CreateSqeedViewController *destViewController = self.destinationViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [destViewController updateLabels];
    }];
}

@end
