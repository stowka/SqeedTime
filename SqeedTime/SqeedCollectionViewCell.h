//
//  SqeedCollectionViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 14/01/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SqeedCollectionViewCell : UICollectionViewCell<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *eventCategoryIcon;
@property (strong, nonatomic) IBOutlet UILabel *eventTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventBigBadge;
@property (strong, nonatomic) IBOutlet UILabel *eventSmallBadge;
@property (strong, nonatomic) IBOutlet UILabel *eventPlace;
@property (strong, nonatomic) IBOutlet UILabel *eventDate;
@property (strong, nonatomic) IBOutlet UILabel *eventCreator;
@property (strong, nonatomic) IBOutlet UIImageView *privacyIcon;
@property (strong, nonatomic) IBOutlet NSString *eventId;
@end
