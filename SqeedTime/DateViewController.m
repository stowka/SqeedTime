//
//  DateViewController.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 03/06/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "DateViewController.h"
#import "CacheHandler.h"

@interface DateViewController ()

@end

@implementation DateViewController

@synthesize dtst;
@synthesize dtnd;
@synthesize label;
@synthesize segmentedControl;
@synthesize switchButton;

@synthesize date2Active;
@synthesize date3Active;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bg.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    date2Active = NO;
    date3Active = NO;
    
    switchButton.hidden = YES;
    label.hidden = YES;
    
    [self save];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)close:(id)sender {
    [self save];
    [self performSegueWithIdentifier:@"segueDismissWhen" sender:self];
}

- (void)save {
    // DATE OPTION 1
    if ([segmentedControl selectedSegmentIndex] == 0) {

        [[[CacheHandler instance] createSqeed] setDateStart:[dtst date]];
        [[[CacheHandler instance] createSqeed] setDateEnd:[dtnd date]];
        
        [dtnd setMinimumDate:[NSDate dateWithTimeInterval:(60 * 30) sinceDate:[dtst date]]];
        
    // DATE OPTION 2
    } else if ([segmentedControl selectedSegmentIndex] == 1 && date2Active) {
        
        [[[CacheHandler instance] createSqeed] setDateStart2:[dtst date]];
        [[[CacheHandler instance] createSqeed] setDateEnd2:[dtnd date]];
        
        [dtnd setMinimumDate:[NSDate dateWithTimeInterval:(60 * 30) sinceDate:[dtst date]]];
    
    // DATE OPTION 3
    } else if ([segmentedControl selectedSegmentIndex] == 2 && date2Active && date3Active) {
        
        [[[CacheHandler instance] createSqeed] setDateStart3:[dtst date]];
        [[[CacheHandler instance] createSqeed] setDateEnd3:[dtnd date]];
        
        [dtnd setMinimumDate:[NSDate dateWithTimeInterval:(60 * 30) sinceDate:[dtst date]]];
    
    }
    
    if (!date2Active) {
        [[[CacheHandler instance] createSqeed] setDateStart2:nil];
        [[[CacheHandler instance] createSqeed] setDateEnd2:nil];
    }
    
    if (!date3Active) {
        [[[CacheHandler instance] createSqeed] setDateStart3:nil];
        [[[CacheHandler instance] createSqeed] setDateEnd3:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalDateDidChange"
                                                        object:nil];
}

- (IBAction)activate:(id)sender {
    if ([segmentedControl selectedSegmentIndex] == 1) {
        date2Active = [switchButton isOn];
        if (!date2Active) {
            date3Active = NO;
        }
    }
    
    if ([segmentedControl selectedSegmentIndex] == 2) {
        date3Active = [switchButton isOn];
    }
}

- (IBAction)dateOptionChanged:(id)sender {
    // DATE OPTION 1
    if ([segmentedControl selectedSegmentIndex] == 0) {
        
        [dtst setDate:[[[CacheHandler instance] createSqeed] dateStart]];
        [dtnd setMinimumDate:[NSDate dateWithTimeInterval:(60 * 30) sinceDate:[[[CacheHandler instance] createSqeed] dateStart]]];
        [dtnd setDate:[[[CacheHandler instance] createSqeed] dateEnd]];
        
        [switchButton setHidden:YES];
        [label setHidden:YES];
    } else {
        [switchButton setHidden:NO];
        [label setHidden:NO];
    }
    
    
    // DATE OPTION 2
    if ([segmentedControl selectedSegmentIndex] == 1) {
        if (date2Active) {
            [switchButton setOn:YES];
            [dtst setDate:[[[CacheHandler instance] createSqeed] dateStart2]];
            [dtnd setMinimumDate:[NSDate dateWithTimeInterval:(60 * 30) sinceDate:[[[CacheHandler instance] createSqeed] dateStart2]]];
            [dtnd setDate:[[[CacheHandler instance] createSqeed] dateEnd2]];
        } else {
            [switchButton setOn:NO];
        }
    }
    
    // DATE OPTION 3
    if ([segmentedControl selectedSegmentIndex] == 2) {
        if (!date2Active)
            [segmentedControl setSelectedSegmentIndex:1];
        if (date3Active) {
            [switchButton setOn:YES];
            [dtst setDate:[[[CacheHandler instance] createSqeed] dateStart3]];
            [dtnd setMinimumDate:[NSDate dateWithTimeInterval:(60 * 30) sinceDate:[[[CacheHandler instance] createSqeed] dateStart3]]];
            [dtnd setDate:[[[CacheHandler instance] createSqeed] dateEnd3]];
        } else {
            [switchButton setOn:NO];
        }
    }
    
    [self save];
}

-(IBAction)dateChanged:(id)sender {
    switch ([segmentedControl selectedSegmentIndex]) {
        case 1:
            if (!date2Active) {
                date2Active = YES;
                [switchButton setOn:YES];
            }
                
            break;
            
        case 2:
            if (!date3Active) {
                date3Active = YES;
                [switchButton setOn:YES];
            }
            
            break;
            
        default:
            break;
    }
    [self save];
}
@end
