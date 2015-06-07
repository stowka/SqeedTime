//
//  DescriptionViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "DescriptionViewController.h"
#import "CacheHandler.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

@synthesize desc;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    desc.text = [[[CacheHandler instance] editSqeed] sqeedDescription];
    [desc becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)close:(id)sender {
    [[[CacheHandler instance] editSqeed] setDescription:[desc text]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditDescriptionDidChange"
                                                        object:nil];
    
    
    [self performSegueWithIdentifier:@"segueDismissDesc" sender:self];
}
@end
