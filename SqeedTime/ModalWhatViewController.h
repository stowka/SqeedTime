//
//  ModalWhatViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 22/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalWhatViewController : UIViewController
@property (strong, nonatomic, readonly) IBOutlet UITextField *description;
- (IBAction)saveToCache:(id)sender;
@end
