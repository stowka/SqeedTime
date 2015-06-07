//
//  DescriptionViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *desc;

- (IBAction)close:(id)sender;

@end
