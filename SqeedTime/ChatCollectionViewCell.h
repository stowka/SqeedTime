//
//  ChatCollectionViewCell.h
//  SqeedTime
//
//  Created by Antoine De Gieter on 23/02/15.
//  Copyright (c) 2015 Net Production Köbe & Co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) NSString *messageId;
@property BOOL fromMe;
@property (strong, nonatomic) IBOutlet UILabel *from;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
