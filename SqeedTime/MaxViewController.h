//
//  MaxViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaxViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *max;

- (IBAction)editingChanged:(id)sender;
- (IBAction)close:(id)sender;

@end
