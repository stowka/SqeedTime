//
//  DismissStoryboardSegue.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "DismissModalSegue.h"
#import "CreateSqeedViewController.h"

@implementation DismissModalSegue

- (void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
