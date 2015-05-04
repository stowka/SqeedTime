//
//  FilterCollectionViewCell.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 02/03/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import "FilterCollectionViewCell.h"
#import "CacheHandler.h"
#import "DatabaseManager.h"

@implementation FilterCollectionViewCell

- (IBAction)changeFilter:(id)sender {
    int index = (int)[[self filter] selectedSegmentIndex];
    [[CacheHandler instance] setCategoryFilter:[NSString stringWithFormat:@"%d", index]];
    if (0 == index) {
        [DatabaseManager fetchDiscovered]; 
    } else {
        [DatabaseManager fetchDiscovered:[[CacheHandler instance] categoryFilter]];
    }
}
@end
