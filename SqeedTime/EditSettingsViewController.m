//
//  EditSettingsViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 21/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "EditSettingsViewController.h"

@interface EditSettingsViewController ()

@end

@implementation EditSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.title = self.key;
    self.textField.text = self.value;
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TODO save changes to server
    
    [self performSegueWithIdentifier:@"segueEditSettingsSave" sender:self];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
