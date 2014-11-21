//
//  EditSettingsViewController.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSString* value;
@end
