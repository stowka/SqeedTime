//
//  PlaceViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "PlaceViewController.h"
#import "CacheHandler.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController

@synthesize place;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    place.text = [[[CacheHandler instance] editSqeed] place];
    [place becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)editingChanged:(id)sender {
}

- (IBAction)close:(id)sender {
    [[[CacheHandler instance] editSqeed] setPlace:[place text]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditPlaceDidChange"
                                                        object:nil];
    
    [self performSegueWithIdentifier:@"segueDismissPlace" sender:self];
}
@end
