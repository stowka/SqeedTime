//
//  FilterCollectionViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 02/03/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UISegmentedControl *filter;
- (IBAction)changeFilter:(id)sender;

@end
