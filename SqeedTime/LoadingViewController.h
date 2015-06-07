//
//  LoadingViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 04/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loader;

- (void)dismiss;
@end
