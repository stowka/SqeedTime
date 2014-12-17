//
//  ModalWhoViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalWhoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *min;
@property (strong, nonatomic) IBOutlet UITextField *max;
- (IBAction)saveToCache:(id)sender;

@end
