//
//  MaxViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "MaxViewController.h"
#import "CacheHandler.h"
#import "AlertHelper.h"

@interface MaxViewController ()

@end

@implementation MaxViewController

@synthesize max;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    max.text = [[[CacheHandler instance] editSqeed] peopleMax];
    [max becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)editingChanged:(id)sender {
}

- (IBAction)close:(id)sender {
    if ([[[self max] text] integerValue] > 30
        || [[[self max] text] integerValue] <= 0) {
        [AlertHelper error:@"This value is bound between 1 and 30"];
    } else {
        [[[CacheHandler instance] editSqeed] setPeopleMax:[max text]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EditPeopleMaxDidChange"
                                                            object:nil];
        
        [self performSegueWithIdentifier:@"segueDismissMax" sender:self];
    }
}
@end
